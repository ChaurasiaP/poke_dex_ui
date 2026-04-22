from fastapi import APIRouter, HTTPException, Query
from app.db import get_connection
from app.schemas.pokemon import (
    PokemonDetail, PokemonListItem, PokemonStat, PokemonSprite,
    PokemonType, PaginatedPokemonList, PokemonUpdateRequest, PokemonCreateRequest,
)

router = APIRouter(prefix="/pokemon", tags=["Pokemon"])


# ─── Helper: build full PokemonDetail from DB ─────────────────────────────────

def _fetch_pokemon_detail(cur, pokemon_id: int) -> PokemonDetail:
    """Fetch full Pokémon detail from DB using an open cursor."""
    cur.execute("SELECT * FROM pokemon_details WHERE id = %s;", (pokemon_id,))
    detail = cur.fetchone()
    if not detail:
        raise HTTPException(status_code=404, detail=f"Pokémon {pokemon_id} not found")

    cur.execute(
        "SELECT type_name, slot FROM pokemon_types WHERE pokemon_id = %s ORDER BY slot;",
        (pokemon_id,),
    )
    types = [PokemonType(type=r["type_name"], slot=r["slot"]) for r in cur.fetchall()]

    cur.execute(
        "SELECT stat_name, base_stat, effort FROM pokemon_stats WHERE pokemon_id = %s;",
        (pokemon_id,),
    )
    stats = [PokemonStat(**r) for r in cur.fetchall()]

    cur.execute(
        "SELECT front_default, front_shiny, back_shiny, official_artwork FROM pokemon_sprites WHERE pokemon_id = %s;",
        (pokemon_id,),
    )
    sprite_row = cur.fetchone()
    sprite = PokemonSprite(**sprite_row) if sprite_row else None

    return PokemonDetail(
        id=detail["id"],
        name=detail["name"],
        height=detail["height"],
        weight=detail["weight"],
        base_experience=detail["base_experience"],
        is_default=detail["is_default"],
        power=detail["power"],
        types=types,
        stats=stats,
        sprite=sprite,
    )


# ─── READ: List ────────────────────────────────────────────────────────────────

@router.get("", response_model=PaginatedPokemonList)
def list_pokemon(
    offset: int = Query(default=0, ge=0, description="Number of records to skip"),
    limit: int = Query(default=20, ge=1, le=100, description="Max records to return"),
):
    """Returns a paginated list of all Pokémon with their primary sprite and types."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("SELECT COUNT(*) AS total FROM pokemon_details;")
        total = cur.fetchone()["total"]

        cur.execute(
            """
            SELECT
                d.id,
                d.name,
                s.front_default AS front_sprite,
                COALESCE(
                    JSON_AGG(
                        JSON_BUILD_OBJECT('type', t.type_name, 'slot', t.slot)
                        ORDER BY t.slot
                    ) FILTER (WHERE t.type_name IS NOT NULL),
                    '[]'::json
                ) AS types
            FROM pokemon_details d
            LEFT JOIN pokemon_sprites s ON d.id = s.pokemon_id
            LEFT JOIN pokemon_types t ON d.id = t.pokemon_id
            GROUP BY d.id, d.name, s.front_default
            ORDER BY d.id
            LIMIT %s OFFSET %s;
            """,
            (limit, offset),
        )
        rows = cur.fetchall()

        results = [
            PokemonListItem(
                id=row["id"],
                name=row["name"],
                front_sprite=row["front_sprite"],
                types=[PokemonType(**t) for t in (row["types"] or [])],
            )
            for row in rows
        ]

        return PaginatedPokemonList(total=total, offset=offset, limit=limit, results=results)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


# ─── READ: Single ──────────────────────────────────────────────────────────────

@router.get("/{pokemon_id}", response_model=PokemonDetail)
def get_pokemon(pokemon_id: int):
    """Returns full detail for a single Pokémon including types, stats, and sprites."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        return _fetch_pokemon_detail(cur, pokemon_id)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


# ─── CREATE ────────────────────────────────────────────────────────────────────

@router.post("", response_model=PokemonDetail, status_code=201)
def create_pokemon(body: PokemonCreateRequest):
    """Creates a new Pokémon entry with optional types, stats, and sprite."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        # Check id uniqueness
        cur.execute("SELECT id FROM pokemon_details WHERE id = %s;", (body.id,))
        if cur.fetchone():
            raise HTTPException(status_code=409, detail=f"Pokémon with id {body.id} already exists")

        # Insert base detail
        cur.execute(
            """
            INSERT INTO pokemon_details (id, name, height, weight, base_experience, is_default, power)
            VALUES (%s, %s, %s, %s, %s, %s, %s);
            """,
            (body.id, body.name, body.height, body.weight, body.base_experience, body.is_default, body.power),
        )

        # Insert types
        for t in body.types:
            cur.execute(
                "INSERT INTO pokemon_types (pokemon_id, type_name, slot) VALUES (%s, %s, %s);",
                (body.id, t.type, t.slot),
            )

        # Insert stats
        for s in body.stats:
            cur.execute(
                "INSERT INTO pokemon_stats (pokemon_id, stat_name, base_stat, effort) VALUES (%s, %s, %s, %s);",
                (body.id, s.stat_name, s.base_stat, s.effort),
            )

        # Insert sprite
        if body.sprite:
            cur.execute(
                """
                INSERT INTO pokemon_sprites (pokemon_id, front_default, front_shiny, back_shiny, official_artwork)
                VALUES (%s, %s, %s, %s, %s);
                """,
                (body.id, body.sprite.front_default, body.sprite.front_shiny,
                 body.sprite.back_shiny, body.sprite.official_artwork),
            )

        conn.commit()
        return _fetch_pokemon_detail(cur, body.id)

    except HTTPException:
        raise
    except Exception as e:
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


# ─── UPDATE ────────────────────────────────────────────────────────────────────

@router.put("/{pokemon_id}", response_model=PokemonDetail)
def update_pokemon(pokemon_id: int, body: PokemonUpdateRequest):
    """
    Updates one or more fields of a Pokémon's details (partial update).
    Returns the full updated Pokémon detail.
    """
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("SELECT id FROM pokemon_details WHERE id = %s;", (pokemon_id,))
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail=f"Pokémon {pokemon_id} not found")

        updates = body.model_dump(exclude_none=True)
        if not updates:
            raise HTTPException(status_code=422, detail="No fields provided for update")

        set_clauses = ", ".join(f"{col} = %s" for col in updates.keys())
        values = list(updates.values()) + [pokemon_id]

        cur.execute(f"UPDATE pokemon_details SET {set_clauses} WHERE id = %s;", values)
        conn.commit()

        return _fetch_pokemon_detail(cur, pokemon_id)

    except HTTPException:
        raise
    except Exception as e:
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


# ─── DELETE ────────────────────────────────────────────────────────────────────

@router.delete("/{pokemon_id}", status_code=200)
def delete_pokemon(pokemon_id: int):
    """
    Deletes a Pokémon and all associated types, stats, sprites (via CASCADE).
    Also removes them from favourites and team if present.
    """
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("SELECT id FROM pokemon_details WHERE id = %s;", (pokemon_id,))
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail=f"Pokémon {pokemon_id} not found")

        cur.execute("DELETE FROM pokemon_details WHERE id = %s;", (pokemon_id,))
        conn.commit()

        return {"message": "Pokémon deleted", "pokemon_id": pokemon_id}

    except HTTPException:
        raise
    except Exception as e:
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()

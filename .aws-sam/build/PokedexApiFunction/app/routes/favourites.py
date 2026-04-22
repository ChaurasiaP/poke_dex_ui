from fastapi import APIRouter, HTTPException
from app.db import get_connection
from app.schemas.favourites import FavouriteItem, FavouriteListResponse
from app.schemas.pokemon import PokemonType

router = APIRouter(prefix="/favourites", tags=["Favourites"])


@router.get("", response_model=FavouriteListResponse)
def list_favourites():
    """Returns all Pokémon in favourites with sprite and types."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute(
            """
            SELECT
                f.id              AS favourite_id,
                f.pokemon_id,
                f.added_at,
                d.name,
                s.front_default   AS front_sprite,
                COALESCE(
                    JSON_AGG(
                        JSON_BUILD_OBJECT('type', t.type_name, 'slot', t.slot)
                        ORDER BY t.slot
                    ) FILTER (WHERE t.type_name IS NOT NULL),
                    '[]'::json
                ) AS types
            FROM pokemon_favourites f
            JOIN pokemon_details d   ON d.id = f.pokemon_id
            LEFT JOIN pokemon_sprites s ON s.pokemon_id = f.pokemon_id
            LEFT JOIN pokemon_types  t  ON t.pokemon_id = f.pokemon_id
            GROUP BY f.id, f.pokemon_id, f.added_at, d.name, s.front_default
            ORDER BY f.added_at DESC;
            """
        )
        rows = cur.fetchall()

        results = [
            FavouriteItem(
                favourite_id=row["favourite_id"],
                pokemon_id=row["pokemon_id"],
                name=row["name"],
                front_sprite=row["front_sprite"],
                types=[PokemonType(**t) for t in (row["types"] or [])],
                added_at=row["added_at"].isoformat(),
            )
            for row in rows
        ]

        return FavouriteListResponse(total=len(results), results=results)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


@router.post("/{pokemon_id}", status_code=201)
def add_favourite(pokemon_id: int):
    """Adds a Pokémon to favourites. Returns 409 if duplicate, 404 if not found."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("SELECT id FROM pokemon_details WHERE id = %s;", (pokemon_id,))
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail=f"Pokémon {pokemon_id} not found")

        cur.execute("SELECT id FROM pokemon_favourites WHERE pokemon_id = %s;", (pokemon_id,))
        if cur.fetchone():
            raise HTTPException(status_code=409, detail=f"Pokémon {pokemon_id} is already in favourites")

        cur.execute(
            "INSERT INTO pokemon_favourites (pokemon_id) VALUES (%s) RETURNING id, added_at;",
            (pokemon_id,),
        )
        row = cur.fetchone()
        conn.commit()

        return {
            "message": "Added to favourites",
            "favourite_id": row["id"],
            "pokemon_id": pokemon_id,
            "added_at": row["added_at"].isoformat(),
        }

    except HTTPException:
        raise
    except Exception as e:
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


@router.delete("/{pokemon_id}", status_code=200)
def remove_favourite(pokemon_id: int):
    """Removes a Pokémon from favourites. Returns 404 if not in favourites."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute(
            "DELETE FROM pokemon_favourites WHERE pokemon_id = %s RETURNING id;",
            (pokemon_id,),
        )
        deleted = cur.fetchone()
        if not deleted:
            raise HTTPException(status_code=404, detail=f"Pokémon {pokemon_id} not found in favourites")

        conn.commit()
        return {"message": "Removed from favourites", "pokemon_id": pokemon_id}

    except HTTPException:
        raise
    except Exception as e:
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


@router.get("/check/{pokemon_id}")
def is_favourite(pokemon_id: int):
    """Returns whether a specific Pokémon is in favourites."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            "SELECT id, added_at FROM pokemon_favourites WHERE pokemon_id = %s;",
            (pokemon_id,),
        )
        row = cur.fetchone()
        return {
            "pokemon_id": pokemon_id,
            "is_favourite": row is not None,
            "added_at": row["added_at"].isoformat() if row else None,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()

from fastapi import APIRouter, HTTPException
from app.db import get_connection
from app.schemas.team import TeamEntry, TeamListResponse, TeamAddRequest, TeamUpdateRequest
from app.schemas.pokemon import PokemonType

router = APIRouter(prefix="/team", tags=["Team"])

MAX_TEAM_SIZE = 6


# ─── Helper: fetch single team entry detail ───────────────────────────────────

def _build_team_entry(row: dict) -> TeamEntry:
    return TeamEntry(
        team_id=row["team_id"],
        pokemon_id=row["pokemon_id"],
        name=row["name"],
        nickname=row["nickname"],
        front_sprite=row["front_sprite"],
        types=[PokemonType(**t) for t in (row["types"] or [])],
        added_at=row["added_at"].isoformat(),
    )


def _team_query(cur, where_clause: str = "", params: tuple = ()):
    """Run the standard team SELECT, optionally filtered."""
    cur.execute(
        f"""
        SELECT
            tm.id             AS team_id,
            tm.pokemon_id,
            tm.nickname,
            tm.added_at,
            d.name,
            s.front_default   AS front_sprite,
            COALESCE(
                JSON_AGG(
                    JSON_BUILD_OBJECT('type', t.type_name, 'slot', t.slot)
                    ORDER BY t.slot
                ) FILTER (WHERE t.type_name IS NOT NULL),
                '[]'::json
            ) AS types
        FROM pokemon_team tm
        JOIN pokemon_details d   ON d.id = tm.pokemon_id
        LEFT JOIN pokemon_sprites s ON s.pokemon_id = tm.pokemon_id
        LEFT JOIN pokemon_types  t  ON t.pokemon_id = tm.pokemon_id
        {where_clause}
        GROUP BY tm.id, tm.pokemon_id, tm.nickname, tm.added_at, d.name, s.front_default
        ORDER BY tm.added_at ASC;
        """,
        params,
    )


# ─── READ ─────────────────────────────────────────────────────────────────────

@router.get("", response_model=TeamListResponse)
def get_team():
    """Returns all Pokémon currently in the team (max 6)."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        _team_query(cur)
        rows = cur.fetchall()
        results = [_build_team_entry(r) for r in rows]
        return TeamListResponse(total=len(results), max_size=MAX_TEAM_SIZE, results=results)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


# ─── CREATE ───────────────────────────────────────────────────────────────────

@router.post("/{pokemon_id}", status_code=201)
def add_to_team(pokemon_id: int, body: TeamAddRequest = None):
    """
    Adds a Pokémon to the team with an optional nickname.
    Returns 409 if already on team or team is full. Returns 404 if Pokémon not found.
    """
    if body is None:
        body = TeamAddRequest()

    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        # Verify Pokémon exists
        cur.execute("SELECT id, name FROM pokemon_details WHERE id = %s;", (pokemon_id,))
        pokemon = cur.fetchone()
        if not pokemon:
            raise HTTPException(status_code=404, detail=f"Pokémon {pokemon_id} not found")

        # Check team size
        cur.execute("SELECT COUNT(*) AS total FROM pokemon_team;")
        if cur.fetchone()["total"] >= MAX_TEAM_SIZE:
            raise HTTPException(status_code=409, detail=f"Team is full (max {MAX_TEAM_SIZE})")

        # Check duplicate
        cur.execute("SELECT id FROM pokemon_team WHERE pokemon_id = %s;", (pokemon_id,))
        if cur.fetchone():
            raise HTTPException(status_code=409, detail=f"Pokémon {pokemon_id} is already in the team")

        nickname = body.nickname if body.nickname else pokemon["name"]
        cur.execute(
            "INSERT INTO pokemon_team (pokemon_id, nickname) VALUES (%s, %s) RETURNING id, added_at;",
            (pokemon_id, nickname),
        )
        row = cur.fetchone()
        conn.commit()

        return {
            "message": "Added to team",
            "team_id": row["id"],
            "pokemon_id": pokemon_id,
            "nickname": nickname,
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


# ─── UPDATE (nickname) ────────────────────────────────────────────────────────

@router.patch("/{pokemon_id}", status_code=200)
def update_team_nickname(pokemon_id: int, body: TeamUpdateRequest):
    """Updates the nickname of a team member."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute(
            "UPDATE pokemon_team SET nickname = %s WHERE pokemon_id = %s RETURNING id;",
            (body.nickname, pokemon_id),
        )
        updated = cur.fetchone()
        if not updated:
            raise HTTPException(status_code=404, detail=f"Pokémon {pokemon_id} not found in team")

        conn.commit()
        return {"message": "Nickname updated", "pokemon_id": pokemon_id, "nickname": body.nickname}

    except HTTPException:
        raise
    except Exception as e:
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


# ─── DELETE ───────────────────────────────────────────────────────────────────

@router.delete("/{pokemon_id}", status_code=200)
def remove_from_team(pokemon_id: int):
    """Removes a Pokémon from the team. Returns 404 if not in team."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute(
            "DELETE FROM pokemon_team WHERE pokemon_id = %s RETURNING id;",
            (pokemon_id,),
        )
        deleted = cur.fetchone()
        if not deleted:
            raise HTTPException(status_code=404, detail=f"Pokémon {pokemon_id} not found in team")

        conn.commit()
        return {"message": "Removed from team", "pokemon_id": pokemon_id}

    except HTTPException:
        raise
    except Exception as e:
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()


# ─── CHECK ────────────────────────────────────────────────────────────────────

@router.get("/check/{pokemon_id}")
def is_in_team(pokemon_id: int):
    """Returns whether a Pokémon is on the team. Useful for toggling the team button in Flutter."""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            "SELECT id, nickname, added_at FROM pokemon_team WHERE pokemon_id = %s;",
            (pokemon_id,),
        )
        row = cur.fetchone()
        return {
            "pokemon_id": pokemon_id,
            "is_in_team": row is not None,
            "nickname": row["nickname"] if row else None,
            "added_at": row["added_at"].isoformat() if row else None,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if conn:
            conn.close()

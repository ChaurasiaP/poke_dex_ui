from typing import List, Optional
from pydantic import BaseModel
from app.schemas.pokemon import PokemonType


class TeamEntry(BaseModel):
    team_id: int
    pokemon_id: int
    name: str
    nickname: str
    front_sprite: Optional[str] = None
    types: List[PokemonType] = []
    added_at: str  # ISO 8601 timestamp


class TeamListResponse(BaseModel):
    total: int
    max_size: int
    results: List[TeamEntry]


class TeamAddRequest(BaseModel):
    """Optional nickname when adding a Pokémon to the team."""
    nickname: Optional[str] = None


class TeamUpdateRequest(BaseModel):
    """Body for PATCH /team/{pokemon_id} — update nickname."""
    nickname: str

from typing import List, Optional
from pydantic import BaseModel
from app.schemas.pokemon import PokemonType


class FavouriteItem(BaseModel):
    favourite_id: int
    pokemon_id: int
    name: str
    front_sprite: Optional[str] = None
    types: List[PokemonType] = []
    added_at: str  # ISO 8601 timestamp


class FavouriteListResponse(BaseModel):
    total: int
    results: List[FavouriteItem]

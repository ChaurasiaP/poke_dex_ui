from typing import List, Optional
from pydantic import BaseModel


class PokemonType(BaseModel):
    type: str
    slot: int


class PokemonStat(BaseModel):
    stat_name: str
    base_stat: int
    effort: int


class PokemonSprite(BaseModel):
    front_default: Optional[str] = None
    front_shiny: Optional[str] = None
    back_shiny: Optional[str] = None
    official_artwork: Optional[str] = None


class PokemonListItem(BaseModel):
    id: int
    name: str
    front_sprite: Optional[str] = None
    types: List[PokemonType] = []


class PokemonDetail(BaseModel):
    id: int
    name: str
    height: Optional[int] = None
    weight: Optional[float] = None
    base_experience: Optional[int] = None
    is_default: Optional[bool] = None
    power: Optional[float] = None
    types: List[PokemonType] = []
    stats: List[PokemonStat] = []
    sprite: Optional[PokemonSprite] = None


class PaginatedPokemonList(BaseModel):
    total: int
    offset: int
    limit: int
    results: List[PokemonListItem]


class PokemonCreateRequest(BaseModel):
    """Body for POST /pokemon — create a brand-new Pokémon entry."""
    id: int                               # explicit id required (must not already exist)
    name: str
    height: Optional[int] = None
    weight: Optional[float] = None
    base_experience: Optional[int] = None
    is_default: Optional[bool] = True
    power: Optional[float] = None
    types: List[PokemonType] = []
    stats: List[PokemonStat] = []
    sprite: Optional[PokemonSprite] = None


class PokemonUpdateRequest(BaseModel):
    """All fields optional — only provided fields are updated (PATCH-style PUT)."""
    name: Optional[str] = None
    height: Optional[int] = None
    weight: Optional[float] = None
    base_experience: Optional[int] = None
    is_default: Optional[bool] = None
    power: Optional[float] = None

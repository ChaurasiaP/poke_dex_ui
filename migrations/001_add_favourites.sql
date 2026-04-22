-- =============================================================================
-- Migration: Add pokemon_favourites table
-- Run on your PostgreSQL DB (on EC2):
--   psql -U pokeuser -d pokedex -f migrations/001_add_favourites.sql
-- =============================================================================

CREATE TABLE IF NOT EXISTS pokemon_favourites (
    id          SERIAL PRIMARY KEY,
    pokemon_id  INT NOT NULL REFERENCES pokemon_details(id) ON DELETE CASCADE,
    added_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(pokemon_id)   -- a pokemon can only be favourited once
);

-- Index for fast lookups
CREATE INDEX IF NOT EXISTS idx_favourites_pokemon_id ON pokemon_favourites(pokemon_id);

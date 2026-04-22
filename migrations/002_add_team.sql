-- =============================================================================
-- Migration: Add pokemon_team table
-- Run on your PostgreSQL DB (on EC2):
--   psql -U pokeuser -d pokedex -f migrations/002_add_team.sql
-- =============================================================================

CREATE TABLE IF NOT EXISTS pokemon_team (
    id          SERIAL PRIMARY KEY,
    pokemon_id  INT NOT NULL REFERENCES pokemon_details(id) ON DELETE CASCADE,
    nickname    TEXT,
    added_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(pokemon_id)   -- a pokemon can only appear once in the team
);

-- Index for fast lookups
CREATE INDEX IF NOT EXISTS idx_team_pokemon_id ON pokemon_team(pokemon_id);

-- Optional: enforce max team size of 6 via a CHECK on count
-- (enforced at API layer instead, for flexibility)

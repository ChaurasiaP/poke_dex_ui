import pandas as pd
import psycopg2
from psycopg2.extras import execute_values

import os

conn = psycopg2.connect(
    host=os.environ.get("DB_HOST", "localhost"),
    database=os.environ.get("DB_NAME", "poke_db_csv"),
    user=os.environ.get("DB_USER", "postgres"),
    password=os.environ.get("DB_PASSWORD", "Mmxa106@"),
    port=int(os.environ.get("DB_PORT", 5432))
)
cur = conn.cursor()

def bulk_insert(query, df):
    execute_values(
        cur,
        query,
        df.values.tolist()
    )
    conn.commit()

# ---- Load CSVs ----
df_pokemon = pd.read_csv("pokemon_details.csv")
df_types = pd.read_csv("pokemon_types.csv")
df_stats = pd.read_csv("pokemon_stats.csv")
df_sprites = pd.read_csv("pokemon_sprites.csv")

# ---- Insert pokemon_details ----
bulk_insert("""
    INSERT INTO pokemon_details
    (id, name, height, weight, base_experience, is_default)
    VALUES %s
    ON CONFLICT (id) DO NOTHING
""", df_pokemon)
print("pokemon data inserted")

# ---- Insert pokemon_types ----
bulk_insert("""
    INSERT INTO pokemon_types
    (id, type_name, slot)
    VALUES %s
    ON CONFLICT DO NOTHING
""", df_types)

# ---- Insert pokemon_stats ----
bulk_insert("""
    INSERT INTO pokemon_stats
    (pokemon_id, stat_name, base_stat)
    VALUES %s
    ON CONFLICT DO NOTHING
""", df_stats)

# ---- Insert pokemon_sprites ----
bulk_insert("""
    INSERT INTO pokemon_sprites
    (pokemon_id, front_default, front_shiny, back_default, back_shiny, official_artwork)
    VALUES %s
    ON CONFLICT (id) DO NOTHING
""", df_sprites)

cur.close()
conn.close()

print("🎉 All CSV data inserted into PostgreSQL")

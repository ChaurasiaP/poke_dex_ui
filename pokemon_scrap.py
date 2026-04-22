import requests
import psycopg2
from psycopg2.extras import execute_values

BASE_URL = "https://pokeapi.co/api/v2/pokemon/"

# DB connection
conn = psycopg2.connect(
    host="localhost",
    database="poke_db",
    user="postgres",
    password="Mmxa106@",
    port=5432
)

cur = conn.cursor()

# url = "https://pokeapi.co/api/v2/pokemon?limit=1350"
# response = requests.get(url)
# data = response.json()["results"]

# insert_query = """
# INSERT INTO pokemons_list (name, api_url)
# VALUES (%s, %s)
# ON CONFLICT (name) DO NOTHING;
# """

# for p in data:
#     cur.execute(insert_query, (p["name"], p["url"]))

# conn.commit()
# cur.close()
# conn.close()

# print("✅ All Pokémon inserted successfully")

def insert_pokemon(data):
    cur.execute("""
        INSERT INTO pokemon_details (id, name, height, weight, base_experience, is_default)
        VALUES (%s, %s, %s, %s, %s, %s)
        ON CONFLICT (id) DO NOTHING
    """, (
        data["id"],
        data["name"],
        data["height"],
        data["weight"],
        data["base_experience"],
        data["is_default"]
    ))

def insert_types(pokemon_id, types):
    rows = [
        (pokemon_id, t["type"]["name"], t["slot"])
        for t in types
    ]
    execute_values(
        cur,
        """
        INSERT INTO pokemon_types (pokemon_id, type_name, slot)
        VALUES %s
        ON CONFLICT DO NOTHING
        """,
        rows
    )

def insert_stats(pokemon_id, stats):
    rows = [
        (pokemon_id, s["stat"]["name"], s["base_stat"], s["effort"])
        for s in stats
    ]
    execute_values(
        cur,
        """
        INSERT INTO pokemon_stats (pokemon_id, stat_name, base_stat, effort)
        VALUES %s
        ON CONFLICT DO NOTHING
        """,
        rows
    )

def insert_sprites(pokemon_id, sprites):
    cur.execute("""
        INSERT INTO pokemon_sprites
        (pokemon_id, front_default, front_shiny, back_default, back_shiny, official_artwork)
        VALUES (%s, %s, %s, %s, %s, %s)
        ON CONFLICT (pokemon_id) DO NOTHING
    """, (
        pokemon_id,
        sprites["front_default"],
        sprites["front_shiny"],
        sprites["back_default"],
        sprites["back_shiny"],
        sprites["other"]["official-artwork"]["front_default"]
    ))

def scrape_pokemon(pokemon_id):
    response = requests.get(f"{BASE_URL}{pokemon_id}")
    if response.status_code != 200:
        print(f"❌ Failed for ID {pokemon_id}")
        return

    data = response.json()

    insert_pokemon(data)
    insert_types(data["id"], data["types"])
    insert_stats(data["id"], data["stats"])
    insert_sprites(data["id"], data["sprites"])

    conn.commit()
    print(f"✅ Stored Pokémon {data['name']} (ID {pokemon_id})")

# 🔁 Run for all Pokémon
for pid in range(1, 1351):
    scrape_pokemon(pid)

cur.close()
conn.close()
print("🎉 All Pokémon stored successfully")


#

# CREATE TABLE pokemons_list (
#     id SERIAL PRIMARY KEY,
#     name VARCHAR(100) NOT NULL UNIQUE,
#     api_url TEXT NOT NULL
# );

# CREATE TABLE pokemon_details (
#     id INTEGER PRIMARY KEY,sS
#     name TEXT NOT NULL,
#     height INTEGER,
#     base_experience INTEGER,
#     is_default BOOLEAN,
# 	power DOUBLE PRECISION	
# );


# select * from pokemons_list
# select * from pokemon_details
# select * from pokemon_sprites
# select * from pokemon_stats
# select * from pokemon_types



# ALTER TABLE pokemon_sprites
# DROP COLUMN back_default;

# ALTER TABLE pokemon_stats
# DROP COLUMN id;

# ALTER TABLE pokemon_types
# DROP COLUMN id;



# ALTER TABLE pokemon_details
# ADD COLUMN weight DOUBLE PRECISION;


# SELECT current_database(), current_user;

# CREATE TABLE pokemon_types (
#     id SERIAL PRIMARY KEY,
#     pokemon_id INT REFERENCES pokemons_list(id),
#     type_name VARCHAR(50),
#     slot INT
# );

# CREATE TABLE pokemon_stats (
#     id SERIAL PRIMARY KEY,
#     pokemon_id INT REFERENCES pokemons_list(id),
#     stat_name VARCHAR(50),
#     base_stat INT,
#     effort INT
# );

# CREATE TABLE pokemon_sprites (
#     pokemon_id INT PRIMARY KEY REFERENCES pokemons_list(id),
#     front_default TEXT,
#     front_shiny TEXT,
#     back_default TEXT,
#     back_shiny TEXT,
#     official_artwork TEXT
# );


# select * from pokemon_details d  left join pokemon_types t on d.id = t.pokemon_id

# WITH pokemon_with_types AS (
#     SELECT
#         d.id,
#         d.name,
#         d.height,
#         d.base_experience,
#         d.is_default,
#         d.weight,
#         JSON_AGG(
#             JSON_BUILD_OBJECT(
#                 'type', t.type_name,
#                 'slot', t.slot
#             )
#             ORDER BY t.slot
#         ) AS types
#     FROM pokemon_details d
#     LEFT JOIN pokemon_types t
#         ON d.id = t.pokemon_id
#     GROUP BY
#         d.id,
#         d.name,
#         d.height,
#         d.base_experience,
#         d.is_default,
#         d.weight
# )
# SELECT *
# FROM pokemon_with_types
# ORDER BY id;
#
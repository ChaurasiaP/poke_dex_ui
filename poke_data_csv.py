import requests
import pandas as pd

BASE_URL = "https://pokeapi.co/api/v2/pokemon/"

# These are lists of dictionaries
pokemon_rows = []
type_rows = []
stat_rows = []
sprite_rows = []

for pid in range(1, 1351):
    res = requests.get(f"{BASE_URL}{pid}")

    if res.status_code != 200:
        print(f"❌ Failed for ID {pid}")
        continue

    data = res.json()

    # ---- pokemon_details ----
    pokemon_rows.append({
        "id": data["id"],
        "name": data["name"],
        "height": data["height"],
        "weight": data["weight"],
        "base_experience": data["base_experience"],
        "is_default": data["is_default"]
    })

    # ---- pokemon_types ----
    for t in data["types"]:
        type_rows.append({
            "pokemon_id": data["id"],
            "type_name": t["type"]["name"],
            "slot": t["slot"]
        })

    # ---- pokemon_stats ----
    for s in data["stats"]:
        stat_rows.append({
            "pokemon_id": data["id"],
            "stat_name": s["stat"]["name"],
            "base_stat": s["base_stat"],
            "effort": s["effort"]
        })

    # ---- pokemon_sprites ----
    sprite_rows.append({
        "pokemon_id": data["id"],
        "front_default": data["sprites"]["front_default"],
        "front_shiny": data["sprites"]["front_shiny"],
        "back_default": data["sprites"]["back_default"],
        "back_shiny": data["sprites"]["back_shiny"],
        "official_artwork": data["sprites"]["other"]["official-artwork"]["front_default"]
    })

    print(f"✅ Fetched {data['name']}")

# ---- Convert to DataFrames ----
df_pokemon = pd.DataFrame(pokemon_rows)
df_types = pd.DataFrame(type_rows)
df_stats = pd.DataFrame(stat_rows)
df_sprites = pd.DataFrame(sprite_rows)

# ---- Save CSVs ----
df_pokemon.to_csv("pokemon_details.csv", index=False)
df_types.to_csv("pokemon_types.csv", index=False)
df_stats.to_csv("pokemon_stats.csv", index=False)
df_sprites.to_csv("pokemon_sprites.csv", index=False)

print("🎉 CSV files generated successfully")

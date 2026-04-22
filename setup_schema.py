import os
import psycopg2

def main():
    print("Connecting to DB...")
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST", "localhost"),
        database=os.environ.get("DB_NAME", "pokedex"),
        user=os.environ.get("DB_USER", "postgres"),
        password=os.environ.get("DB_PASSWORD", "PokedexPassword123!"),
        port=int(os.environ.get("DB_PORT", 5432))
    )
    cur = conn.cursor()
    
    print("Creating tables...")
    schema = """
    CREATE TABLE IF NOT EXISTS pokemons_list (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL UNIQUE,
        api_url TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS pokemon_details (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        height INTEGER,
        weight DOUBLE PRECISION,
        base_experience INTEGER,
        is_default BOOLEAN,
        power DOUBLE PRECISION	
    );

    CREATE TABLE IF NOT EXISTS pokemon_types (
        id SERIAL PRIMARY KEY,
        pokemon_id INT REFERENCES pokemons_list(id),
        type_name VARCHAR(50),
        slot INT
    );

    CREATE TABLE IF NOT EXISTS pokemon_stats (
        id SERIAL PRIMARY KEY,
        pokemon_id INT REFERENCES pokemons_list(id),
        stat_name VARCHAR(50),
        base_stat INT,
        effort INT
    );

    CREATE TABLE IF NOT EXISTS pokemon_sprites (
        id SERIAL PRIMARY KEY,
        pokemon_id INT REFERENCES pokemons_list(id),
        front_default TEXT,
        front_shiny TEXT,
        back_default TEXT,
        back_shiny TEXT,
        official_artwork TEXT
    );
    """
    
    cur.execute(schema)
    conn.commit()
    print("Base schema created.")
    
    print("Running migrations...")
    for migration_file in ["001_add_favourites.sql", "002_add_team.sql"]:
        with open(f"migrations/{migration_file}", "r") as f:
            sql = f.read()
            cur.execute(sql)
            conn.commit()
            print(f"Ran migration: {migration_file}")
            
    cur.close()
    conn.close()
    print("Database schema setup complete.")

if __name__ == "__main__":
    main()

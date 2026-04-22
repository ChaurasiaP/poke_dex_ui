
CREATE TABLE pokemons_list (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    api_url TEXT NOT NULL
);

CREATE TABLE pokemon_details (
    id INTEGER PRIMARY KEY,sS
    name TEXT NOT NULL,
    height INTEGER,
    base_experience INTEGER,
    is_default BOOLEAN,
	power DOUBLE PRECISION	
);


select * from pokemons_list
select * from pokemon_details
select * from pokemon_sprites
select * from pokemon_stats
select * from pokemon_types



ALTER TABLE pokemon_sprites
DROP COLUMN back_default;

ALTER TABLE pokemon_stats
DROP COLUMN id;

ALTER TABLE pokemon_types
DROP COLUMN id;



ALTER TABLE pokemon_details
ADD COLUMN weight DOUBLE PRECISION;


SELECT current_database(), current_user;

CREATE TABLE pokemon_types (
    id SERIAL PRIMARY KEY,
    pokemon_id INT REFERENCES pokemons_list(id),
    type_name VARCHAR(50),
    slot INT
);

CREATE TABLE pokemon_stats (
    id SERIAL PRIMARY KEY,
    pokemon_id INT REFERENCES pokemons_list(id),
    stat_name VARCHAR(50),
    base_stat INT,
    effort INT
);

CREATE TABLE pokemon_sprites (
    pokemon_id INT PRIMARY KEY REFERENCES pokemons_list(id),
    front_default TEXT,
    front_shiny TEXT,
    back_default TEXT,
    back_shiny TEXT,
    official_artwork TEXT
);


select * from pokemon_details d  left join pokemon_types t on d.id = t.pokemon_id

WITH pokemon_with_types AS (
    SELECT
        d.id,
        d.name,
        d.height,
        d.base_experience,
        d.is_default,
        d.weight,
        JSON_AGG(
            JSON_BUILD_OBJECT(
                'type', t.type_name,
                'slot', t.slot
            )
            ORDER BY t.slot
        ) AS types
    FROM pokemon_details d
    LEFT JOIN pokemon_types t
        ON d.id = t.pokemon_id
    GROUP BY
        d.id,
        d.name,
        d.height,
        d.base_experience,
        d.is_default,
        d.weight
)
SELECT *
FROM pokemon_with_types
ORDER BY id;


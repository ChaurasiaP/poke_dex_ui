import 'dart:convert';
PokemonDataModel pokemonApiModelFromJson(String str) =>
    PokemonDataModel.fromJson(json.decode(str));

class PokemonDataModel {
    PokemonDataModel({
        required this.results,
    });

    final List<Pokemon> results;

    factory PokemonDataModel.fromJson(Map<String, dynamic> json){ 
        return PokemonDataModel(
            results: json["Results"] == null ? [] : List<Pokemon>.from(json["Results"]!.map((x) => Pokemon.fromJson(x))),
        );
    }

}

class Pokemon {
    Pokemon({
        required this.id,
        required this.name,
        required this.height,
        required this.abilities,
        required this.types,
        required this.species,
        required this.sprites,
    });

    final int? id;
    final String? name;
    final int? height;
    final List<Ability> abilities;
    final List<Type> types;
    final Species? species;
    final Sprites? sprites;

    factory Pokemon.fromJson(Map<String, dynamic> json){ 
        return Pokemon(
            id: json["id"],
            name: json["name"],
            height: json["height"],
            abilities: json["abilities"] == null ? [] : List<Ability>.from(json["abilities"]!.map((x) => Ability.fromJson(x))),
            types: json["types"] == null ? [] : List<Type>.from(json["types"]!.map((x) => Type.fromJson(x))),
            species: json["species"] == null ? null : Species.fromJson(json["species"]),
            sprites: json["sprites"] == null ? null : Sprites.fromJson(json["sprites"]),
        );
    }

}

class Ability {
    Ability({
        required this.name,
        required this.isHidden,
    });

    final String? name;
    final bool? isHidden;

    factory Ability.fromJson(Map<String, dynamic> json){ 
        return Ability(
            name: json["name"],
            isHidden: json["is_hidden"],
        );
    }

}

class Type {
    Type({
        required this.type,
    });

    final String type;

    factory Type.fromJson(Map<String, dynamic> json){ 
        return Type(
            type: json["type"],
        );
    }

}

class Species {
    Species({
        required this.name,
        required this.url,
    });

    final String? name;
    final String? url;

    factory Species.fromJson(Map<String, dynamic> json){ 
        return Species(
            name: json["name"],
            url: json["url"],
        );
    }

}

class Sprites {
    Sprites({
        required this.other,
    });

    final Other? other;

    factory Sprites.fromJson(Map<String, dynamic> json){ 
        return Sprites(
            other: json["other"] == null ? null : Other.fromJson(json["other"]),
        );
    }

}

class Other {
    Other({
        required this.dreamWorld,
        required this.showdown,
    });

    final DreamWorld? dreamWorld;
    final Showdown? showdown;

    factory Other.fromJson(Map<String, dynamic> json){ 
        return Other(
            dreamWorld: json["dream_world"] == null ? null : DreamWorld.fromJson(json["dream_world"]),
            showdown: json["showdown"] == null ? null : Showdown.fromJson(json["showdown"]),
        );
    }

}

class DreamWorld {
    DreamWorld({
        required this.frontDefault,
        required this.frontShiny,
    });

    final String? frontDefault;
    final String? frontShiny;

    factory DreamWorld.fromJson(Map<String, dynamic> json){ 
        return DreamWorld(
            frontDefault: json["front_default"],
            frontShiny: json["front_shiny"],
        );
    }

}

class Showdown {
    Showdown({
        required this.frontDefault,
        required this.frontFemale,
    });

    final String? frontDefault;
    final dynamic frontFemale;

    factory Showdown.fromJson(Map<String, dynamic> json){ 
        return Showdown(
            frontDefault: json["front_default"],
            frontFemale: json["front_female"],
        );
    }

}

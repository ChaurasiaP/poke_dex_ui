import 'package:poke_dex/model/api_models/pokemon_list_model.dart';

/// API response models for the /pokemon/{id} detail endpoint.

class ApiPokemonStat {
  final String statName;
  final int baseStat;
  final int effort;

  const ApiPokemonStat({
    required this.statName,
    required this.baseStat,
    required this.effort,
  });

  factory ApiPokemonStat.fromJson(Map<String, dynamic> json) => ApiPokemonStat(
        statName: json['stat_name'] as String,
        baseStat: json['base_stat'] as int,
        effort: json['effort'] as int,
      );
}

class ApiPokemonSprite {
  final String? frontDefault;
  final String? frontShiny;
  final String? backShiny;
  final String? officialArtwork;

  const ApiPokemonSprite({
    this.frontDefault,
    this.frontShiny,
    this.backShiny,
    this.officialArtwork,
  });

  factory ApiPokemonSprite.fromJson(Map<String, dynamic> json) =>
      ApiPokemonSprite(
        frontDefault: json['front_default'] as String?,
        frontShiny: json['front_shiny'] as String?,
        backShiny: json['back_shiny'] as String?,
        officialArtwork: json['official_artwork'] as String?,
      );
}

class ApiPokemonDetail {
  final int id;
  final String name;
  final int? height;
  final double? weight;
  final int? baseExperience;
  final bool? isDefault;
  final double? power;
  final List<ApiPokemonType> types;
  final List<ApiPokemonStat> stats;
  final ApiPokemonSprite? sprite;

  const ApiPokemonDetail({
    required this.id,
    required this.name,
    this.height,
    this.weight,
    this.baseExperience,
    this.isDefault,
    this.power,
    required this.types,
    required this.stats,
    this.sprite,
  });

  factory ApiPokemonDetail.fromJson(Map<String, dynamic> json) =>
      ApiPokemonDetail(
        id: json['id'] as int,
        name: json['name'] as String,
        height: json['height'] as int?,
        weight: (json['weight'] as num?)?.toDouble(),
        baseExperience: json['base_experience'] as int?,
        isDefault: json['is_default'] as bool?,
        power: (json['power'] as num?)?.toDouble(),
        types: (json['types'] as List<dynamic>)
            .map((t) => ApiPokemonType.fromJson(t as Map<String, dynamic>))
            .toList(),
        stats: (json['stats'] as List<dynamic>)
            .map((s) => ApiPokemonStat.fromJson(s as Map<String, dynamic>))
            .toList(),
        sprite: json['sprite'] == null
            ? null
            : ApiPokemonSprite.fromJson(json['sprite'] as Map<String, dynamic>),
      );
}

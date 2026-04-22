import 'package:poke_dex/model/api_models/pokemon_list_model.dart';

/// API response models for the /team endpoints.

class ApiTeamEntry {
  final int teamId;
  final int pokemonId;
  final String name;
  final String nickname;
  final String? frontSprite;
  final List<ApiPokemonType> types;
  final String addedAt;

  const ApiTeamEntry({
    required this.teamId,
    required this.pokemonId,
    required this.name,
    required this.nickname,
    this.frontSprite,
    required this.types,
    required this.addedAt,
  });

  factory ApiTeamEntry.fromJson(Map<String, dynamic> json) => ApiTeamEntry(
        teamId: json['team_id'] as int,
        pokemonId: json['pokemon_id'] as int,
        name: json['name'] as String,
        nickname: json['nickname'] as String,
        frontSprite: json['front_sprite'] as String?,
        types: (json['types'] as List<dynamic>)
            .map((t) => ApiPokemonType.fromJson(t as Map<String, dynamic>))
            .toList(),
        addedAt: json['added_at'] as String,
      );
}

class TeamListResponse {
  final int total;
  final int maxSize;
  final List<ApiTeamEntry> results;

  const TeamListResponse({
    required this.total,
    required this.maxSize,
    required this.results,
  });

  factory TeamListResponse.fromJson(Map<String, dynamic> json) =>
      TeamListResponse(
        total: json['total'] as int,
        maxSize: json['max_size'] as int,
        results: (json['results'] as List<dynamic>)
            .map((r) => ApiTeamEntry.fromJson(r as Map<String, dynamic>))
            .toList(),
      );
}

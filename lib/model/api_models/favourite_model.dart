import 'package:poke_dex/model/api_models/pokemon_list_model.dart';

/// API response models for the /favourites endpoints.

class ApiFavouriteItem {
  final int favouriteId;
  final int pokemonId;
  final String name;
  final String? frontSprite;
  final List<ApiPokemonType> types;
  final String addedAt;

  const ApiFavouriteItem({
    required this.favouriteId,
    required this.pokemonId,
    required this.name,
    this.frontSprite,
    required this.types,
    required this.addedAt,
  });

  factory ApiFavouriteItem.fromJson(Map<String, dynamic> json) =>
      ApiFavouriteItem(
        favouriteId: json['favourite_id'] as int,
        pokemonId: json['pokemon_id'] as int,
        name: json['name'] as String,
        frontSprite: json['front_sprite'] as String?,
        types: (json['types'] as List<dynamic>)
            .map((t) => ApiPokemonType.fromJson(t as Map<String, dynamic>))
            .toList(),
        addedAt: json['added_at'] as String,
      );
}

class FavouriteListResponse {
  final int total;
  final List<ApiFavouriteItem> results;

  const FavouriteListResponse({required this.total, required this.results});

  factory FavouriteListResponse.fromJson(Map<String, dynamic> json) =>
      FavouriteListResponse(
        total: json['total'] as int,
        results: (json['results'] as List<dynamic>)
            .map((r) => ApiFavouriteItem.fromJson(r as Map<String, dynamic>))
            .toList(),
      );
}

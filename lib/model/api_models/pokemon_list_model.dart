/// API response models for the /pokemon list endpoint.

class ApiPokemonType {
  final String type;
  final int slot;

  const ApiPokemonType({required this.type, required this.slot});

  factory ApiPokemonType.fromJson(Map<String, dynamic> json) => ApiPokemonType(
        type: json['type'] as String,
        slot: json['slot'] as int,
      );
}

class PokemonListItem {
  final int id;
  final String name;
  final String? frontSprite;
  final List<ApiPokemonType> types;

  const PokemonListItem({
    required this.id,
    required this.name,
    this.frontSprite,
    required this.types,
  });

  factory PokemonListItem.fromJson(Map<String, dynamic> json) => PokemonListItem(
        id: json['id'] as int,
        name: json['name'] as String,
        frontSprite: json['front_sprite'] as String?,
        types: (json['types'] as List<dynamic>)
            .map((t) => ApiPokemonType.fromJson(t as Map<String, dynamic>))
            .toList(),
      );
}

class PaginatedPokemonList {
  final int total;
  final int offset;
  final int limit;
  final List<PokemonListItem> results;

  const PaginatedPokemonList({
    required this.total,
    required this.offset,
    required this.limit,
    required this.results,
  });

  factory PaginatedPokemonList.fromJson(Map<String, dynamic> json) =>
      PaginatedPokemonList(
        total: json['total'] as int,
        offset: json['offset'] as int,
        limit: json['limit'] as int,
        results: (json['results'] as List<dynamic>)
            .map((r) => PokemonListItem.fromJson(r as Map<String, dynamic>))
            .toList(),
      );
}

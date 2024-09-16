// import "dart:convert";

// PokemonListModel pokemonsListFromJson(String str) =>
//     PokemonListModel.fromJson(json.decode(str));

// class PokemonListModel {
//   PokemonListModel({
//     required this.results,
//   });

//   late final List<Pokemon> results;

//   PokemonListModel.fromJson(Map<String, dynamic> json) {
//     results = (json['results'] as List?)
//             ?.map((e) => Pokemon.fromJson(e))
//             .toList() ??
//         [];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['results'] = results.map((e) => e.toJson()).toList();
//     return data;
//   }
// }

// class Pokemon {
//   Pokemon({
//     required this.name,
//     required this.url,
//   });

//   late final String name;
//   late final String url;

//   Pokemon.fromJson(Map<String, dynamic> json) {
//     name = json['name'] ?? ''; // Default to an empty string if null
//     url = json['url'] ?? ''; // Default to an empty string if null
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['name'] = name;
//     data['url'] = url;
//     return data;
//   }
// }

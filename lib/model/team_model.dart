import 'package:poke_dex/model/pokemon_data_model.dart';

class FavouriteEntry {
  final Pokemon pokemon;
  final DateTime addedAt;

  FavouriteEntry({
    required this.pokemon,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}

class TeamEntry {
  final Pokemon pokemon;
  String nickname;
  final DateTime addedAt;

  TeamEntry({
    required this.pokemon,
    String? nickname,
    DateTime? addedAt,
  })  : nickname = nickname ?? pokemon.name ?? 'Unknown',
        addedAt = addedAt ?? DateTime.now();
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:poke_dex/api/api.dart';
import 'package:poke_dex/api/dummy_api.dart';
import 'package:poke_dex/model/pokemon_data_model.dart';
import 'package:poke_dex/model/team_model.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';

class PokemonProvider extends ChangeNotifier {
  List<Pokemon> pokemonList = [];
  List<FavouriteEntry> favourites = [];
  List<TeamEntry> team = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCrudLoading = false;
  bool get isCrudLoading => _isCrudLoading;

  // ─── Pokemon list ───────────────────────────────────────────────────────────

  Future<void> fetchPokemonList() async {
    _isLoading = true;
    notifyListeners();
    try {
      pokemonList.clear();
      var data = await Api.fetchPokemonList();
      if (data != null) {
        pokemonList.addAll(data.results);
        if (pokemonList.isNotEmpty) fetchUniquePokemonTypes();
        log("data fetched");
      }
    } catch (e) {
      log("Error fetching Pokemon list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Favourites CRUD ─────────────────────────────────────────────────────────

  Future<bool> addFavourite(Pokemon pokemon) async {
    _isCrudLoading = true;
    notifyListeners();
    try {
      final result = await DummyApi.addFavourite(pokemon);
      if (result) {
        favourites = await DummyApi.getFavourites();
        notifyListeners();
      }
      return result;
    } finally {
      _isCrudLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFavourite(int pokemonId) async {
    _isCrudLoading = true;
    notifyListeners();
    try {
      final result = await DummyApi.removeFavourite(pokemonId);
      if (result) {
        favourites = await DummyApi.getFavourites();
        notifyListeners();
      }
      return result;
    } finally {
      _isCrudLoading = false;
      notifyListeners();
    }
  }

  bool isFavourite(int? pokemonId) {
    if (pokemonId == null) return false;
    return DummyApi.isFavourite(pokemonId);
  }

  // ─── Team CRUD ───────────────────────────────────────────────────────────────

  Future<({bool success, String message})> addToTeam(
    Pokemon pokemon, {
    String? nickname,
  }) async {
    _isCrudLoading = true;
    notifyListeners();
    try {
      final result = await DummyApi.addToTeam(pokemon, nickname: nickname);
      if (result.success) {
        team = await DummyApi.getTeam();
        notifyListeners();
      }
      return result;
    } finally {
      _isCrudLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFromTeam(int pokemonId) async {
    _isCrudLoading = true;
    notifyListeners();
    try {
      final result = await DummyApi.removeFromTeam(pokemonId);
      if (result) {
        team = await DummyApi.getTeam();
        notifyListeners();
      }
      return result;
    } finally {
      _isCrudLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTeamNickname(int pokemonId, String nickname) async {
    final result = await DummyApi.updateTeamNickname(pokemonId, nickname);
    if (result) {
      team = await DummyApi.getTeam();
      notifyListeners();
    }
    return result;
  }

  bool isInTeam(int? pokemonId) {
    if (pokemonId == null) return false;
    return DummyApi.isInTeam(pokemonId);
  }

  // ─── Types ───────────────────────────────────────────────────────────────────

  List<String> pokemonTypes = [];

  fetchUniquePokemonTypes() {
    try {
      pokemonTypes.clear();
      for (var i in pokemonList) {
        for (var type in i.types) {
          if (!pokemonTypes.contains(type.type)) {
            pokemonTypes.add(type.type);
          }
        }
      }
    } finally {
      notifyListeners();
    }
  }

  String getTypeAsset(String type) {
    switch (type) {
      case "fire":
        return PokedexAssets.fireType;
      case "water":
        return PokedexAssets.waterType;
      case "grass":
        return PokedexAssets.grassType;
      case "electric":
        return PokedexAssets.electricType;
      case "ice":
        return PokedexAssets.iceType;
      case "fighting":
        return PokedexAssets.fightingType;
      case "poison":
        return PokedexAssets.poisonType;
      case "ground":
        return PokedexAssets.groundType;
      case "flying":
        return PokedexAssets.flyingType;
      case "psychic":
        return PokedexAssets.psychicType;
      case "bug":
        return PokedexAssets.bugType;
      case "rock":
        return PokedexAssets.rockType;
      case "ghost":
        return PokedexAssets.ghostType;
      case "dragon":
        return PokedexAssets.dragonType;
      case "dark":
        return PokedexAssets.darkType;
      case "steel":
        return PokedexAssets.steelType;
      case "fairy":
        return PokedexAssets.fairyType;
      default:
        return PokedexAssets.normalType;
    }
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:poke_dex/api/api.dart';
import 'package:poke_dex/model/api_models/favourite_model.dart';
import 'package:poke_dex/model/api_models/team_model.dart';
import 'package:poke_dex/model/pokemon_data_model.dart';
import 'package:poke_dex/services/favourites_service.dart';
import 'package:poke_dex/services/team_service.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';

class PokemonProvider extends ChangeNotifier {
  List<Pokemon> pokemonList = [];
  List<ApiFavouriteItem> favourites = [];
  List<ApiTeamEntry> team = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCrudLoading = false;
  bool get isCrudLoading => _isCrudLoading;

  // ─── Pokemon list (local JSON asset — fast & offline) ───────────────────────

  Future<void> fetchPokemonList() async {
    _isLoading = true;
    notifyListeners();
    try {
      pokemonList.clear();
      var data = await Api.fetchPokemonList();
      if (data != null) {
        pokemonList.addAll(data.results);
        if (pokemonList.isNotEmpty) fetchUniquePokemonTypes();
        log('Pokemon list loaded from local JSON: ${pokemonList.length} entries');
      }
    } catch (e) {
      log('Error fetching Pokemon list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Favourites CRUD (real API) ─────────────────────────────────────────────

  Future<void> loadFavourites() async {
    try {
      final res = await FavouritesService.getFavourites();
      favourites = res.results;
      notifyListeners();
    } on DioException catch (e) {
      log('Favourites load failed: ${e.message}');
    }
  }

  Future<bool> addFavourite(int pokemonId) async {
    _isCrudLoading = true;
    notifyListeners();
    try {
      await FavouritesService.addFavourite(pokemonId);
      await loadFavourites();
      return true;
    } on DioException catch (e) {
      log('addFavourite failed: ${e.message}');
      return false;
    } finally {
      _isCrudLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFavourite(int pokemonId) async {
    _isCrudLoading = true;
    notifyListeners();
    try {
      await FavouritesService.removeFavourite(pokemonId);
      await loadFavourites();
      return true;
    } on DioException catch (e) {
      log('removeFavourite failed: ${e.message}');
      return false;
    } finally {
      _isCrudLoading = false;
      notifyListeners();
    }
  }

  bool isFavourite(int? pokemonId) {
    if (pokemonId == null) return false;
    return favourites.any((f) => f.pokemonId == pokemonId);
  }

  // ─── Team CRUD (real API) ───────────────────────────────────────────────────

  Future<void> loadTeam() async {
    try {
      final res = await TeamService.getTeam();
      team = res.results;
      notifyListeners();
    } on DioException catch (e) {
      log('Team load failed: ${e.message}');
    }
  }

  Future<({bool success, String message})> addToTeam(
    int pokemonId, {
    String? nickname,
  }) async {
    _isCrudLoading = true;
    notifyListeners();
    try {
      await TeamService.addToTeam(pokemonId, nickname: nickname);
      await loadTeam();
      return (success: true, message: 'Added to team!');
    } on DioException catch (e) {
      final msg = (e.response?.data as Map?)?['detail'] as String? ??
          e.message ??
          'Failed to add to team';
      log('addToTeam failed: $msg');
      return (success: false, message: msg);
    } finally {
      _isCrudLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFromTeam(int pokemonId) async {
    _isCrudLoading = true;
    notifyListeners();
    try {
      await TeamService.removeFromTeam(pokemonId);
      await loadTeam();
      return true;
    } on DioException catch (e) {
      log('removeFromTeam failed: ${e.message}');
      return false;
    } finally {
      _isCrudLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTeamNickname(int pokemonId, String nickname) async {
    try {
      await TeamService.updateNickname(pokemonId, nickname);
      await loadTeam();
      return true;
    } on DioException catch (e) {
      log('updateTeamNickname failed: ${e.message}');
      return false;
    }
  }

  bool isInTeam(int? pokemonId) {
    if (pokemonId == null) return false;
    return team.any((t) => t.pokemonId == pokemonId);
  }

  // ─── Types ──────────────────────────────────────────────────────────────────

  List<String> pokemonTypes = [];

  void fetchUniquePokemonTypes() {
    try {
      pokemonTypes.clear();
      for (var pokemon in pokemonList) {
        for (var typeEntry in pokemon.types) {
          if (!pokemonTypes.contains(typeEntry.type)) {
            pokemonTypes.add(typeEntry.type);
          }
        }
      }
    } finally {
      notifyListeners();
    }
  }

  String getTypeAsset(String type) {
    switch (type) {
      case 'fire':
        return PokedexAssets.fireType;
      case 'water':
        return PokedexAssets.waterType;
      case 'grass':
        return PokedexAssets.grassType;
      case 'electric':
        return PokedexAssets.electricType;
      case 'ice':
        return PokedexAssets.iceType;
      case 'fighting':
        return PokedexAssets.fightingType;
      case 'poison':
        return PokedexAssets.poisonType;
      case 'ground':
        return PokedexAssets.groundType;
      case 'flying':
        return PokedexAssets.flyingType;
      case 'psychic':
        return PokedexAssets.psychicType;
      case 'bug':
        return PokedexAssets.bugType;
      case 'rock':
        return PokedexAssets.rockType;
      case 'ghost':
        return PokedexAssets.ghostType;
      case 'dragon':
        return PokedexAssets.dragonType;
      case 'dark':
        return PokedexAssets.darkType;
      case 'steel':
        return PokedexAssets.steelType;
      case 'fairy':
        return PokedexAssets.fairyType;
      default:
        return PokedexAssets.normalType;
    }
  }
}

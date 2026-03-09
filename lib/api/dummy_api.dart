import 'dart:developer';
import 'package:poke_dex/model/pokemon_data_model.dart';
import 'package:poke_dex/model/team_model.dart';

/// DummyApi — In-memory CRUD store.
/// Swap these methods for real Dio/HTTP calls when the backend is ready.
class DummyApi {
  // ---------------------------------------------------------------------------
  // In-memory stores
  // ---------------------------------------------------------------------------
  static final List<FavouriteEntry> _favourites = [];
  static final List<TeamEntry> _team = [];
  static const int maxTeamSize = 6;

  // ---------------------------------------------------------------------------
  // FAVOURITES — CRUD
  // ---------------------------------------------------------------------------

  /// READ: get all favourites
  static Future<List<FavouriteEntry>> getFavourites() async {
    await _simulateDelay();
    return List.unmodifiable(_favourites);
  }

  /// CREATE: add a pokemon to favourites
  static Future<bool> addFavourite(Pokemon pokemon) async {
    await _simulateDelay();
    if (_favourites.any((e) => e.pokemon.id == pokemon.id)) {
      log('[DummyApi] Already in favourites: ${pokemon.name}');
      return false; // already exists
    }
    _favourites.add(FavouriteEntry(pokemon: pokemon));
    log('[DummyApi] Added to favourites: ${pokemon.name}');
    return true;
  }

  /// DELETE: remove a pokemon from favourites by id
  static Future<bool> removeFavourite(int pokemonId) async {
    await _simulateDelay();
    final before = _favourites.length;
    _favourites.removeWhere((e) => e.pokemon.id == pokemonId);
    final removed = _favourites.length < before;
    if (removed) log('[DummyApi] Removed from favourites: id=$pokemonId');
    return removed;
  }

  /// Check if pokemon is favourited
  static bool isFavourite(int pokemonId) {
    return _favourites.any((e) => e.pokemon.id == pokemonId);
  }

  // ---------------------------------------------------------------------------
  // TEAM — CRUD
  // ---------------------------------------------------------------------------

  /// READ: get the current team
  static Future<List<TeamEntry>> getTeam() async {
    await _simulateDelay();
    return List.unmodifiable(_team);
  }

  /// CREATE: add a pokemon to team (max 6)
  static Future<({bool success, String message})> addToTeam(
    Pokemon pokemon, {
    String? nickname,
  }) async {
    await _simulateDelay();
    if (_team.length >= maxTeamSize) {
      return (success: false, message: 'Team is full! Max $maxTeamSize Pokémon.');
    }
    if (_team.any((e) => e.pokemon.id == pokemon.id)) {
      return (success: false, message: '${pokemon.name} is already in your team!');
    }
    _team.add(TeamEntry(pokemon: pokemon, nickname: nickname));
    log('[DummyApi] Added to team: ${pokemon.name} as "${nickname ?? pokemon.name}"');
    return (success: true, message: 'Added ${nickname ?? pokemon.name} to your team!');
  }

  /// UPDATE: edit the nickname of a team member
  static Future<bool> updateTeamNickname(int pokemonId, String nickname) async {
    await _simulateDelay();
    final index = _team.indexWhere((e) => e.pokemon.id == pokemonId);
    if (index == -1) return false;
    _team[index].nickname = nickname;
    log('[DummyApi] Updated nickname for id=$pokemonId → "$nickname"');
    return true;
  }

  /// DELETE: remove a pokemon from team
  static Future<bool> removeFromTeam(int pokemonId) async {
    await _simulateDelay();
    final before = _team.length;
    _team.removeWhere((e) => e.pokemon.id == pokemonId);
    final removed = _team.length < before;
    if (removed) log('[DummyApi] Removed from team: id=$pokemonId');
    return removed;
  }

  /// Check if pokemon is in team
  static bool isInTeam(int pokemonId) {
    return _team.any((e) => e.pokemon.id == pokemonId);
  }

  /// Get team member by pokemon id
  static TeamEntry? getTeamMember(int pokemonId) {
    try {
      return _team.firstWhere((e) => e.pokemon.id == pokemonId);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  static Future<void> _simulateDelay() async {
    // Simulate ~80ms network latency for realistic behaviour
    await Future.delayed(const Duration(milliseconds: 80));
  }
}

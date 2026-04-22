import 'package:dio/dio.dart';
import 'package:poke_dex/api/api_client.dart';
import 'package:poke_dex/model/api_models/pokemon_list_model.dart';
import 'package:poke_dex/model/api_models/pokemon_detail_model.dart';

/// Wraps all /pokemon endpoints.
class PokemonService {
  static final Dio _dio = ApiClient.dio;

  // ── LIST ──────────────────────────────────────────────────────────────────

  static Future<PaginatedPokemonList> getPokemonList({
    int offset = 0,
    int limit = 20,
  }) async {
    final res = await _dio.get(
      '/pokemon',
      queryParameters: {'offset': offset, 'limit': limit},
    );
    return PaginatedPokemonList.fromJson(res.data as Map<String, dynamic>);
  }

  // ── DETAIL ────────────────────────────────────────────────────────────────

  static Future<ApiPokemonDetail> getPokemon(int pokemonId) async {
    final res = await _dio.get('/pokemon/$pokemonId');
    return ApiPokemonDetail.fromJson(res.data as Map<String, dynamic>);
  }

  // ── CREATE ────────────────────────────────────────────────────────────────

  static Future<ApiPokemonDetail> createPokemon(
    Map<String, dynamic> body,
  ) async {
    final res = await _dio.post('/pokemon', data: body);
    return ApiPokemonDetail.fromJson(res.data as Map<String, dynamic>);
  }

  // ── UPDATE ────────────────────────────────────────────────────────────────

  static Future<ApiPokemonDetail> updatePokemon(
    int pokemonId,
    Map<String, dynamic> body,
  ) async {
    final res = await _dio.put('/pokemon/$pokemonId', data: body);
    return ApiPokemonDetail.fromJson(res.data as Map<String, dynamic>);
  }

  // ── DELETE ────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> deletePokemon(int pokemonId) async {
    final res = await _dio.delete('/pokemon/$pokemonId');
    return res.data as Map<String, dynamic>;
  }
}

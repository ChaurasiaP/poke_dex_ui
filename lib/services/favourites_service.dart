import 'package:dio/dio.dart';
import 'package:poke_dex/api/api_client.dart';
import 'package:poke_dex/model/api_models/favourite_model.dart';

/// Wraps all /favourites endpoints.
class FavouritesService {
  static final Dio _dio = ApiClient.dio;

  // ── READ ──────────────────────────────────────────────────────────────────

  static Future<FavouriteListResponse> getFavourites() async {
    final res = await _dio.get('/favourites');
    return FavouriteListResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // ── CREATE ────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> addFavourite(int pokemonId) async {
    final res = await _dio.post('/favourites/$pokemonId');
    return res.data as Map<String, dynamic>;
  }

  // ── DELETE ────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> removeFavourite(int pokemonId) async {
    final res = await _dio.delete('/favourites/$pokemonId');
    return res.data as Map<String, dynamic>;
  }

  // ── CHECK ─────────────────────────────────────────────────────────────────

  static Future<bool> isFavourite(int pokemonId) async {
    final res = await _dio.get('/favourites/check/$pokemonId');
    return (res.data as Map<String, dynamic>)['is_favourite'] as bool;
  }
}

import 'package:dio/dio.dart';
import 'package:poke_dex/api/api_client.dart';
import 'package:poke_dex/model/api_models/team_model.dart';

/// Wraps all /team endpoints.
class TeamService {
  static final Dio _dio = ApiClient.dio;

  // ── READ ──────────────────────────────────────────────────────────────────

  static Future<TeamListResponse> getTeam() async {
    final res = await _dio.get('/team');
    return TeamListResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // ── CREATE ────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> addToTeam(
    int pokemonId, {
    String? nickname,
  }) async {
    final res = await _dio.post(
      '/team/$pokemonId',
      data: nickname != null ? {'nickname': nickname} : {},
    );
    return res.data as Map<String, dynamic>;
  }

  // ── UPDATE (nickname) ─────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> updateNickname(
    int pokemonId,
    String nickname,
  ) async {
    final res = await _dio.patch(
      '/team/$pokemonId',
      data: {'nickname': nickname},
    );
    return res.data as Map<String, dynamic>;
  }

  // ── DELETE ────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> removeFromTeam(int pokemonId) async {
    final res = await _dio.delete('/team/$pokemonId');
    return res.data as Map<String, dynamic>;
  }

  // ── CHECK ─────────────────────────────────────────────────────────────────

  static Future<({bool isInTeam, String? nickname})> checkTeam(
    int pokemonId,
  ) async {
    final res = await _dio.get('/team/check/$pokemonId');
    final data = res.data as Map<String, dynamic>;
    return (
      isInTeam: data['is_in_team'] as bool,
      nickname: data['nickname'] as String?,
    );
  }
}


import 'package:dio/dio.dart';

/// Central Dio client — swap [baseUrl] to point at local backend or AWS.
class ApiClient {
  ApiClient._();

  // ── Base URL ───────────────────────────────────────────────────────────────
  // Deployed AWS URL for production:
  static const String baseUrl = 'https://59pnln5za3.execute-api.ap-south-1.amazonaws.com/Prod';
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator → localhost
  // static const String baseUrl = 'http://localhost:8000'; // iOS sim / desktop

  // ── Singleton Dio instance ─────────────────────────────────────────────────
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => _log(obj.toString()),
      ),
    );

  static Dio get dio => _dio;

  static void _log(String msg) {
    // ignore: avoid_print
    print('[ApiClient] $msg');
  }
}

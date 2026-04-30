import 'package:dio/dio.dart';
import 'package:jastar_hub_community/core/network/token_manager.dart';

/// Centralized Dio HTTP Client for Jastar Hub API
class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      // For physical devices, use your computer's local IP address.
      // Make sure your phone and PC are on the same Wi-Fi network!
      baseUrl: 'http://192.168.0.8:3000',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );

  static void initialize() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attempt to retrieve access token
          final token = await TokenManager.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Could handle 401 Unauthorized globally here to force logout
          if (error.response?.statusCode == 401) {
            await TokenManager.clearTokens();
            // TODO: dispatch force logout globally if needed
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Dio get client => _dio;
}

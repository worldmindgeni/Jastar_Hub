import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  /// Save tokens to secure storage
  static Future<void> saveTokens({required String access, String? refresh}) async {
    await _storage.write(key: _keyAccessToken, value: access);
    if (refresh != null) {
      await _storage.write(key: _keyRefreshToken, value: refresh);
    }
  }

  /// Get the access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Delete tokens (e.g. on logout)
  static Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }
}

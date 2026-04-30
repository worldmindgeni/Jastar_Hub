import 'package:dio/dio.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';
import 'package:jastar_hub_community/core/network/token_manager.dart';
import 'package:jastar_hub_community/features/auth/data/models/user_model.dart';

/// Auth repository connecting to the NestJS backend.
class AuthRepository {
  UserModel? _currentUser;

  bool get isAuthenticated => _currentUser != null;
  UserModel? get currentUser => _currentUser;

  /// Login with email/password via API.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.client.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final String token = response.data['access_token'];
      final userData = response.data['user'];

      // Save token securely
      await TokenManager.saveTokens(access: token);

      _currentUser = UserModel.fromJson(userData);
      return _currentUser!;
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Login failed';
      throw AuthException(message.toString());
    } catch (e) {
      throw AuthException('An unexpected error occurred');
    }
  }

  /// Registration via API.
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.client.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      final String token = response.data['access_token'];
      final userData = response.data['user'];

      await TokenManager.saveTokens(access: token);

      _currentUser = UserModel.fromJson(userData);
      return _currentUser!;
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Registration failed';
      throw AuthException(message.toString());
    } catch (e) {
      throw AuthException('An unexpected error occurred');
    }
  }

  /// Password reset (Placeholder - depends on backend implementation).
  Future<void> forgotPassword({required String email}) async {
    // This would typically hit an endpoint like /auth/forgot-password
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  /// Logout — clear tokens and reset state.
  Future<void> logout() async {
    await TokenManager.clearTokens();
    _currentUser = null;
  }

  /// Check for existing session.
  Future<UserModel?> checkAuth() async {
    final token = await TokenManager.getAccessToken();
    if (token == null) return null;

    try {
      // In a real app, we might want a /auth/me endpoint to validate token
      // For now, we'll assume if token exists, we can try to fetch profile or just trust it
      // Let's simulate a profile fetch or use the token to get user info
      // Since we don't have /auth/me yet, we will rely on subsequent failing requests to trigger logout
      
      // If we had /auth/me:
      // final response = await ApiClient.client.get('/auth/me');
      // _currentUser = UserModel.fromJson(response.data);
      // return _currentUser;
      
      return _currentUser; 
    } catch (e) {
      await logout();
      return null;
    }
  }
}

/// Custom exception for auth errors.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}


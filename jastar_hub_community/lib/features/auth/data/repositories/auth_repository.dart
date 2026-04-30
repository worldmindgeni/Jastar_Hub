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
      final dynamic data = e.response?.data;
      final String message = (data is Map)
          ? (data['message']?.toString() ?? 'Login failed')
          : (data?.toString() ?? 'Login failed');
      throw AuthException(message);
    } catch (e) {
      throw AuthException('An unexpected error occurred: $e');
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
      final dynamic data = e.response?.data;
      final String message = (data is Map)
          ? (data['message']?.toString() ?? 'Registration failed')
          : (data?.toString() ?? 'Registration failed');
      throw AuthException(message);
    } catch (e) {
      throw AuthException('An unexpected error occurred: $e');
    }
  }

  /// Password reset.
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  /// Logout — clear tokens and reset state.
  Future<void> logout() async {
    await TokenManager.clearTokens();
    _currentUser = null;
  }

  /// Check for existing session by calling /auth/me.
  Future<UserModel?> checkAuth() async {
    final token = await TokenManager.getAccessToken();
    if (token == null) return null;

    try {
      final response = await ApiClient.client.get('/auth/me');
      _currentUser = UserModel.fromJson(response.data);
      return _currentUser;
    } on DioException catch (_) {
      // Token expired or invalid
      await logout();
      return null;
    } catch (_) {
      await logout();
      return null;
    }
  }

  /// Update user profile.
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.client.patch('/users/profile', data: data);
      _currentUser = UserModel.fromJson(response.data);
      return _currentUser!;
    } on DioException catch (e) {
      throw AuthException(e.response?.data['message'] ?? 'Failed to update profile');
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

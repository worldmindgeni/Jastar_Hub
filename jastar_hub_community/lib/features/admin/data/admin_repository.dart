import 'package:dio/dio.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';
import 'package:jastar_hub_community/features/auth/data/models/user_model.dart';

class AdminRepository {
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await ApiClient.client.get('/admin/users');
      final List<dynamic> data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load users');
    }
  }

  Future<List<EventModel>> getPendingEvents() async {
    try {
      final response = await ApiClient.client.get('/admin/events/pending');
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load pending events');
    }
  }

  Future<void> moderateEvent(String id, String status) async {
    try {
      await ApiClient.client.patch(
        '/admin/events/moderate/$id',
        data: {'status': status},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to moderate event');
    }
  }

  Future<void> makeAdmin(String userId) async {
    try {
      await ApiClient.client.post('/admin/make-admin/$userId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update user role');
    }
  }
}

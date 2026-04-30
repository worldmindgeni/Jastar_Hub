import 'package:dio/dio.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class NotificationsRepository {
  Future<List<NotificationModel>> getNotifications({int skip = 0, int take = 20}) async {
    try {
      final response = await ApiClient.client.get(
        '/notifications',
        queryParameters: {'skip': skip.toString(), 'take': take.toString()},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch notifications');
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await ApiClient.client.get('/notifications/unread-count');
      return response.data['count'] as int;
    } catch (_) {
      return 0;
    }
  }

  Future<void> markAsRead(String id) async {
    await ApiClient.client.patch('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await ApiClient.client.post('/notifications/read-all');
  }
}

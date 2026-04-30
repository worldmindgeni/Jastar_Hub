import 'package:dio/dio.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';

/// Repository for handling event-related API calls.
class EventRepository {
  /// Fetch list of events with optional filters.
  Future<List<EventModel>> getEvents({
    String? category,
    String? city,
    String? search,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (category != null && category != 'all') {
        queryParameters['category'] = category;
      }
      if (city != null) {
        queryParameters['city'] = city;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      final response = await ApiClient.client.get(
        '/events',
        queryParameters: queryParameters,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to fetch events');
    } catch (e) {
      throw EventException('An unexpected error occurred');
    }
  }

  /// Fetch single event by ID.
  Future<EventModel> getEventDetails(String id) async {
    try {
      final response = await ApiClient.client.get('/events/$id');
      return EventModel.fromJson(response.data);
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to fetch event details');
    } catch (e) {
      throw EventException('An unexpected error occurred');
    }
  }

  /// Join an event.
  Future<void> joinEvent(String id) async {
    try {
      await ApiClient.client.post('/events/$id/join');
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to join event');
    }
  }

  /// Leave an event.
  Future<void> leaveEvent(String id) async {
    try {
      await ApiClient.client.post('/events/$id/leave');
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to leave event');
    }
  }

  /// Fetch AI-based recommendations for user.
  Future<List<EventModel>> getRecommendations() async {
    try {
      final response = await ApiClient.client.get('/recommendations');
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to fetch recommendations');
    } catch (e) {
      throw EventException('An unexpected error occurred');
    }
  }
}

class EventException implements Exception {
  final String message;
  const EventException(this.message);

  @override
  String toString() => message;
}

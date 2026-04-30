import 'package:dio/dio.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';

/// Repository for handling event-related API calls.
class EventRepository {
  /// Fetch list of events with optional filters and pagination.
  Future<List<EventModel>> getEvents({
    String? category,
    String? city,
    String? search,
    String? sort,
    int skip = 0,
    int take = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'skip': skip.toString(),
        'take': take.toString(),
      };
      if (category != null && category != 'all') {
        queryParameters['category'] = category;
      }
      if (city != null) {
        queryParameters['city'] = city;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (sort != null) {
        queryParameters['sort'] = sort;
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

  /// Toggle favorite status for an event.
  Future<bool> toggleFavorite(String id) async {
    try {
      final response = await ApiClient.client.post('/events/$id/favorite');
      return response.data['isFavorite'] as bool;
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to toggle favorite');
    }
  }

  /// Get user's favorite events.
  Future<List<EventModel>> getFavorites() async {
    try {
      final response = await ApiClient.client.get('/events/user/favorites');
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to fetch favorites');
    }
  }

  /// Fetch trending events.
  Future<List<EventModel>> getTrending({int take = 10}) async {
    try {
      final response = await ApiClient.client.get(
        '/events/trending',
        queryParameters: {'take': take.toString()},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to fetch trending');
    } catch (e) {
      throw EventException('An unexpected error occurred');
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

  /// Track user interaction with an event (view, like, share).
  Future<void> trackInteraction(String eventId, String type) async {
    try {
      await ApiClient.client.post('/events/$eventId/interact', data: {'type': type});
    } catch (_) {
      // Silently fail — non-critical
    }
  }

  /// Get user's organized events.
  Future<List<EventModel>> getOrganizedEvents() async {
    try {
      final response = await ApiClient.client.get('/events/user/organized');
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to fetch organized events');
    }
  }

  /// Get user's joined events.
  Future<List<EventModel>> getJoinedEvents() async {
    try {
      final response = await ApiClient.client.get('/events/user/joined');
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to fetch joined events');
    }
  }

  /// Create a new event.
  Future<EventModel> createEvent(Map<String, dynamic> eventData) async {
    try {
      final response = await ApiClient.client.post('/events', data: eventData);
      return EventModel.fromJson(response.data);
    } on DioException catch (e) {
      throw EventException(e.response?.data['message'] ?? 'Failed to create event');
    }
  }
}

class EventException implements Exception {
  final String message;
  const EventException(this.message);

  @override
  String toString() => message;
}

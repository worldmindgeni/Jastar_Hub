import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jastar_hub_community/features/events/data/repositories/event_repository.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';

import 'package:jastar_hub_community/features/events/presentation/cubit/events_state.dart';
export 'package:jastar_hub_community/features/events/presentation/cubit/events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventRepository _eventRepository;

  EventsCubit({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(const EventsInitial());

  Future<void> fetchEvents({String? category, String? city, String? search}) async {
    emit(const EventsLoading());
    try {
      final events = await _eventRepository.getEvents(
        category: category,
        city: city,
        search: search,
      );
      emit(EventsLoaded(events: events));
    } on EventException catch (e) {
      emit(EventsError(message: e.message));
    } catch (e) {
      emit(const EventsError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> fetchRecommendations() async {
    emit(const EventsLoading());
    try {
      final events = await _eventRepository.getRecommendations();
      emit(EventsLoaded(events: events));
    } on EventException catch (e) {
      emit(EventsError(message: e.message));
    } catch (e) {
      emit(const EventsError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> joinEvent(String id) async {
    try {
      await _eventRepository.joinEvent(id);
      // Optionally refresh
    } on EventException catch (e) {
      emit(EventsError(message: e.message));
    }
  }

  Future<void> leaveEvent(String id) async {
    try {
      await _eventRepository.leaveEvent(id);
    } on EventException catch (e) {
      emit(EventsError(message: e.message));
    }
  }
}

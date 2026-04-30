import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jastar_hub_community/features/events/data/repositories/event_repository.dart';
import 'package:jastar_hub_community/features/events/presentation/cubit/events_cubit.dart';

class RecommendationsCubit extends Cubit<EventsState> {
  final EventRepository _eventRepository;

  RecommendationsCubit({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(const EventsInitial());

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
}

import 'package:equatable/equatable.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';


abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {
  const EventsInitial();
}

class EventsLoading extends EventsState {
  const EventsLoading();
}

class EventsLoaded extends EventsState {
  final List<EventModel> events;

  const EventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class EventsError extends EventsState {
  final String message;

  const EventsError({required this.message});

  @override
  List<Object?> get props => [message];
}

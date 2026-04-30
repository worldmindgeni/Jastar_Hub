import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jastar_hub_community/features/notifications/data/notifications_repository.dart';

// ─── States ──────────────────────────────────────────────
abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── Cubit ───────────────────────────────────────────────
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit({required NotificationsRepository repository})
      : _repository = repository,
        super(const NotificationsInitial());

  Future<void> fetchNotifications() async {
    emit(const NotificationsLoading());
    try {
      final notifications = await _repository.getNotifications();
      final unreadCount = await _repository.getUnreadCount();
      emit(NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final count = await _repository.getUnreadCount();
      final currentState = state;
      if (currentState is NotificationsLoaded) {
        emit(NotificationsLoaded(
          notifications: currentState.notifications,
          unreadCount: count,
        ));
      }
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markAsRead(id);
      final currentState = state;
      if (currentState is NotificationsLoaded) {
        final updated = currentState.notifications.map((n) {
          if (n.id == id) {
            return NotificationModel(
              id: n.id,
              type: n.type,
              title: n.title,
              message: n.message,
              isRead: true,
              createdAt: n.createdAt,
            );
          }
          return n;
        }).toList();
        emit(NotificationsLoaded(
          notifications: updated,
          unreadCount: (currentState.unreadCount - 1).clamp(0, 999),
        ));
      }
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      final currentState = state;
      if (currentState is NotificationsLoaded) {
        final updated = currentState.notifications.map((n) {
          return NotificationModel(
            id: n.id,
            type: n.type,
            title: n.title,
            message: n.message,
            isRead: true,
            createdAt: n.createdAt,
          );
        }).toList();
        emit(NotificationsLoaded(notifications: updated, unreadCount: 0));
      }
    } catch (_) {}
  }
}

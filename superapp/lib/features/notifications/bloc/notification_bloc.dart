import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository(),
        super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<DeleteNotificationEvent>(_onDeleteNotification);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final response = await _repository.getNotifications(unreadOnly: event.unreadOnly);
      emit(NotificationLoaded(response.data.data));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final success = await _repository.markAsRead(event.notificationId);
      if (success && state is NotificationLoaded) {
        final currentNotifications = (state as NotificationLoaded).notifications;
        final updatedNotifications = currentNotifications.map((n) {
          if (n.id == event.notificationId) {
            // We can't easily update readAt in the model without a copyWith, 
            // but for simplicity we'll just trigger a refresh or let the UI handle it.
          }
          return n;
        }).toList();
        // Trigger a refresh to be sure
        add(const FetchNotificationsEvent());
      }
    } catch (e) {
      // Fail silently
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final success = await _repository.deleteNotification(event.notificationId);
      if (success) {
        add(const FetchNotificationsEvent());
      }
    } catch (e) {
      // Fail silently
    }
  }
}

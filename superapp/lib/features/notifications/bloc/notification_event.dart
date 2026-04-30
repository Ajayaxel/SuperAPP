import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {
  final bool unreadOnly;
  const FetchNotificationsEvent({this.unreadOnly = false});

  @override
  List<Object?> get props => [unreadOnly];
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;
  const MarkNotificationAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;
  const DeleteNotificationEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationDeleted extends NotificationState {}

class NotificationCreated extends NotificationState {
  final String notificationUid;

  const NotificationCreated({required this.notificationUid});

  @override
  List<Object> get props => [notificationUid];
}

class NotificationLoaded extends NotificationState {
  final List<CustomNotification> notifications;

  const NotificationLoaded({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationFailed extends NotificationState {
  final String error;
  const NotificationFailed(this.error);
}

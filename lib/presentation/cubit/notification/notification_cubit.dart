import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/child_classes/notification.dart';
import 'package:instagram/domain/entities/notification_check.dart';
import 'package:instagram/domain/use_cases/notification/create_notification_use_case.dart';
import 'package:instagram/domain/use_cases/notification/delete_notification.dart';
import 'package:instagram/domain/use_cases/notification/get_notifications_use_case.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  NotificationCubit(this._createNotificationUseCase,
      this._getNotificationsUseCase, this._deleteNotificationUseCase)
      : super(NotificationInitial());

  static NotificationCubit get(BuildContext context) =>
      BlocProvider.of<NotificationCubit>(context);
  List<CustomNotification> notifications = [];
  Future<void> getNotifications({required String userId}) async {
    emit(NotificationLoading());
    await _getNotificationsUseCase
        .call(params: userId)
        .then((List<CustomNotification> notifications) {
      this.notifications = notifications;
      emit(NotificationLoaded(notifications: notifications));
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }

  Future<void> createNotification(
      {required CustomNotification newNotification}) async {
    await _createNotificationUseCase
        .call(params: newNotification)
        .then((notificationUid) {
      emit(NotificationCreated(notificationUid: notificationUid));
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }

  deleteNotification({required NotificationCheck notificationCheck}) async {
    await _deleteNotificationUseCase.call(params: notificationCheck).then((_) {
      emit(NotificationDeleted());
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }
}

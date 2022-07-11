import 'package:instagram/data/datasourses/remote/notification.dart';
import 'package:instagram/data/models/notification.dart';
import 'package:instagram/domain/entities/notification_check.dart';
import 'package:instagram/domain/repositories/firestore_notification.dart';

class FirestoreNotificationRepoImpl implements FirestoreNotificationRepository {
  @override
  Future<String> createNotification(
      {required CustomNotification newNotification}) async {
    try {
      return await FirestoreNotification.createNotification(newNotification);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<CustomNotification>> getNotifications({required String userId}) {
    try {
      return FirestoreNotification.getNotifications(userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteNotification({
    required NotificationCheck notificationCheck
  }) {
    try {
      return FirestoreNotification.deleteNotification(notificationCheck: notificationCheck);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

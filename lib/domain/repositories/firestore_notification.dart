import 'package:instagram/data/models/notification.dart';
import 'package:instagram/domain/entities/notification_check.dart';

abstract class FirestoreNotificationRepository {
  Future<String> createNotification(
      {required CustomNotification newNotification});
  Future<List<CustomNotification>> getNotifications({required String userId});
  Future<void> deleteNotification(
      {required NotificationCheck notificationCheck});
}

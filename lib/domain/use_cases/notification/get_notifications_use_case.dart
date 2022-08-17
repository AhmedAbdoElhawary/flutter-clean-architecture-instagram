import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/notification.dart';
import 'package:instagram/domain/repositories/firestore_notification.dart';

class GetNotificationsUseCase
    implements UseCase<List<CustomNotification>, String> {
  final FirestoreNotificationRepository _notificationRepository;
  GetNotificationsUseCase(this._notificationRepository);
  @override
  Future<List<CustomNotification>> call({required String params}) {
    return _notificationRepository.getNotifications(userId: params);
  }
}

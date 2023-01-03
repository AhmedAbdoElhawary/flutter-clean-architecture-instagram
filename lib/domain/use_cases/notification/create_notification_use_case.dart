import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/child_classes/notification.dart';
import 'package:instagram/domain/repositories/firestore_notification.dart';

class CreateNotificationUseCase implements UseCase<String, CustomNotification> {
  final FireStoreNotificationRepository _notificationRepository;
  CreateNotificationUseCase(this._notificationRepository);
  @override
  Future<String> call({required CustomNotification params}) {
    return _notificationRepository.createNotification(newNotification: params);
  }
}

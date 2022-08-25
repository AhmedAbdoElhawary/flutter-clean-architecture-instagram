import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/entities/calling_status.dart';

abstract class CallingRoomsRepository {
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required String callToThisUserId});

  Stream<bool> getCallingStatus({required String userId});

  Future<String> joinToRoom(
      {required String channelId, required UserPersonalInfo userInfo});

  Future<void> cancelJoiningToRoom(String userId);

  Future<List<UserInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId});
  Future<void> deleteTheRoom(
      {required String channelId, required String userId});
}

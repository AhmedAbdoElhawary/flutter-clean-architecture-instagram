import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/datasourses/remote/calling_rooms/calling_rooms.dart';
import 'package:instagram/data/datasourses/remote/notification/device_notification.dart';
import 'package:instagram/data/datasourses/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/push_notification.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/entities/calling_status.dart';
import 'package:instagram/domain/repositories/calling_rooms_repository.dart';

class CallingRoomsRepoImpl implements CallingRoomsRepository {
  @override
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required List<UserPersonalInfo> callThoseUsersInfo}) async {
    try {
      String channelId = await FireStoreCallingRooms.createCallingRoom(
          myPersonalInfo: myPersonalInfo,
          initialNumberOfUsers: callThoseUsersInfo.length + 1);

      List<bool> isUsersAvailable = await FirestoreUser.updateChannelId(
          callThoseUsersIds: callThoseUsersInfo,
          channelId: channelId,
          myPersonalId: myPersonalInfo.userId);
      bool isAnyOneAvailable = false;
      for (int i = 0; i < isUsersAvailable.length; i++) {
        if (isUsersAvailable[i]) {
          isAnyOneAvailable = true;
          UserPersonalInfo receiverInfo =
              await FirestoreUser.getUserInfo(callThoseUsersInfo[i].userId);
          String token = receiverInfo.deviceToken;
          if (token.isNotEmpty) {
            String body = "Calling you";
            PushNotification detail = PushNotification(
              title: myPersonalInfo.name,
              body: body,
              deviceToken: token,
              notificationRoute: "call",
              userCallingId: myPersonalInfo.userId,
              routeParameterId: channelId,
              isThatGroupChat: callThoseUsersInfo.length > 1,
            );
            await DeviceNotification.sendPopupNotification(
                pushNotification: detail);
          }
        }
      }
      if (isAnyOneAvailable) {
        return channelId;
      } else {
        throw Exception("Busy");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<bool> getCallingStatus({required String channelUid}) =>
      FireStoreCallingRooms.getCallingStatus(channelUid: channelUid);
  @override
  Future<String> joinToRoom(
      {required String channelId,
      required UserPersonalInfo myPersonalInfo}) async {
    try {
      return await FireStoreCallingRooms.joinToRoom(
          channelId: channelId, myPersonalInfo: myPersonalInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> leaveTheRoom({
    required String userId,
    required String channelId,
    required bool isThatAfterJoining,
  }) async {
    try {
      await FirestoreUser.cancelJoiningToRoom(userId);
      await FireStoreCallingRooms.removeThisUserFromRoom(
          channelId: channelId,
          userId: userId,
          isThatAfterJoining: isThatAfterJoining);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId}) async {
    try {
      return await FireStoreCallingRooms.getUsersInfoInThisRoom(
          channelId: channelId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteTheRoom(
      {required String channelId, required List<dynamic> usersIds}) async {
    try {
      await FirestoreUser.clearChannelsIds(
          usersIds: usersIds, myPersonalId: myPersonalId);
      return await FireStoreCallingRooms.deleteTheRoom(channelId: channelId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/entities/calling_status.dart';

class FireStoreCallingRooms {
  static final _roomsCollection =
      FirebaseFirestore.instance.collection('callingRooms');

  static Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required int initialNumberOfUsers}) async {
    DocumentReference<Map<String, dynamic>> collection =
        await _roomsCollection.add(
            _toMap(myPersonalInfo, initialNumberOfUsers: initialNumberOfUsers));

    _roomsCollection.doc(collection.id).update({"channelId": collection.id});
    return collection.id;
  }

  static Future<void> removeThisUserFromRoom({
    required String userId,
    required String channelId,
    required bool isThatAfterJoining,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _roomsCollection.doc(channelId).get();
    int initialNumberOfUsers = snap.get("initialNumberOfUsers");
    int numbersOfUsersInRoom = snap.get("numbersOfUsersInRoom");

    dynamic usersInfo = snap.get("usersInfo");
    usersInfo.removeWhere((key, value) {
      if (key == "usersInfo") {
        value.removeWhere((key, value) => key == userId);
        return false;
      } else {
        return false;
      }
    });
    _roomsCollection.doc(channelId).update({
      "usersInfo": usersInfo,
      "initialNumberOfUsers": initialNumberOfUsers - 1,
      if (isThatAfterJoining) "numbersOfUsersInRoom": numbersOfUsersInRoom - 1,
    });
  }

  static Map<String, dynamic> _toMap(UserPersonalInfo myPersonalInfo,
          {int numberOfUsers = 1, int initialNumberOfUsers = 0}) =>
      {
        "numbersOfUsersInRoom": numberOfUsers,
        if (initialNumberOfUsers != 0)
          "initialNumberOfUsers": initialNumberOfUsers,
        "usersInfo": {
          "${myPersonalInfo.userId}": {
            "name": myPersonalInfo.name,
            "profileImage": myPersonalInfo.profileImageUrl
          }
        }
      };
  static Future<String> joinToRoom(
      {required String channelId,
      required UserPersonalInfo myPersonalInfo}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _roomsCollection.doc(channelId).get();
    int numbersOfUsers = snap.get("numbersOfUsersInRoom");
    _roomsCollection
        .doc(channelId)
        .update(_toMap(myPersonalInfo, numberOfUsers: numbersOfUsers + 1));
    return channelId;
  }

  static Stream<bool> getCallingStatus({required String channelUid}) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapSearch =
        _roomsCollection.doc(channelUid).snapshots();
    return snapSearch.map((snapshot) {
      int initialNumberOfUsers = snapshot.get("initialNumberOfUsers");
      return initialNumberOfUsers != 1;
    });
  }

  static Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _roomsCollection.doc(channelId).get();
    Map<String, dynamic>? data = snap.data();
    List<UsersInfoInCallingRoom> usersInfo = [];
    data?.forEach((key, value) {
      if (key == "usersInfo") {
        Map map = value;
        map.forEach((userId, value) {
          Map secondMap = value;
          usersInfo.add(UsersInfoInCallingRoom(
            userId: userId,
            name: secondMap["name"],
            profileImageUrl: secondMap["profileImage"],
          ));
        });
      }
    });
    return usersInfo;
  }

  static Future<void> deleteTheRoom({required String channelId}) async {
    await _roomsCollection.doc(channelId).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/entities/calling_status.dart';

class FireStoreCallingRooms {
  static final _roomsCollection =
      FirebaseFirestore.instance.collection('callingRooms');

  static Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo}) async {
    DocumentReference<Map<String, dynamic>> collection =
        await _roomsCollection.add(_toMap(myPersonalInfo));

    _roomsCollection.doc(collection.id).update({"channelId": collection.id});
    return collection.id;
  }

  static Future<String> joinToRoom(
      {required String channelId, required UserPersonalInfo userInfo}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _roomsCollection.doc(channelId).get();
    int numbersOfUsers = snap.get("numbersOfUsersInRoom");
    _roomsCollection
        .doc(channelId)
        .update(_toMap(userInfo, numberOfUsers: numbersOfUsers + 1));
    return channelId;
  }

  static Future<List<UserInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _roomsCollection.doc(channelId).get();
    Map<String, dynamic>? data = snap.data();
    List<UserInfoInCallingRoom> usersInfo = [];
    data?.forEach((key, value) {
      if (key == "usersInfo") {
        Map map = value;
        map.forEach((userId, value) {
          Map secondMap = value;
          usersInfo.add(UserInfoInCallingRoom(
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

  static Map<String, dynamic> _toMap(UserPersonalInfo userInfo,
          {int numberOfUsers = 1}) =>
      {
        "numbersOfUsersInRoom": numberOfUsers,
        "usersInfo": {
          "${userInfo.userId}": {
            "name": userInfo.name,
            "profileImage": userInfo.profileImageUrl
          }
        }
      };
}

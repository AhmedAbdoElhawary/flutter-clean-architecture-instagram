import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class FirestoreUser {
  static final _firestoreUserCollection =
      FirebaseFirestore.instance.collection('users');

  static createUser(UserPersonalInfo newUserInfo) async {
    await _firestoreUserCollection
        .doc(newUserInfo.userId)
        .set(newUserInfo.toMap());
  }

  static Future<UserPersonalInfo> getUserInfo(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestoreUserCollection.doc(userId).get();
    if (snap.exists) {
      return UserPersonalInfo.fromSnap(snap);
    }
    return Future.error("the user not exist !");
  }
  static Future<List<UserPersonalInfo>> getSpecificUsersInfo(List<dynamic> usersIds) async {
    List<UserPersonalInfo> usersInfo = [];
    for (int i = 0; i < usersIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
      await _firestoreUserCollection.doc(usersIds[i]).get();
      if (snap.exists) {
        UserPersonalInfo postReformat = UserPersonalInfo.fromSnap(snap);
        usersInfo.add(postReformat);
      } else {
        return Future.error("the post not exist !");
      }
    }
    return usersInfo;
  }

  static updateUserInfo(UserPersonalInfo userInfo) async {
    await _firestoreUserCollection
        .doc(userInfo.userId)
        .update(userInfo.toMap());
  }

  static updateProfileImage(
      {required String imageUrl, required String userId}) async {
    await _firestoreUserCollection.doc(userId).update({
      "profileImageUrl": imageUrl,
    });
  }
}

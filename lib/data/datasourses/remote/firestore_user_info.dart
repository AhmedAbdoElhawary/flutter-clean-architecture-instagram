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
    DocumentSnapshot<Object?> snap =
        await _firestoreUserCollection.doc(userId).get();
    if (snap.exists) {
      return UserPersonalInfo.fromSnap(snap);
    }
    return Future.error("the user not exist !");
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

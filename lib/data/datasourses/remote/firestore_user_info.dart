import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class FirestoreUser {
  static final _fireStoreUserCollection =
      FirebaseFirestore.instance.collection('users');

  static createUser(UserPersonalInfo newUserInfo) async {
    await _fireStoreUserCollection
        .doc(newUserInfo.userId)
        .set(newUserInfo.toMap());
  }

  static Future<UserPersonalInfo> getUserInfo(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreUserCollection.doc(userId).get();
    if (snap.exists) {
      return UserPersonalInfo.fromSnap(snap);
    }
    return Future.error("the user not exist !");
  }

  static Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      List<dynamic> usersIds) async {
    List<UserPersonalInfo> usersInfo = [];
    for (int i = 0; i < usersIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStoreUserCollection.doc(usersIds[i]).get();
      if (snap.exists) {
        UserPersonalInfo postReformat = UserPersonalInfo.fromSnap(snap);
        usersInfo.add(postReformat);
      } else {
        return Future.error("the post not exist !");
      }
    }
    return usersInfo;
  }

  static updateProfileImage(
      {required String imageUrl, required String userId}) async {
    await _fireStoreUserCollection.doc(userId).update({
      "profileImageUrl": imageUrl,
    });
  }

  static updateUserInfo(UserPersonalInfo userInfo) async {
    await _fireStoreUserCollection
        .doc(userInfo.userId)
        .update(userInfo.toMap());
  }

  static updateUserPosts(
      {required String userId, required String postId}) async {
    await _fireStoreUserCollection.doc(userId).update({
      'posts': FieldValue.arrayUnion([postId])
    });
  }

  static followThisUser(String followingUserId, String myPersonalId) async {
    await _fireStoreUserCollection.doc(followingUserId).update({
      'followers': FieldValue.arrayUnion([myPersonalId])
    });

    await _fireStoreUserCollection.doc(myPersonalId).update({
      'following': FieldValue.arrayUnion([followingUserId])
    });
  }

  static removeThisFollower(String followingUserId, String myPersonalId) async {
    await _fireStoreUserCollection.doc(followingUserId).update({
      'followers': FieldValue.arrayRemove([myPersonalId])
    });

    await _fireStoreUserCollection.doc(myPersonalId).update({
      'following': FieldValue.arrayRemove([followingUserId])
    });
  }

  static Future<List> getSpecificUsersPosts(List<dynamic> usersIds) async {
    List postsInfo = [];
    for (int i = 0; i < usersIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStoreUserCollection.doc(usersIds[i]).get();
      if (snap.exists) {
        postsInfo += snap.get('posts');
      } else {
        return Future.error("the post not exist !");
      }
    }
    return postsInfo;
  }
}

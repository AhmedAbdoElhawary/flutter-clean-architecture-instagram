import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/comment.dart';
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

  static Future<List<Comment>> getCommentatorsInfo(List<Comment> commentsInfo) async {
    for (int i = 0; i < commentsInfo.length; i++) {
      UserPersonalInfo commentatorInfo=await getUserInfo(commentsInfo[i].commentatorId);
      commentsInfo[i].commentatorInfo=commentatorInfo;
    }
    return commentsInfo;
  }

  static Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      List<dynamic> usersIds) async {
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

  static updateProfileImage(
      {required String imageUrl, required String userId}) async {
    await _firestoreUserCollection.doc(userId).update({
      "profileImageUrl": imageUrl,
    });
  }

  static updateUserInfo(UserPersonalInfo userInfo) async {
    await _firestoreUserCollection
        .doc(userInfo.userId)
        .update(userInfo.toMap());
  }

  static followThisUser(String followingUserId, String myPersonalId) async {
    await _firestoreUserCollection.doc(followingUserId).update({
      'followers': FieldValue.arrayUnion([myPersonalId])
    });

    await _firestoreUserCollection.doc(myPersonalId).update({
      'following': FieldValue.arrayUnion([followingUserId])
    });
  }

  static removeThisFollower(String followingUserId, String myPersonalId) async {
    await _firestoreUserCollection.doc(followingUserId).update({
      'followers': FieldValue.arrayRemove([myPersonalId])
    });

    await _firestoreUserCollection.doc(myPersonalId).update({
      'following': FieldValue.arrayRemove([followingUserId])
    });
  }

  static Future<List> getSpecificUsersPosts(List<dynamic> usersIds) async {
    List postsInfo = [];
    for (int i = 0; i < usersIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _firestoreUserCollection.doc(usersIds[i]).get();
      if (snap.exists) {

        postsInfo+=snap.get('posts');
      } else {
        return Future.error("the post not exist !");
      }
    }
    return postsInfo;
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/massage.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import '../../../../core/utility/constant.dart';

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
      return UserPersonalInfo.fromDocSnap(docSnap: snap);
    } else {
      return Future.error(StringsManager.userNotExist.tr());
    }
  }

  static Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      List<dynamic> usersIds) async {
    List<UserPersonalInfo> usersInfo = [];
    List<dynamic> ids = [];
    for (int i = 0; i < usersIds.length; i++) {
      if (!ids.contains(usersIds[i])) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStoreUserCollection.doc(usersIds[i]).get();
        if (snap.exists) {
          UserPersonalInfo postReformat =
              UserPersonalInfo.fromDocSnap(docSnap: snap);
          usersInfo.add(postReformat);
        } else {
          return Future.error(StringsManager.userNotExist.tr());
        }
        ids.add(usersIds[i]);
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

  static Future<UserPersonalInfo?> getUserFromUserName(
      {required String userName}) async {
    UserPersonalInfo? userPersonalInfo;
    await _fireStoreUserCollection
        .where('userName', isEqualTo: userName)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> snap = snapshot.docs[0].data();
        userPersonalInfo = UserPersonalInfo.fromDocSnap(mapSnap: snap);
      }
    });
    return userPersonalInfo;
  }

  static updateUserPosts(
      {required String userId, required String postId}) async {
    await _fireStoreUserCollection.doc(userId).update({
      'posts': FieldValue.arrayUnion([postId])
    });
  }

  static updateUserStories(
      {required String userId, required String storyId}) async {
    await _fireStoreUserCollection.doc(userId).update({
      'stories': FieldValue.arrayUnion([storyId])
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

  static deleteThisStory({required String storyId}) async {
    await _fireStoreUserCollection.doc(myPersonalId).update({
      'stories': FieldValue.arrayRemove([storyId])
    });
  }

  static Future<List> getSpecificUsersPosts(List<dynamic> usersIds) async {
    List postsInfo = [];
    List<dynamic> usersIdsUnique = [];
    for (int i = 0; i < usersIds.length; i++) {
      if (!usersIdsUnique.contains(usersIds[i])) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStoreUserCollection.doc(usersIds[i]).get();
        if (snap.exists) {
          postsInfo += snap.get('posts');
        } else {
          return Future.error(StringsManager.userNotExist.tr());
        }
        usersIdsUnique.add(usersIds[i]);
      }
    }
    return postsInfo;
  }



  static Stream<List<UserPersonalInfo>> searchAboutUser(
      {required String name}) {
    name = name.toLowerCase();
    Stream<QuerySnapshot<Map<String, dynamic>>> snapSearch =
        _fireStoreUserCollection
            .where("charactersOfName", arrayContains: name)
            .snapshots();

    return snapSearch.map((snapshot) => snapshot.docs.map((doc) {
          UserPersonalInfo userInfo =
              UserPersonalInfo.fromDocSnap(docSnap: doc);
          return userInfo;
        }).toList());
  }


}

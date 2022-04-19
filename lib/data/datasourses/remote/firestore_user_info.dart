import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/data/models/user_personal_info.dart';

import '../../../core/utility/constant.dart';

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
        UserPersonalInfo postReformat =
            UserPersonalInfo.fromDocSnap(docSnap: snap);
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

  static Future<Massage> sendMassage({
    required String userId,
    required String chatId,
    required Massage massage,
  }) async {
    CollectionReference<Map<String, dynamic>> _fireMassagesCollection =
        _fireStoreUserCollection
            .doc(userId)
            .collection("chats")
            .doc(chatId)
            .collection("massages");

    DocumentReference<Map<String, dynamic>> massageRef =
        await _fireMassagesCollection.add(massage.toMap());

    massage.massageUid = massageRef.id;

    await _fireMassagesCollection
        .doc(massageRef.id)
        .update({"massageUid": massageRef.id});
    return massage;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMassages(
      {required String receiverId}) async* {
    // List<Massage> massagesInfo = [];
    Stream<QuerySnapshot<Map<String, dynamic>>> _snapshotsMassages =
        _fireStoreUserCollection
            .doc(myPersonalId)
            .collection("chats")
            .doc(receiverId)
            .collection("massages")
            .orderBy("datePublished", descending: false)
            .snapshots();
    print("QuerySnapshot ===============================");

    // _snapshotsMassages.listen((event) {
    //   for (var element in event.docs) {
    //     Map<String, dynamic> a = element.data();
    //     massagesInfo.add(Massage.fromJson(a));
    //   }
    // });
    yield* _snapshotsMassages;
  }
}

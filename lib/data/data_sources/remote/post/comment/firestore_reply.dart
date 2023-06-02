import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/data_sources/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class FireStoreReply {
  static final _fireStoreReplyCollection =
      FirebaseFirestore.instance.collection('replies');

  static Future<String> replyOnThisComment({required Comment replyInfo}) async {
    DocumentReference<Map<String, dynamic>> commentRef =
        await _fireStoreReplyCollection.add(replyInfo.toMapReply());

    await _fireStoreReplyCollection
        .doc(commentRef.id)
        .update({'replyUid': commentRef.id});
    return commentRef.id;
  }

  static Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    await _fireStoreReplyCollection.doc(replyId).update({
      'likes': FieldValue.arrayUnion([myPersonalId])
    });
  }

  static Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    await _fireStoreReplyCollection.doc(replyId).update({
      'likes': FieldValue.arrayRemove([myPersonalId])
    });
  }

  static Future<List<Comment>> getSpecificReplies(
      {required List<dynamic> repliesIds}) async {
    List<Comment> allReplies = [];

    for (int i = 0; i < repliesIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStoreReplyCollection.doc(repliesIds[i]).get();
      Comment replyReformat = Comment.fromSnapReply(snap);

      UserPersonalInfo whoReplyInfo =
          await FireStoreUser.getUserInfo(replyReformat.whoCommentId);
      replyReformat.whoCommentInfo = whoReplyInfo;

      allReplies.add(replyReformat);
    }
    return allReplies;
  }

  static Future<Comment> getReplyInfo({required String replyId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreReplyCollection.doc(replyId).get();
    if (snap.exists) {
      return Comment.fromSnapReply(snap);
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }
}

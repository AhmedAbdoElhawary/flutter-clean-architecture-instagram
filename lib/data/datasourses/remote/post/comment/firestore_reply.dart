import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/reply_comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class FirestoreReply {
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
          await FirestoreUser.getUserInfo(replyReformat.whoCommentId);
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
    }
    return Future.error("the user not exist !");
  }
}

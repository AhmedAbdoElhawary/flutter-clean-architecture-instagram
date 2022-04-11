import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/reply_comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class FirestoreReply {
  static final _fireStorePostCollection =
      FirebaseFirestore.instance.collection('posts');

  static Future<String> replyOnThisComment(
      {required String postId,
      required String commentId,
      required Comment replyInfo}) async {
    final _fireStoreReplyCollection = _fireStorePostCollection
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .collection("replies");

    DocumentReference<Map<String, dynamic>> commentRef =
        await _fireStoreReplyCollection.add(replyInfo.toMapReply());

    await _fireStoreReplyCollection
        .doc(commentRef.id)
        .update({'replyUid': commentRef.id});
    return commentRef.id;
  }

  static Future<List<Comment>> getRepliesInfo(
      {required List<Comment> repliesInfo}) async {
    for (int i = 0; i < repliesInfo.length; i++) {
      //TODO maybe here will happen some bugs
      UserPersonalInfo commentatorInfo =
          await FirestoreUser.getUserInfo(repliesInfo[i].commentatorId);
      repliesInfo[i].commentatorInfo = commentatorInfo;
      UserPersonalInfo infoOfPersonIReplyOnThem =
          await FirestoreUser.getUserInfo(
              repliesInfo[i].idOfPersonIReplyOnThem!);
      repliesInfo[i].infoOfPersonIReplyOnThem = infoOfPersonIReplyOnThem;
    }
    return repliesInfo;
  }

  static Future<void> putLikeOnThisReply(
      {required String postId,
      required String commentId,
      required String replyId,
      required String myPersonalId}) async {
    await _fireStorePostCollection
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .collection("replies")
        .doc(replyId)
        .update({
      'likes': FieldValue.arrayUnion([myPersonalId])
    });
  }

  static Future<void> removeLikeOnThisReply(
      {required String postId,
      required String commentId,
      required String replyId,
      required String myPersonalId}) async {
    await _fireStorePostCollection
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .collection("replies")
        .doc(replyId)
        .update({
      'likes': FieldValue.arrayRemove([myPersonalId])
    });
  }

  static Future<List<Comment>> getRepliesOfThisComment(
      {required String postId, required String commentId}) async {
    List<Comment> allReplies = [];

    final CollectionReference<Map<String, dynamic>>?
        _fireStoreRepliesCollection;
    try {
      _fireStoreRepliesCollection = _fireStorePostCollection
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .collection("replies");
    } catch (e) {
      return [];
    }
    QuerySnapshot<Map<String, dynamic>> snap =
        await _fireStoreRepliesCollection.get();

    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> doc = snap.docs[i];
      Comment replyReformat = Comment.fromSnapReply(doc);

      allReplies.add(replyReformat);
    }
    return allReplies;
  }

  static Future<Comment> getReplyInfo(
      {required String postId,
      required String commentId,
      required String replyId}) async {
    final _fireStoreRepliesCollection = _fireStorePostCollection
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .collection("replies");
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreRepliesCollection.doc(replyId).get();
    if (snap.exists) {
      return Comment.fromSnapReply(snap);
    }
    return Future.error("the user not exist !");
  }
}

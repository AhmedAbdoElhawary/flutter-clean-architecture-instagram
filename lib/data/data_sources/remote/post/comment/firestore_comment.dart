import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/data_sources/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class FirestoreComment {
  static final _fireStoreCommentCollection =
      FirebaseFirestore.instance.collection('comments');
  static Future<String> addComment({required Comment commentInfo}) async {
    DocumentReference<Map<String, dynamic>> commentRef =
        await _fireStoreCommentCollection.add(commentInfo.toMapComment());

    await _fireStoreCommentCollection
        .doc(commentRef.id)
        .update({'commentUid': commentRef.id});
    return commentRef.id;
  }

  static Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    await _fireStoreCommentCollection.doc(commentId).update({
      'likes': FieldValue.arrayUnion([myPersonalId])
    });
  }

  static Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    await _fireStoreCommentCollection.doc(commentId).update({
      'likes': FieldValue.arrayRemove([myPersonalId])
    });
  }

  static putReplyOnThisComment({
    required String commentId,
    required String replyId,
  }) async {
    await _fireStoreCommentCollection.doc(commentId).update({
      'replies': FieldValue.arrayUnion([replyId])
    });
  }

  static Future<List<dynamic>?> getRepliesOfComments(
      {required String commentId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreCommentCollection.doc(commentId).get();
    if (snap.exists) {
      Comment commentReformat = Comment.fromSnapComment(snap);

      return commentReformat.replies;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  static Future<List<Comment>> getSpecificComments(
      {required List<dynamic> commentsIds}) async {
    List<Comment> allComments = [];
    for (int i = 0; i < commentsIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStoreCommentCollection.doc(commentsIds[i]).get();
      Comment commentReformat = Comment.fromSnapComment(snap);

      UserPersonalInfo commentatorInfo =
          await FireStoreUser.getUserInfo(commentReformat.whoCommentId);
      commentReformat.whoCommentInfo = commentatorInfo;

      allComments.add(commentReformat);
    }
    return allComments;
  }

  static Future<Comment> getCommentInfo({required String commentId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreCommentCollection.doc(commentId).get();
    if (snap.exists) {
      Comment theCommentInfo = Comment.fromSnapComment(snap);
      UserPersonalInfo commentatorInfo =
          await FireStoreUser.getUserInfo(theCommentInfo.whoCommentId);
      theCommentInfo.whoCommentInfo = commentatorInfo;

      return theCommentInfo;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class FirestoreComment {
  static final _fireStorePostCollection =
      FirebaseFirestore.instance.collection('posts');
  static Future<String> addComment({required Comment commentInfo}) async {
    final _fireStoreCommentCollection =
        _fireStorePostCollection.doc(commentInfo.postId).collection("comments");

    DocumentReference<Map<String, dynamic>> commentRef =
        await _fireStoreCommentCollection.add(commentInfo.toMapComment());

    await _fireStoreCommentCollection
        .doc(commentRef.id)
        .update({'commentUid': commentRef.id});
    return commentRef.id;
  }

  static Future<List<Comment>> getCommentatorsInfo(
      List<Comment> commentsInfo) async {
    for (int i = 0; i < commentsInfo.length; i++) {
      //TODO maybe here will happen some bugs
      UserPersonalInfo commentatorInfo =
          await FirestoreUser.getUserInfo(commentsInfo[i].commentatorId);
      commentsInfo[i].commentatorInfo = commentatorInfo;
    }
    return commentsInfo;
  }

  static Future<void> putLikeOnThisComment(
      {required String postId,
      required String commentId,
      required String myPersonalId}) async {
    await _fireStorePostCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'likes': FieldValue.arrayUnion([myPersonalId])
    });
  }

  static Future<void> removeLikeOnThisComment(
      {required String postId,
      required String commentId,
      required String myPersonalId}) async {
    await _fireStorePostCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'likes': FieldValue.arrayRemove([myPersonalId])
    });
  }

  static Future<List<Comment>> getCommentsOfThisPost(
      {required String postId}) async {
    List<Comment> allComments = [];
    CollectionReference<Map<String, dynamic>>? _fireStoreCommentCollection;
    try {
      _fireStoreCommentCollection =
          _fireStorePostCollection.doc(postId).collection("comments");
    } catch (e) {
      return [];
    }

    QuerySnapshot<Map<String, dynamic>> snap =
        await _fireStoreCommentCollection.get();

    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> doc = snap.docs[i];
      Comment postReformat = Comment.fromSnapComment(doc);

      allComments.add(postReformat);
    }
    return allComments;
  }

  static Future<Comment> getCommentInfo(
      {required String commentId, required String postId}) async {
    final _fireStoreCommentCollection =
        _fireStorePostCollection.doc(postId).collection("comments");
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreCommentCollection.doc(commentId).get();
    if (snap.exists) {
      return Comment.fromSnapComment(snap);
    }
    return Future.error("the user not exist !");
  }
}

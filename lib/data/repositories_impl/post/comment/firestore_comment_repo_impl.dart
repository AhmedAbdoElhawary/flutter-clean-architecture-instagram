import 'package:instagram/data/data_sources/remote/post/comment/firestore_comment.dart';
import 'package:instagram/data/data_sources/remote/post/firestore_post.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instagram/domain/repositories/post/comment/comment_repository.dart';

class FirestoreCommentRepositoryImpl implements FirestoreCommentRepository {
  @override
  Future<Comment> addComment({required Comment commentInfo}) async {
    try {
      String commentId =
          await FirestoreComment.addComment(commentInfo: commentInfo);

      Comment theCommentInfo =
          await FirestoreComment.getCommentInfo(commentId: commentId);

      await FireStorePost.putCommentOnThisPost(
          postId: theCommentInfo.postId, commentId: theCommentInfo.commentUid);
      return theCommentInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    try {
      return await FirestoreComment.putLikeOnThisComment(
          myPersonalId: myPersonalId, commentId: commentId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    try {
      return await FirestoreComment.removeLikeOnThisComment(
          myPersonalId: myPersonalId, commentId: commentId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Comment>> getSpecificComments({required String postId}) async {
    try {
      List<dynamic> commentsIds =
          await FireStorePost.getCommentsOfPost(postId: postId);
      List<Comment> theComments =
          await FirestoreComment.getSpecificComments(commentsIds: commentsIds);

      return theComments;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

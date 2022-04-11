import 'package:instegram/data/models/comment.dart';

abstract class FirestoreCommentRepository {
  Future<List<Comment>> getCommentsOfThisPost({required String postId});
  Future<Comment> addComment({required Comment commentInfo});
  Future<void> putLikeOnThisComment(
      {required String postId,
      required String commentId,
      required String myPersonalId});
  Future<void> removeLikeOnThisComment(
      {required String postId,
      required String commentId,
      required String myPersonalId});
}

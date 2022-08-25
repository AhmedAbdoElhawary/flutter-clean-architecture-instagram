import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';

abstract class FirestoreCommentRepository {
  Future<Comment> addComment({required Comment commentInfo});
  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId});
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId});
  Future<List<Comment>> getSpecificComments({required String postId});
}

import 'package:instagram/data/models/comment.dart';
import 'package:instagram/data/models/post.dart';

abstract class FirestoreCommentRepository {
  Future<Comment> addComment({required Comment commentInfo});
  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId});
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId});
  Future<List<Comment>> getSpecificComments({required String postId});
}

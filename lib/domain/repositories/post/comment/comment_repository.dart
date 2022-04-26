import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/post.dart';

abstract class FirestoreCommentRepository {
  Future<Comment> addComment({required Comment commentInfo});
  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId});
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId});
  Stream<Post> getPostInfoStreamed({required String postId});
  Future<List<Comment>> getSpecificComments(
      {required List<dynamic> commentsIds});
}

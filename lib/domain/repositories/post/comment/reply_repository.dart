import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/reply_comment.dart';

abstract class FirestoreReplyRepository {
  Future<Comment> replyOnThisComment(
      {required String postId,
      required String commentId,
      required Comment replyInfo});
  Future<void> putLikeOnThisReply(
      {required String postId,
      required String commentId,
      required String replyId,
      required String myPersonalId});
  Future<void> removeLikeOnThisReply(
      {required String postId,
      required String commentId,
      required String replyId,
      required String myPersonalId});
  Future<List<Comment>> getRepliesOfThisComment(
      {required String postId, required String commentId});
}

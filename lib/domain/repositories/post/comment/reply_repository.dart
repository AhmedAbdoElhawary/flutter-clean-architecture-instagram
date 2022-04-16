import 'package:instegram/data/models/comment.dart';

abstract class FirestoreReplyRepository {
  Future<Comment> replyOnThisComment({required Comment replyInfo});
  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId});
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId});
  Future<List<Comment>> getSpecificReplies(
      {required String commentId});
}

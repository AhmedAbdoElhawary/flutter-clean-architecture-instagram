import 'package:instagram/data/datasourses/remote/post/comment/firestore_comment.dart';
import 'package:instagram/data/datasourses/remote/post/comment/firestore_reply.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instagram/domain/repositories/post/comment/reply_repository.dart';

class FirestoreRepliesRepositoryImpl implements FirestoreReplyRepository {
  @override
  Future<Comment> replyOnThisComment({required Comment replyInfo}) async {
    try {
      String replyId =
          await FirestoreReply.replyOnThisComment(replyInfo: replyInfo);

      Comment theReplyInfo =
          await FirestoreReply.getReplyInfo(replyId: replyId);
      await FirestoreComment.putReplyOnThisComment(
          commentId: theReplyInfo.parentCommentId,
          replyId: theReplyInfo.commentUid);

      return theReplyInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    try {
      await FirestoreReply.putLikeOnThisReply(
          replyId: replyId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    try {
      await FirestoreReply.removeLikeOnThisReply(
          replyId: replyId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Comment>> getSpecificReplies({required String commentId}) async {
    try {
      List? repliesIds =
          await FirestoreComment.getRepliesOfComments(commentId: commentId);
      List<Comment> theRepliesInfo =
          await FirestoreReply.getSpecificReplies(repliesIds: repliesIds!);
      return theRepliesInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

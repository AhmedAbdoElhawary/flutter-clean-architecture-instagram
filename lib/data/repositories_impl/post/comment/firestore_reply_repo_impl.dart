import 'package:instagram/data/data_sources/remote/post/comment/firestore_comment.dart';
import 'package:instagram/data/data_sources/remote/post/comment/firestore_reply.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instagram/domain/repositories/post/comment/reply_repository.dart';

class FireStoreRepliesRepositoryImpl implements FirestoreReplyRepository {
  @override
  Future<Comment> replyOnThisComment({required Comment replyInfo}) async {
    try {
      String replyId =
          await FireStoreReply.replyOnThisComment(replyInfo: replyInfo);

      Comment theReplyInfo =
          await FireStoreReply.getReplyInfo(replyId: replyId);
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
      await FireStoreReply.putLikeOnThisReply(
          replyId: replyId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    try {
      await FireStoreReply.removeLikeOnThisReply(
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
          await FireStoreReply.getSpecificReplies(repliesIds: repliesIds!);
      return theRepliesInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

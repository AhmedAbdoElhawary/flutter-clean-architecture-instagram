import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/datasourses/remote/post/comment/firestore_reply.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/reply_comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/repositories/post/comment/reply_repository.dart';

class FirestoreRepliesRepositoryImpl implements FirestoreReplyRepository {
  //TODO think on this
  @override
  Future<Comment> replyOnThisComment(
      {required String postId,
      required String commentId,
      required Comment replyInfo}) async {
    try {
      String replyId = await FirestoreReply.replyOnThisComment(
          postId: postId, commentId: commentId, replyInfo: replyInfo);

      Comment replyCommentInfo = await FirestoreReply.getReplyInfo(
          postId: postId, commentId: commentId, replyId: replyId);

      UserPersonalInfo whoReplyInfo =
          await FirestoreUser.getUserInfo(replyCommentInfo.commentatorId);

      UserPersonalInfo infoOfPersonIReplyOnThem =
          await FirestoreUser.getUserInfo(
              replyCommentInfo.idOfPersonIReplyOnThem!);

      replyCommentInfo.commentatorInfo = whoReplyInfo;
      replyCommentInfo.infoOfPersonIReplyOnThem = infoOfPersonIReplyOnThem;

      return replyCommentInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisReply(
      {required String postId,
      required String commentId,
      required String replyId,
      required String myPersonalId}) async {
    try {
      await FirestoreReply.putLikeOnThisReply(
          postId: postId,
          commentId: commentId,
          replyId: replyId,
          myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisReply(
      {required String postId,
      required String commentId,
      required String replyId,
      required String myPersonalId}) async {
    try {
      await FirestoreReply.removeLikeOnThisReply(
          postId: postId,
          commentId: commentId,
          replyId: replyId,
          myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Comment>> getRepliesOfThisComment(
      {required String postId, required String commentId}) async {
    try {
      List<Comment> theReply =
          await FirestoreReply.getRepliesOfThisComment(
              postId: postId, commentId: commentId);
      List<Comment> reformatTheComments =
          await FirestoreReply.getRepliesInfo(repliesInfo: theReply);
      return reformatTheComments;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

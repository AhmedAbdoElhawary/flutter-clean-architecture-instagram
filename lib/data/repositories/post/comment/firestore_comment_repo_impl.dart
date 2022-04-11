import 'package:instegram/data/datasourses/remote/post/comment/firestore_comment.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/datasourses/remote/post/firestore_post.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/repositories/post/comment/comment_repository.dart';

class FirestoreCommentRepositoryImpl implements FirestoreCommentRepository {

  @override
  Future<List<Comment>> getCommentsOfThisPost({required String postId}) async {
    try {
      List<Comment> theComments =
      await FirestoreComment.getCommentsOfThisPost(postId: postId);
      List<Comment> reformatTheComments =
      await FirestoreComment.getCommentatorsInfo(theComments);
      return reformatTheComments;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

//TODO think on this
  @override
  Future<Comment> addComment({required Comment commentInfo}) async {
    try {
      String commentId =
      await FirestoreComment.addComment(commentInfo: commentInfo);
FirestorePost.updateNumbersOfComments(postId: commentInfo.postId,oldNumbersOfComments: commentInfo.po)
      Comment theCommentInfo = await FirestoreComment.getCommentInfo(
          commentId: commentId, postId: commentInfo.postId!);

      UserPersonalInfo commentatorInfo =
      await FirestoreUser.getUserInfo(theCommentInfo.commentatorId);
      theCommentInfo.commentatorInfo = commentatorInfo;
      return theCommentInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisComment(
      {required String postId,
        required String commentId,
        required String myPersonalId}) async {
    try {
      return await FirestoreComment.putLikeOnThisComment(
          postId: postId, myPersonalId: myPersonalId, commentId: commentId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisComment(
      {required String postId,
        required String commentId,
        required String myPersonalId}) async {
    try {
      return await FirestoreComment.removeLikeOnThisComment(
          postId: postId, myPersonalId: myPersonalId, commentId: commentId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

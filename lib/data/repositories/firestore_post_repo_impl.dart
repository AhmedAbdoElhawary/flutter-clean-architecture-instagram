import 'dart:io';
import 'package:instegram/data/datasourses/remote/firebase_storage.dart';
import 'package:instegram/data/datasourses/remote/firestore_post.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import '../../domain/repositories/post_repository.dart';

class FirestorePostRepositoryImpl implements FirestorePostRepository {
  @override
  Future<String> createPost(
      {required Post postInfo, required File photo}) async {
    try {
      String postImageUrl =
          await FirebaseStorageImage.uploadImage(photo, 'postsImage');
      postInfo.postImageUrl = postImageUrl;
      String postUid = await FirestorePost.createPost(postInfo);
      return postUid;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getPostsInfo(List<dynamic> postId) async {
    try {
      return await FirestorePost.getPostsInfo(postId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getAllPostsInfo() async {
    try {
      return await FirestorePost.getAllPostsInfo();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List> getSpecificUsersPosts(List<dynamic> usersIds) async {
    try {
      return await FirestoreUser.getSpecificUsersPosts(usersIds);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisPost(
      {required String postId, required String userId}) async {
    try {
      return await FirestorePost.putLikeOnThisPost(
          postId: postId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeTheLikeOnThisPost(
      {required String postId, required String userId}) async {
    try {
      return await FirestorePost.removeTheLikeOnThisPost(
          postId: postId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Comment>> getCommentsOfThisPost({required String postId}) async {
    try {
      List<Comment> theComments =
          await FirestorePost.getCommentsOfThisPost(postId: postId);
      List<Comment> reformatTheComments =
          await FirestoreUser.getCommentatorsInfo(theComments);
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
          await FirestorePost.addComment(commentInfo: commentInfo);
      Comment theCommentInfo = await FirestorePost.getCommentInfo(
          commentId: commentId, postId: commentInfo.postId);

      UserPersonalInfo reformatTheComments =
          await FirestoreUser.getUserInfo(theCommentInfo.commentatorId);
      theCommentInfo.commentatorInfo = reformatTheComments;
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
      return await FirestorePost.putLikeOnThisComment(
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
      return await FirestorePost.removeLikeOnThisComment(
          postId: postId, myPersonalId: myPersonalId, commentId: commentId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

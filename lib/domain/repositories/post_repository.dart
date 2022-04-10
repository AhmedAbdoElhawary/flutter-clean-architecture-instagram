import 'dart:io';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/post.dart';

abstract class FirestorePostRepository {
  Future<String> createPost(
      {required Post postInfo,
      required File photo});
  Future<List<Post>> getPostsInfo(List<dynamic> postId);
  Future<List<Post>> getAllPostsInfo();
  Future<List> getSpecificUsersPosts(List<dynamic> usersIds);
  Future<void> putLikeOnThisPost({required String postId,required String userId});
  Future<void> removeTheLikeOnThisPost({required String postId,required String userId});
  Future<List<Comment>> getCommentsOfThisPost({required String postId});
  Future<Comment> addComment({required Comment commentInfo});
  Future<void> putLikeOnThisComment({required String postId,required String commentId,required String myPersonalId});
  Future<void> removeLikeOnThisComment({required String postId,required String commentId,required String myPersonalId});




  }

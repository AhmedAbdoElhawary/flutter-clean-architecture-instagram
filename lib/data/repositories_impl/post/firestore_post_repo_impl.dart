import 'dart:io';
import 'package:instegram/data/datasourses/remote/firebase_storage.dart';
import 'package:instegram/data/datasourses/remote/post/firestore_post.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/models/post.dart';
import '../../../domain/repositories/post/post_repository.dart';

class FirestorePostRepositoryImpl implements FirestorePostRepository {
  @override
  Future<String> createPost(
      {required Post postInfo, required File photo}) async {
    try {
      String postUrl =
          await FirebaseStoragePost.uploadFile(photo, 'postsImage');
      postInfo.postUrl = postUrl;
      String postUid = await FirestorePost.createPost(postInfo);
      return postUid;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getPostsInfo({required List<dynamic> postsIds,required int lengthOfCurrentList}) async {
    try {
      return await FirestorePost.getPostsInfo(postsIds:postsIds,lengthOfCurrentList: lengthOfCurrentList);
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
}

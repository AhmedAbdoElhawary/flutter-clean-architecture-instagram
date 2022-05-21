import 'dart:io';
import 'package:instagram/data/datasourses/remote/firebase_storage.dart';
import 'package:instagram/data/datasourses/remote/post/firestore_post.dart';
import 'package:instagram/data/datasourses/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/post.dart';
import '../../../domain/repositories/post/post_repository.dart';

class FirestorePostRepositoryImpl implements FirestorePostRepository {
  @override
  Future<String> createPost(
      {required Post postInfo, required List<File> files}) async {
    try {
      if (files.length == 1) {
        String postUrl =
            await FirebaseStoragePost.uploadFile(files[0], 'postsImage');
        postInfo.postUrl = postUrl;
      } else {
        for (int i = 0; i < files.length; i++) {
          String postUrl =
              await FirebaseStoragePost.uploadFile(files[i], 'postsImage');
          postInfo.imagesUrls.add(postUrl);
        }
      }
      String postUid = await FirestorePost.createPost(postInfo);
      return postUid;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds,
      required String userId,
      required int lengthOfCurrentList}) async {
    try {
      return await FirestorePost.getPostsInfo(
          postsIds: postsIds,
          userId: userId,
          lengthOfCurrentList: lengthOfCurrentList);
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
  Future<void> deletePost({required Post postInfo}) async {
    try {
      await FirestorePost.deletePost(postInfo: postInfo);
      await FirebaseStoragePost.deleteImageFromStorage(postInfo.postUrl);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Post> updatePost({required Post postInfo}) async {
    try {
      return await FirestorePost.updatePost(postInfo: postInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

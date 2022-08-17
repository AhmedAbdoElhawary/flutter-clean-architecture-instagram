import 'dart:typed_data';
import 'package:instagram/data/datasourses/remote/firebase_storage.dart';
import 'package:instagram/data/datasourses/remote/post/firestore_post.dart';
import 'package:instagram/data/datasourses/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/post.dart';
import '../../../domain/repositories/post/post_repository.dart';

class FirestorePostRepositoryImpl implements FirestorePostRepository {
  @override
  Future<String> createPost({
    required Post postInfo,
    required List<Uint8List> files,
    required Uint8List? coverOfVideo,
  }) async {
    try {
      for (int i = 0; i < files.length; i++) {
        String postUrl =
            await FirebaseStoragePost.uploadFile(files[i], 'postsImage');
        if (i == 0) postInfo.postUrl = postUrl;
        postInfo.imagesUrls.add(postUrl);
      }
      if (coverOfVideo != null) {
        String coverOfVideoUrl =
            await FirebaseStoragePost.uploadFile(coverOfVideo, 'postsVideo');
        postInfo.coverOfVideoUrl = coverOfVideoUrl;
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
      required int lengthOfCurrentList}) async {
    try {
      return await FirestorePost.getPostsInfo(
          postsIds: postsIds, lengthOfCurrentList: lengthOfCurrentList);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getAllPostsInfo(
      {bool isVideosWantedOnly = false, String skippedVideoUid = ""}) async {
    try {
      return await FirestorePost.getAllPostsInfo(
          isVideosWantedOnly: isVideosWantedOnly);
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

import 'dart:typed_data';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/datasourses/remote/firebase_storage.dart';
import 'package:instagram/data/datasourses/remote/post/firestore_post.dart';
import 'package:instagram/data/datasourses/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import '../../../domain/repositories/post/post_repository.dart';

class FireStorePostRepositoryImpl implements FireStorePostRepository {
  @override
  Future<Post> createPost({
    required Post postInfo,
    required List<SelectedByte> files,
    required Uint8List? coverOfVideo,
  }) async {
    try {
      bool isFirstPostImage = files[0].isThatImage;
      bool isThatMix = false;
      postInfo.isThatImage = isFirstPostImage;
      for (int i = 0; i < files.length; i++) {
        bool isThatImage = files[i].isThatImage;
        if (!isThatMix) isThatMix = !isThatImage == isFirstPostImage;

        String fileName = isThatImage ? "jpg" : "mp4";
        String postUrl;
        if (isThatMobile) {
          postUrl = await FirebaseStoragePost.uploadFile(
              postFile: files[i].selectedFile, folderName: fileName);
        } else {
          postUrl = await FirebaseStoragePost.uploadData(
              data: files[i].selectedByte, folderName: fileName);
        }

        if (i == 0) postInfo.postUrl = postUrl;
        postInfo.imagesUrls.add(postUrl);
      }
      if (coverOfVideo != null) {
        String coverOfVideoUrl = await FirebaseStoragePost.uploadData(
            data: coverOfVideo, folderName: 'postsVideo');
        postInfo.coverOfVideoUrl = coverOfVideoUrl;
      }

      postInfo.isThatMix = isThatMix;
      Post newPostInfo = await FirestorePost.createPost(postInfo);
      return newPostInfo;
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
      {required bool isVideosWantedOnly,
      required String skippedVideoUid}) async {
    try {
      return await FirestorePost.getAllPostsInfo(
          isVideosWantedOnly: isVideosWantedOnly,
          skippedVideoUid: skippedVideoUid);
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

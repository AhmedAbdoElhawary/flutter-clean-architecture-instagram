import 'dart:typed_data';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';

abstract class FireStorePostRepository {
  Future<Post> createPost({
    required Post postInfo,
    required List<SelectedByte> files,
    required Uint8List? coverOfVideo,
  });
  Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds, required int lengthOfCurrentList});
  Future<List<Post>> getAllPostsInfo(
      {required bool isVideosWantedOnly, required String skippedVideoUid});
  Future<List> getSpecificUsersPosts(List<dynamic> usersIds);
  Future<void> putLikeOnThisPost(
      {required String postId, required String userId});
  Future<void> removeTheLikeOnThisPost(
      {required String postId, required String userId});
  Future<void> deletePost({required Post postInfo});
  Future<Post> updatePost({required Post postInfo});
}

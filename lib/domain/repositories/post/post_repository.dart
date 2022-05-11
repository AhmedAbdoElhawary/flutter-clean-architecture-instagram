import 'dart:io';
import 'package:instagram/data/models/post.dart';

abstract class FirestorePostRepository {
  Future<String> createPost({required Post postInfo, required File photo});
  Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds, required int lengthOfCurrentList});
  Future<List<Post>> getAllPostsInfo();
  Future<List> getSpecificUsersPosts(List<dynamic> usersIds);
  Future<void> putLikeOnThisPost(
      {required String postId, required String userId});
  Future<void> removeTheLikeOnThisPost(
      {required String postId, required String userId});
}

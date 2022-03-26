import 'dart:io';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/post.dart';

abstract class FirestorePostRepository {
  Future<String> createPost(
      {required Post postInfo,
      required Comment commentInfo,
      required File photo});
  Future<List<Post>> getPostsInfo(List<dynamic> postId);
  Future<List<Post>> getAllPostsInfo();

}

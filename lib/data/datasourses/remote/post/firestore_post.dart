import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/datasourses/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';

class FirestorePost {
  static final _fireStorePostCollection =
      FirebaseFirestore.instance.collection('posts');

  static Future<String> createPost(Post postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _fireStorePostCollection.add(postInfo.toMap());

    await _fireStorePostCollection
        .doc(postRef.id)
        .update({"postUid": postRef.id});
    return postRef.id;
  }

  static Future<void> deletePost({required Post postInfo}) async {
    await _fireStorePostCollection.doc(postInfo.postUid).delete();
    await FirestoreUser.removeUserPost(postId: postInfo.postUid);
  }

  static Future<Post> updatePost({required Post postInfo}) async {
    await _fireStorePostCollection
        .doc(postInfo.postUid)
        .update({'caption': postInfo.caption});
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.doc(postInfo.postUid).get();
    return Post.fromQuery(query: snap);
  }

  static Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds,
      required int lengthOfCurrentList}) async {
    List<Post> postsInfo = [];
    int condition = postsIds.length;
    if (lengthOfCurrentList != -1) {
      int lengthOfOriginPost = postsIds.length;
      int lengthOfData = lengthOfOriginPost > 5 ? 5 : lengthOfOriginPost;
      int addMoreData = lengthOfCurrentList + 5;
      lengthOfData =
          addMoreData < lengthOfOriginPost ? addMoreData : lengthOfOriginPost;
      condition = lengthOfData;
    }
    for (int i = 0; i < condition; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStorePostCollection.doc(postsIds[i]).get();
      if (snap.exists) {
        Post postReformat = Post.fromQuery(query: snap);
        UserPersonalInfo publisherInfo =
            await FirestoreUser.getUserInfo(postReformat.publisherId);
        postReformat.publisherInfo = publisherInfo;
        postsInfo.add(postReformat);
      } else {
        FirestoreUser.removeUserPost(postId: postsIds[i]);
      }
    }
    return postsInfo;
  }

  static Future<List<dynamic>> getCommentsOfPost(
      {required String postId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.doc(postId).get();
    if (snap.exists) {
      Post postReformat = Post.fromQuery(query: snap);
      return postReformat.comments;
    } else {
      return Future.error(StringsManager.userNotExist.tr());
    }
  }

  static Future<List<Post>> getAllPostsInfo() async {
    List<Post> allPosts = [];
    QuerySnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.get();

    for (final doc in snap.docs) {
      Post postReformat = Post.fromQuery(doc: doc);
      UserPersonalInfo publisherInfo =
          await FirestoreUser.getUserInfo(postReformat.publisherId);
      postReformat.publisherInfo = publisherInfo;

      allPosts.add(postReformat);
    }
    return allPosts;
  }

  static putLikeOnThisPost(
      {required String postId, required String userId}) async {
    await _fireStorePostCollection.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId])
    });
  }

  static removeTheLikeOnThisPost(
      {required String postId, required String userId}) async {
    await _fireStorePostCollection.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId])
    });
  }

  static putCommentOnThisPost(
      {required String postId, required String commentId}) async {
    await _fireStorePostCollection.doc(postId).update({
      'comments': FieldValue.arrayUnion([commentId])
    });
  }

  static removeTheCommentOnThisPost(
      {required String postId, required String commentId}) async {
    await _fireStorePostCollection.doc(postId).update({
      'comments': FieldValue.arrayRemove([commentId])
    });
  }
}

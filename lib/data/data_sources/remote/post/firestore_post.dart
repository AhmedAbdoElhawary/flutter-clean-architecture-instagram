import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/data_sources/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class FireStorePost {
  static final _fireStorePostCollection =
      FirebaseFirestore.instance.collection('posts');

  static Future<Post> createPost(Post postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _fireStorePostCollection.add(postInfo.toMap());

    await _fireStorePostCollection
        .doc(postRef.id)
        .update({"postUid": postRef.id});
    postInfo.postUid = postRef.id;
    return postInfo;
  }

  static Future<void> deletePost({required Post postInfo}) async {
    await _fireStorePostCollection.doc(postInfo.postUid).delete();
    await FireStoreUser.removeUserPost(postId: postInfo.postUid);
  }

  static Future<Post> updatePost({required Post postInfo}) async {
    await _fireStorePostCollection
        .doc(postInfo.postUid)
        .update({'caption': postInfo.caption});
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.doc(postInfo.postUid).get();
    return Post.fromQuery(doc: snap);
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
      try {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStorePostCollection.doc(postsIds[i]).get();
        if (snap.exists) {
          Post postReformat = Post.fromQuery(doc: snap);
          if (postReformat.postUrl.isNotEmpty) {
            UserPersonalInfo publisherInfo =
                await FireStoreUser.getUserInfo(postReformat.publisherId);
            postReformat.publisherInfo = publisherInfo;
            postsInfo.add(postReformat);
          } else {
            await deletePost(postInfo: postReformat);
          }
        } else {
          FireStoreUser.removeUserPost(postId: postsIds[i]);
        }
      } catch (e) {
        continue;
      }
    }
    return postsInfo;
  }

  static Future<List<dynamic>> getCommentsOfPost(
      {required String postId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.doc(postId).get();
    if (snap.exists) {
      Post postReformat = Post.fromQuery(doc: snap);
      return postReformat.comments;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  static Future<List<Post>> getAllPostsInfo(
      {required bool isVideosWantedOnly,
      required String skippedVideoUid}) async {
    List<Post> allPosts = [];
    QuerySnapshot<Map<String, dynamic>> snap;
    if (isVideosWantedOnly) {
      snap = await _fireStorePostCollection
          .where("isThatImage", isEqualTo: false)
          .get();
    } else {
      snap = await _fireStorePostCollection.get();
    }
    for (final doc in snap.docs) {
      if (skippedVideoUid == doc.id) continue;
      Post postReformat = Post.fromQuery(query: doc);
      UserPersonalInfo publisherInfo =
          await FireStoreUser.getUserInfo(postReformat.publisherId);
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

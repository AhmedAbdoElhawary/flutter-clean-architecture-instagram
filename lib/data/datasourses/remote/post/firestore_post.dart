import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/data/models/user_personal_info.dart';

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

  static Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds,
      required int lengthOfCurrentList}) async {
    List<Post> postsInfo = [];
    int lengthOfOriginPost = postsIds.length;
    int lengthOfData = lengthOfOriginPost > 5 ? 5 : lengthOfOriginPost;
    if (lengthOfCurrentList != 0) {
      int addMoreData = lengthOfCurrentList + 5;
      lengthOfData =
          addMoreData < lengthOfOriginPost ? addMoreData : lengthOfOriginPost;
    }
    for (int i = 0; i < lengthOfData; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStorePostCollection.doc(postsIds[i]).get();
      if (snap.exists) {
        Post postReformat = Post.fromSnap(docSnap: snap);
        UserPersonalInfo publisherInfo =
            await FirestoreUser.getUserInfo(postReformat.publisherId);
        postReformat.publisherInfo = publisherInfo;
        postsInfo.add(postReformat);
      } else {
        return Future.error(StringsManager.userNotExist.tr());
      }
    }
    return postsInfo;
  }

  static Future<List<dynamic>> getCommentsOfPost(
      {required String postId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.doc(postId).get();
    if (snap.exists) {
      Post postReformat = Post.fromSnap(docSnap: snap);
      return postReformat.comments;
    } else {
      return Future.error(StringsManager.userNotExist.tr());
    }
  }

  static Future<List<Post>> getAllPostsInfo() async {
    List<Post> allPosts = [];
    QuerySnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.get();

    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> doc = snap.docs[i];
      Post postReformat = Post.fromSnap(querySnap: doc);
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

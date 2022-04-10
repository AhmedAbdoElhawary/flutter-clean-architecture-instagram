import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/models/comment.dart';
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

  static Future<String> addComment({required Comment commentInfo}) async {
    final _fireStoreCommentCollection =
        _fireStorePostCollection.doc(commentInfo.postId).collection("comments");

    DocumentReference<Map<String, dynamic>> commentRef =
        await _fireStoreCommentCollection.add(commentInfo.toMap());

    await _fireStoreCommentCollection
        .doc(commentRef.id)
        .update({'commentUid': commentRef.id});
    return commentRef.id;
  }
  static Future<void> putLikeOnThisComment({required String postId,required String commentId,required String myPersonalId}) async {
    await _fireStorePostCollection.doc(postId).collection('comments').doc(commentId).update({
      'likes': FieldValue.arrayUnion([myPersonalId])
    });
  }
  static Future<void> removeLikeOnThisComment({required String postId,required String commentId,required String myPersonalId}) async {
    await _fireStorePostCollection.doc(postId).collection('comments').doc(commentId).update({
      'likes': FieldValue.arrayRemove([myPersonalId])
    });
  }

  static Future<List<Comment>> getCommentsOfThisPost({required String postId}) async {
    List<Comment> allComments = [];

    final _fireStoreCommentCollection =
        _fireStorePostCollection.doc(postId).collection("comments");
    QuerySnapshot<Map<String, dynamic>> snap =
        await _fireStoreCommentCollection.get();

    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> doc = snap.docs[i];
      Comment postReformat = Comment.fromSnap(doc)   ;

      allComments.add(postReformat);
    }
    return allComments;
  }

  static Future<Comment> getCommentInfo(
      {required String commentId,required String postId}) async {
    final _fireStoreCommentCollection =
        _fireStorePostCollection.doc(postId).collection("comments");
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreCommentCollection.doc(commentId).get();
    if (snap.exists) {
      return Comment.fromSnap(snap);
    }
    return Future.error("the user not exist !");
  }

  static Future<List<Post>> getPostsInfo(List<dynamic> postsIds) async {
    List<Post> postsInfo = [];
    for (int i = 0; i < postsIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStorePostCollection.doc(postsIds[i]).get();
      if (snap.exists) {
        Post postReformat = Post.fromJson(snap);
        UserPersonalInfo publisherInfo =
            await FirestoreUser.getUserInfo(postReformat.publisherId);
        postReformat.publisherInfo = publisherInfo;
        postsInfo.add(postReformat);
      } else {
        return Future.error("the post not exist !");
      }
    }
    return postsInfo;
  }

  static Future<List<Post>> getAllPostsInfo() async {
    List<Post> allPosts = [];
    QuerySnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.get();

    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> doc = snap.docs[i];
      Post postReformat = Post.fromSnap(doc);
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
}

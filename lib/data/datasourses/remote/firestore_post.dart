import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class FirestorePost {
  static final _firestorePostCollection =
      FirebaseFirestore.instance.collection('posts');

  static Future<String> createPost(Post postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _firestorePostCollection.add(postInfo.toMap());

    await _firestorePostCollection
        .doc(postRef.id)
        .update({"postUid": postRef.id});
    return postRef.id;
  }

  static addComment(Comment commentInfo) async {
    final _firestoreCommentCollection =
        _firestorePostCollection.doc(commentInfo.postId).collection("comments");

    DocumentReference<Map<String, dynamic>> commentRef =
        await _firestoreCommentCollection.add(commentInfo.toMap());

    await _firestoreCommentCollection
        .doc(commentRef.id)
        .update({'commentUid': commentRef.id});
  }

  static Future<List<Post>> getPostsInfo(List<dynamic> postsIds) async {
    List<Post> postsInfo = [];
    for (int i = 0; i < postsIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _firestorePostCollection.doc(postsIds[i]).get();
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
    List<Post> allData = [];
    QuerySnapshot<Map<String, dynamic>> snap =
        await _firestorePostCollection.get();

    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> doc = snap.docs[i];
      Post postReformat = Post.fromSnap(doc);
      UserPersonalInfo publisherInfo =
          await FirestoreUser.getUserInfo(postReformat.publisherId);
      postReformat.publisherInfo = publisherInfo;

      allData.add(postReformat);
    }
    return allData;
  }

  static putLikeOnThisPost({required String postId,required String userId}) async {
    await _firestorePostCollection.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId])

    });
  }
  static removeTheLikeOnThisPost({required String postId,required String userId}) async {
    await _firestorePostCollection.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId])
    });
  }

}

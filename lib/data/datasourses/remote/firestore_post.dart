import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/post.dart';

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

  static Future<List<Post>> getPostInfo(List<String> postIds) async {
    List<Post> postsInfo = [];
    for (int i = 0; i < postIds.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _firestorePostCollection.doc(postIds[i]).get();
      if (snap.exists) {
        postsInfo.add(Post.fromSnap(snap));
      }
      return Future.error("the post not exist !");
    }
    return postsInfo;
  }
}

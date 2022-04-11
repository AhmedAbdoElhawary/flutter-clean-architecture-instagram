import 'package:cloud_firestore/cloud_firestore.dart';
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

  //it's belong to post not comment (it's just update a field)
  static Future<void> updateNumbersOfComments(
      {required String postId, required int oldNumbersOfComments}) async {
    await _fireStorePostCollection
        .doc(postId)
        .update({"numbersOfComments": oldNumbersOfComments + 1});
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

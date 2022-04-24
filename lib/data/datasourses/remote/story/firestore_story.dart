import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/story.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class FireStoreStory {
  static final _fireStoreStoryCollection =
      FirebaseFirestore.instance.collection('stories');

  static Future<String> createPost(Story postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _fireStoreStoryCollection.add(postInfo.toMap());

    await _fireStoreStoryCollection
        .doc(postRef.id)
        .update({"storyUid": postRef.id});
    return postRef.id;
  }

  static Future<List<UserPersonalInfo>> getPostsInfo(
      List<UserPersonalInfo> usersInfo) async {
    for (int i = 0; i < usersInfo.length; i++) {
      List<dynamic> userStories = usersInfo[i].stories;
      if (userStories.isEmpty) {
        usersInfo.removeAt(i);
        i--;
        continue;
      }
      for (int j = 0; j < userStories.length; j++) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStoreStoryCollection.doc(userStories[j]).get();
        if (snap.exists) {
          Story postReformat = Story.fromSnap(docSnap: snap);

          postReformat.publisherInfo = usersInfo[i];
          if (usersInfo[i].storiesInfo == null) {
            usersInfo[i].storiesInfo = [postReformat];
          } else {
            usersInfo[i].storiesInfo!.add(postReformat);
          }
        } else {
          return Future.error("the story not exist !");
        }
      }
    }
    return usersInfo;
  }
}

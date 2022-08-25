import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/child_classes/post/story.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class FireStoreStory {
  static final _fireStoreStoryCollection =
      FirebaseFirestore.instance.collection('stories');

  static Future<String> createStory(Story postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _fireStoreStoryCollection.add(postInfo.toMap());

    await _fireStoreStoryCollection
        .doc(postRef.id)
        .update({"storyUid": postRef.id});
    return postRef.id;
  }

  static Future<void> deleteThisStory({required String storyId}) async =>
      await _fireStoreStoryCollection.doc(storyId).delete();

  static Future<List<UserPersonalInfo>> getStoriesInfo(
      List<UserPersonalInfo> usersInfo) async {
    List<Story> storiesInfo = [];
    List<String> storiesIds = [];
    for (int i = 0; i < usersInfo.length; i++) {
      storiesInfo = [];
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
          if (postReformat.storyUrl.isNotEmpty) {
            postReformat.publisherInfo = usersInfo[i];
            if (!storiesIds.contains(postReformat.storyUid)) {
              storiesInfo.add(postReformat);
              storiesIds.add(postReformat.storyUid);
            }
          }
        }
      }
      usersInfo[i].storiesInfo = storiesInfo;
    }
    return usersInfo;
  }
}

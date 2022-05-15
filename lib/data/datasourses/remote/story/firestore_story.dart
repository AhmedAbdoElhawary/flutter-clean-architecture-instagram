import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/story.dart';
import 'package:instagram/data/models/user_personal_info.dart';

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
    List<UserPersonalInfo> usersStoriesInfo = usersInfo;
    List<String> storiesIds = [];
    for (int i = 0; i < usersStoriesInfo.length; i++) {
      List<dynamic> userStories = usersStoriesInfo[i].stories;
      if (userStories.isEmpty) {
        usersStoriesInfo.removeAt(i);
        i--;
        continue;
      }
      for (int j = 0; j < userStories.length; j++) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStoreStoryCollection.doc(userStories[j]).get();
        if (snap.exists) {
          Story postReformat = Story.fromSnap(docSnap: snap);
          postReformat.publisherInfo = usersStoriesInfo[i];
          if (usersStoriesInfo[i].storiesInfo == null) {
            usersStoriesInfo[i].storiesInfo = [postReformat];
            storiesIds.add(postReformat.storyUid);
          } else if (!storiesIds.contains(postReformat.storyUid)) {
            usersStoriesInfo[i].storiesInfo!.add(postReformat);
            storiesIds.add(postReformat.storyUid);
          }
        }
      }
    }
    return usersStoriesInfo;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/core/resources/strings_manager.dart';
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
            print(
                "wwwwwwwwwwwwwwwwwwwwwwwwwww ${usersStoriesInfo[i].storiesInfo!.length}");
            storiesIds.add(postReformat.storyUid);
          } else if (!storiesIds.contains(postReformat.storyUid)) {
            usersStoriesInfo[i].storiesInfo!.add(postReformat);
            print(
                "qqqqqqqqqqqqqqqqqqqqqqqqqqq ${usersStoriesInfo[i].storiesInfo!.length}");
            storiesIds.add(postReformat.storyUid);
          }
        } else {
          return Future.error(StringsManager.userNotExist);
        }
      }
    }
    return usersStoriesInfo;
  }
}

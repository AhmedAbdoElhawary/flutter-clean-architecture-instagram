import 'dart:io';
import 'package:instegram/data/datasourses/remote/firebase_storage.dart';
import 'package:instegram/data/datasourses/remote/firestore_user_info.dart';
import 'package:instegram/data/datasourses/remote/story/firestore_story.dart';
import 'package:instegram/data/models/story.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/repositories/story_repository.dart';

class FirestoreStoryRepositoryImpl implements FirestoreStoryRepository {
  @override
  Future<String> createStory(
      {required Story storyInfo, required File photo}) async {
    try {
      String postUrl =
          await FirebaseStoragePost.uploadFile(photo, 'postsImage');
      storyInfo.storyUrl = postUrl;
      String postUid = await FireStoreStory.createPost(storyInfo);
      return postUid;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UserPersonalInfo>> getStoriesInfo(
      {required List<dynamic> usersIds,
      required UserPersonalInfo myPersonalInfo}) async {
    try {
      List<UserPersonalInfo> usersInfo =
          await FirestoreUser.getSpecificUsersInfo(usersIds);
      usersInfo.add(myPersonalInfo);
      return await FireStoreStory.getPostsInfo(usersInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

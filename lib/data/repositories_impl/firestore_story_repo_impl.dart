import 'dart:typed_data';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/datasourses/remote/firebase_storage.dart';
import 'package:instagram/data/datasourses/remote/user/firestore_user_info.dart';
import 'package:instagram/data/datasourses/remote/story/firestore_story.dart';
import 'package:instagram/data/models/story.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/repositories/story_repository.dart';

class FirestoreStoryRepositoryImpl implements FirestoreStoryRepository {
  @override
  Future<String> createStory(
      {required Story storyInfo, required Uint8List file}) async {
    try {
      String postUrl = await FirebaseStoragePost.uploadData(
          data: file, folderName: 'postsImage');
      storyInfo.storyUrl = postUrl;
      String storyUid = await FireStoreStory.createStory(storyInfo);
      await FirestoreUser.updateUserStories(
          userId: storyInfo.publisherId, storyId: storyUid);
      return storyUid;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UserPersonalInfo>> getStoriesInfo(
      {required List<dynamic> usersIds}) async {
    try {
      List<UserPersonalInfo> usersInfo =
          await FirestoreUser.getSpecificUsersInfo(
              usersIds: usersIds, userUid: myPersonalId, fieldName: 'stories');
      return await FireStoreStory.getStoriesInfo(usersInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo}) async {
    try {
      return (await FireStoreStory.getStoriesInfo([userInfo]))[0];
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteThisStory({required String storyId}) async {
    try {
      await FirestoreUser.deleteThisStory(storyId: storyId);
      await FireStoreStory.deleteThisStory(storyId: storyId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

import 'dart:typed_data';
import 'package:instagram/data/models/story.dart';
import 'package:instagram/data/models/user_personal_info.dart';

abstract class FirestoreStoryRepository {
  Future<String> createStory({required Story storyInfo, required Uint8List file});
  Future<List<UserPersonalInfo>> getStoriesInfo(
      {required List<dynamic> usersIds});
  Future<UserPersonalInfo> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo});
  Future<void> deleteThisStory({required String storyId});
}

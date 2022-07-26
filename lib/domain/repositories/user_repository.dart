import 'dart:typed_data';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/sender_info.dart';
import 'package:instagram/data/models/specific_users_info.dart';
import 'package:instagram/data/models/user_personal_info.dart';

abstract class FirestoreUserRepository {
  Future<void> addNewUser(UserPersonalInfo newUserInfo);

  Future<UserPersonalInfo> getPersonalInfo(String userId);
  Future<List<UserPersonalInfo>> getAllUnFollowersUsers(
      UserPersonalInfo myPersonalInfo);

  Future<UserPersonalInfo?> getUserFromUserName({required String userName});
  Future<UserPersonalInfo> updateUserPostsInfo(
      {required String userId, required String postId});
  // Future<UserPersonalInfo> updateUserStoriesInfo(
  //     {required String userId, required String storyId});
  Future<UserPersonalInfo> updateUserInfo({required UserPersonalInfo userInfo});

  Future<String> uploadProfileImage(
      {required Uint8List photo,
      required String userId,
      required String previousImageUrl});

  Future<FollowersAndFollowingsInfo> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds});

  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {required List<dynamic> usersIds});

  Future<void> followThisUser(String followingUserId, String myPersonalId);

  Future<void> removeThisFollower(String followingUserId, String myPersonalId);

  Future<Message> sendMessage(
      {required Message messageInfo,
       Uint8List? pathOfPhoto,
        required String pathOfRecorded});

  Stream<List<Message>> getMessages({required String receiverId});
  Stream<List<UserPersonalInfo>> searchAboutUser({required String name});
  Future<void> deleteMessage(
      {required Message messageInfo, Message? replacedMessage});
  Future<List<SenderInfo>> getChatUserInfo({required String userId});
}

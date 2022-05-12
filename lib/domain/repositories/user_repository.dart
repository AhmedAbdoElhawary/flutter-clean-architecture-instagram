import 'dart:io';
import 'package:instagram/data/models/massage.dart';
import 'package:instagram/data/models/specific_users_info.dart';
import 'package:instagram/data/models/user_personal_info.dart';

abstract class FirestoreUserRepository {
  Future<void> addNewUser(UserPersonalInfo newUserInfo);

  Future<UserPersonalInfo> getPersonalInfo(String userId);
  Future<UserPersonalInfo?> getUserFromUserName({required String userName});
  Future<UserPersonalInfo> updateUserPostsInfo(
      {required String userId, required String postId});
  Future<UserPersonalInfo> updateUserStoriesInfo(
      {required String userId, required String storyId});
  Future<UserPersonalInfo> updateUserInfo({required UserPersonalInfo userInfo});

  Future<String> uploadProfileImage(
      {required File photo,
      required String userId,
      required String previousImageUrl});

  Future<FollowersAndFollowingsInfo> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds});

  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {required List<dynamic> usersIds});

  Future<void> followThisUser(String followingUserId, String myPersonalId);

  Future<void> removeThisFollower(String followingUserId, String myPersonalId);

  Future<Massage> sendMassage(
      {required Massage massageInfo,
      required String pathOfPhoto,
      required String pathOfRecorded});

  Stream<List<Massage>> getMassages({required String receiverId});
  Stream<List<UserPersonalInfo>> searchAboutUser({required String name});
  Future<void> deleteMassage({required Massage massageInfo});
}

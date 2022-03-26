import 'dart:io';
import 'package:instegram/data/models/user_personal_info.dart';

abstract class FirestoreUserRepository {
  Future<void> addNewUser(UserPersonalInfo newUserInfo);
  Future<UserPersonalInfo> getPersonalInfo(String userId);
  Future<List<UserPersonalInfo>> getSpecificUsersInfo(List<dynamic> usersIds);
  Future<UserPersonalInfo> updateUserInfo(UserPersonalInfo updatedUserInfo);
  Future<String> uploadProfileImage(
      {required File photo,
      required String userId,
      required String previousImageUrl});

}

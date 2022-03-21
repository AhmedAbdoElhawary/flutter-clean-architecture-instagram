import 'dart:io';

import 'package:instegram/data/models/user_personal_info.dart';
import '../../domain/repositories/firestore_user_repo.dart';
import '../datasourses/remote/firebase_user_info.dart';

class FirebaseUserRepoImpl implements FirestoreUserRepository {
  @override
  Future<void> addNewUser(UserPersonalInfo newUserInfo) async {
    try {
      return await FirestoreUsers.addNewUser(newUserInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getPersonalInfo(String userId) async {
    try {
      return await FirestoreUsers.getUserInfo(userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> updateUserInfo(
      UserPersonalInfo updatedUserInfo) async {
    try {
      await FirestoreUsers.updateUserInfo(updatedUserInfo);
      return getPersonalInfo(updatedUserInfo.userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage({required File photo, required String userId}) async {
    try {
      String imageUrl=await FirestoreUsers.uploadImage(photo);
     await FirestoreUsers.updateProfileImage(imageUrl: imageUrl, userId: userId);
      return imageUrl;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

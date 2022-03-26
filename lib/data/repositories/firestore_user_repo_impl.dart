import 'dart:io';

import 'package:instegram/data/datasourses/remote/firebase_storage.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasourses/remote/firestore_user_info.dart';

class FirebaseUserRepoImpl implements FirestoreUserRepository {
  @override
  Future<void> addNewUser(UserPersonalInfo newUserInfo) async {
    try {
      return await FirestoreUser.createUser(newUserInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getPersonalInfo(String userId) async {
    try {
      return await FirestoreUser.getUserInfo(userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> updateUserInfo(
      UserPersonalInfo updatedUserInfo) async {
    try {
      await FirestoreUser.updateUserInfo(updatedUserInfo);
      return getPersonalInfo(updatedUserInfo.userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage({required File photo, required String userId,required String previousImageUrl}) async {
    try {
      String imageUrl=await FirebaseStorageImage.uploadImage(photo,'personalImage');
     await FirestoreUser.updateProfileImage(imageUrl: imageUrl, userId: userId);
     await FirebaseStorageImage.deleteImageFromStorage(previousImageUrl);
      return imageUrl;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UserPersonalInfo>> getSpecificUsersInfo(List<dynamic> usersIds) async {
    try {
      return await FirestoreUser.getSpecificUsersInfo(usersIds);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

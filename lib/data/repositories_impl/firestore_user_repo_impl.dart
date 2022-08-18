import 'dart:io';
import 'dart:typed_data';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/datasourses/remote/firebase_storage.dart';
import 'package:instagram/data/datasourses/remote/notification/firebase_notification.dart';
import 'package:instagram/data/datasourses/remote/user/message.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/sender_info.dart';
import 'package:instagram/data/models/specific_users_info.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasourses/remote/user/firestore_user_info.dart';

class FirebaseUserRepoImpl implements FirestoreUserRepository {
  @override
  Future<void> addNewUser(UserPersonalInfo newUserInfo) async {
    try {
      await FirestoreUser.createUser(newUserInfo);
      await FirestoreNotification.createNewDeviceToken(
          userId: newUserInfo.userId, myPersonalInfo: newUserInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getPersonalInfo(
      {required String userId, bool getDeviceToken = false}) async {
    try {
      UserPersonalInfo myPersonalInfo = await FirestoreUser.getUserInfo(userId);
      if (getDeviceToken) {
        UserPersonalInfo updateInfo =
            await FirestoreNotification.createNewDeviceToken(
                userId: userId, myPersonalInfo: myPersonalInfo);
        myPersonalInfo = updateInfo;
      }
      return myPersonalInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> updateUserInfo(
      {required UserPersonalInfo userInfo}) async {
    try {
      await FirestoreUser.updateUserInfo(userInfo);
      return getPersonalInfo(userId: userInfo.userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> updateUserPostsInfo(
      {required String userId, required String postId}) async {
    try {
      await FirestoreUser.updateUserPosts(userId: userId, postId: postId);
      return await getPersonalInfo(userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage(
      {required Uint8List photo,
      required String userId,
      required String previousImageUrl}) async {
    try {
      String imageUrl =
          await FirebaseStoragePost.uploadFile(photo, 'personalImage');
      await FirestoreUser.updateProfileImage(
          imageUrl: imageUrl, userId: userId);
      await FirebaseStoragePost.deleteImageFromStorage(previousImageUrl);
      return imageUrl;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<FollowersAndFollowingsInfo> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds}) async {
    try {
      List<UserPersonalInfo> followersInfo =
          await FirestoreUser.getSpecificUsersInfo(
              usersIds: followersIds,
              fieldName: "followers",
              userUid: myPersonalId);
      List<UserPersonalInfo> followingsInfo =
          await FirestoreUser.getSpecificUsersInfo(
              usersIds: followingsIds,
              fieldName: "following",
              userUid: myPersonalId);
      return FollowersAndFollowingsInfo(
          followersInfo: followersInfo, followingsInfo: followingsInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> followThisUser(
      String followingUserId, String myPersonalId) async {
    try {
      return await FirestoreUser.followThisUser(followingUserId, myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> unFollowThisUser(
      String followingUserId, String myPersonalId) async {
    try {
      return await FirestoreUser.unFollowThisUser(
          followingUserId, myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// [fieldName] , [userUid] in case one of this users not exist, it will be deleted from the list in fireStore

  @override
  Future<List<UserPersonalInfo>> getSpecificUsersInfo({
    required List<dynamic> usersIds,
  }) async {
    try {
      return await FirestoreUser.getSpecificUsersInfo(usersIds: usersIds);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo?> getUserFromUserName(
      {required String userName}) async {
    try {
      return await FirestoreUser.getUserFromUserName(userName: userName);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Message> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      required String pathOfRecorded}) async {
    try {
      if (pathOfPhoto != null) {
        String imageUrl =
            await FirebaseStoragePost.uploadFile(pathOfPhoto, "messagesFiles");
        messageInfo.imageUrl = imageUrl;
      }
      if (pathOfRecorded.isNotEmpty) {
        String recordedUrl = await FirebaseStoragePost.uploadFile(
            pathOfPhoto!, "messagesFiles",
            postFile: File(pathOfRecorded));
        messageInfo.recordedUrl = recordedUrl;
      }

      Message myMessageInfo = await FireStoreMessage.sendMessage(
          userId: messageInfo.senderId,
          chatId: messageInfo.receiverId,
          message: messageInfo);
      await FireStoreMessage.sendMessage(
        userId: messageInfo.receiverId,
        chatId: messageInfo.senderId,
        message: messageInfo,
      );

      return myMessageInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Message>> getMessages({required String receiverId}) =>
      FireStoreMessage.getMessages(receiverId: receiverId);

  @override
  Stream<List<UserPersonalInfo>> searchAboutUser({required String name,required bool searchForSingleLetter}) =>
      FirestoreUser.searchAboutUser(name: name,searchForSingleLetter: searchForSingleLetter);

  @override
  Future<void> deleteMessage(
      {required Message messageInfo, Message? replacedMessage}) async {
    try {
      await FireStoreMessage.deleteMessage(
          userId: messageInfo.senderId,
          chatId: messageInfo.receiverId,
          messageId: messageInfo.messageUid);
      if (replacedMessage != null) {
        await FireStoreMessage.updateLastMessage(
            userId: messageInfo.receiverId,
            chatId: messageInfo.senderId,
            message: replacedMessage);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<SenderInfo>> getChatUserInfo({required String userId}) async {
    try {
      List<SenderInfo> allUsersIds =
          await FirestoreUser.getChatUserInfo(userId: userId);
      List<SenderInfo> allUsersInfo =
          await FirestoreUser.extractUsersIds(usersInfo: allUsersIds);
      return allUsersInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UserPersonalInfo>> getAllUnFollowersUsers(
      UserPersonalInfo myPersonalInfo) {
    try {
      return FirestoreUser.getAllUnFollowersUsers(myPersonalInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<UserPersonalInfo> getMyPersonalInfo() =>
      FirestoreUser.getMyPersonalInfoInReelTime();
}

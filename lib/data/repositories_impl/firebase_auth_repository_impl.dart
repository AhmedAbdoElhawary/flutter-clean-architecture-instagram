import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/datasourses/remote/notification/firebase_notification.dart';
import 'package:instagram/domain/entities/registered_user.dart';
import 'package:instagram/domain/entities/unregistered_user.dart';
import 'package:instagram/domain/repositories/auth_repository.dart';
import '../datasourses/remote/firebase_auth.dart';

class FirebaseAuthRepositoryImpl implements FirebaseAuthRepository {
  @override
  Future<User> logIn(RegisteredUser userInfo) async {
    try {
      return await FirebaseAuthentication.logIn(
          email: userInfo.email, password: userInfo.password);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> signOut(
      {required String userId, required String? deviceToken}) async {
    try {
      await FirebaseAuthentication.signOut();
      await FirestoreNotification.deleteDeviceToken(
          userId: userId, deviceToken: deviceToken);
      return;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<User> signUp(UnRegisteredUser newUserInfo) async {
    try {
      if (newUserInfo.password != newUserInfo.confirmPassword) {
        throw StringsManager.passwordWrong.tr();
      }
      User userId = await FirebaseAuthentication.signUp(
          email: newUserInfo.email, password: newUserInfo.password);
      return userId;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

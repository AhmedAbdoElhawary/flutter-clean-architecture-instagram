import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/data/data_sources/remote/notification/firebase_notification.dart';
import 'package:instagram/domain/entities/registered_user.dart';
import 'package:instagram/domain/repositories/auth_repository.dart';
import '../data_sources/remote/firebase_auth.dart';

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
  Future<void> signOut({required String userId}) async {
    try {
      await FirebaseAuthentication.signOut();
      await FireStoreNotification.deleteDeviceToken(userId: userId);
      return;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<User> signUp(RegisteredUser newUserInfo) async {
    try {
      User userId = await FirebaseAuthentication.signUp(
          email: newUserInfo.email, password: newUserInfo.password);
      return userId;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<bool> isThisEmailToken({required String email}) async {
    try {
      bool isThisEmailToken =
          await FirebaseAuthentication.isThisEmailToken(email: email);
      return isThisEmailToken;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

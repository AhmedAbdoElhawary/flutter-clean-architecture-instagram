import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/resources/strings_manager.dart';
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
  Future<void> signOut() {
    try {
      return FirebaseAuthentication.signOut();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<User> signUp(UnRegisteredUser newUserInfo) {
    try {
      if (newUserInfo.password != newUserInfo.confirmPassword) {
        throw StringsManager.passwordWrong.tr();
      }
      return FirebaseAuthentication.signUp(
          email: newUserInfo.email, password: newUserInfo.password);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

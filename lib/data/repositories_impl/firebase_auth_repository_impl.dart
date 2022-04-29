import 'package:firebase_auth/firebase_auth.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/domain/entities/registered_user.dart';
import 'package:instegram/domain/entities/unregistered_user.dart';
import 'package:instegram/domain/repositories/auth_repository.dart';
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
        throw StringsManager.passwordWrong;
      }
      return FirebaseAuthentication.signUp(
          email: newUserInfo.email, password: newUserInfo.password);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

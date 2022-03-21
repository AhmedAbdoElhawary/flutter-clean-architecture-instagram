import 'package:firebase_auth/firebase_auth.dart';
import 'package:instegram/domain/entities/registered_user.dart';
import '../entities/unregistered_user.dart';

abstract class FirebaseAuthRepository {
  Future<User> signUp(UnRegisteredUser newUserInfo);
  Future<User> logIn(RegisteredUser userInfo);
  Future<void> signOut();
}

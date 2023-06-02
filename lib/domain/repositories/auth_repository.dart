import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/domain/entities/registered_user.dart';

abstract class FirebaseAuthRepository {
  Future<User> signUp(RegisteredUser newUserInfo);
  Future<User> logIn(RegisteredUser userInfo);
  Future<void> signOut({required String userId});
  Future<bool> isThisEmailToken({required String email});
}

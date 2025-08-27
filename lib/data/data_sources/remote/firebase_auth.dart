import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  get user => _firebaseAuth.currentUser;

  static Future<User> signUp({required String email, required String password}) async {
    UserCredential result =
        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final user = result.user!;
    return user;
  }

  static Future<User> logIn({required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final user = result.user!;
    return user;
  }

  static Future<bool> isThisEmailToken({required String email}) async {
    try {
      ///TODO: handle this with other way
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: "dummy_password",
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false; // email not registered
      }
    }
    return true;
  }

  static Future signOut() async => await _firebaseAuth.signOut();
}

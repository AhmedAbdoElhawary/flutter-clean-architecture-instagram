import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/use_case/use_case.dart';
import '../../entities/unregistered_user.dart';
import '../../repositories/auth_repository.dart';

class SignUpAuthUseCase implements UseCase<User, UnRegisteredUser> {
  final FirebaseAuthRepository _firebaseAuthRepository;

  SignUpAuthUseCase(this._firebaseAuthRepository);

  @override
  Future<User> call({required UnRegisteredUser params}) {
    return _firebaseAuthRepository.signUp(params);
  }
}

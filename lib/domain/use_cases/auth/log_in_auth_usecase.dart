import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/use_case/use_case.dart';
import '../../entities/registered_user.dart';
import '../../repositories/auth_repository.dart';

class LogInAuthUseCase implements UseCase<User, RegisteredUser> {
  final FirebaseAuthRepository _firebaseAuthRepository;

  LogInAuthUseCase(this._firebaseAuthRepository);

  @override
  Future<User> call({required RegisteredUser params}) {
    return _firebaseAuthRepository.logIn(params);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/registered_user.dart';
import '../../repositories/firebase_auth_repository.dart';

class LogInAuthUseCase implements UseCase<User, RegisteredUser> {
  final FirebaseAuthRepository _firebaseAuthRepository;

  LogInAuthUseCase(this._firebaseAuthRepository);

  @override
Future<User> call({required RegisteredUser params}) {
  return _firebaseAuthRepository.logIn(params);
}
}

import '../../../core/usecase/usecase.dart';
import '../../repositories/firebase_auth_repository.dart';

class SignOutAuthUseCase implements UseCase<void, void> {
  final FirebaseAuthRepository _firebaseAuthRepository;

  SignOutAuthUseCase(this._firebaseAuthRepository);

  @override
  Future<void> call({ required void params}) {
    return _firebaseAuthRepository.signOut();
  }
}

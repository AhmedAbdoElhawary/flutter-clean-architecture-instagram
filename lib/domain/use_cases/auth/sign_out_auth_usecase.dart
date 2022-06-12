import 'package:instagram/core/use_case/use_case.dart';
import '../../repositories/auth_repository.dart';

class SignOutAuthUseCase implements UseCase<void, void> {
  final FirebaseAuthRepository _firebaseAuthRepository;

  SignOutAuthUseCase(this._firebaseAuthRepository);

  @override
  Future<void> call({required void params}) {
    return _firebaseAuthRepository.signOut();
  }
}

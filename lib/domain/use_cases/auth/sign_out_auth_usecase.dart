import 'package:instagram/core/use_case/use_case.dart';
import '../../repositories/auth_repository.dart';

class SignOutAuthUseCase implements UseCase<void, String> {
  final FirebaseAuthRepository _firebaseAuthRepository;

  SignOutAuthUseCase(this._firebaseAuthRepository);

  @override
  Future<void> call({required String params}) {
    return _firebaseAuthRepository.signOut(userId: params);
  }
}

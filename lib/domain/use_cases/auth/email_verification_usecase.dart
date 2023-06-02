import 'package:instagram/core/use_case/use_case.dart';
import '../../repositories/auth_repository.dart';

class EmailVerificationUseCase implements UseCase<bool, String> {
  final FirebaseAuthRepository _firebaseAuthRepository;

  EmailVerificationUseCase(this._firebaseAuthRepository);

  @override
  Future<bool> call({required String params}) {
    return _firebaseAuthRepository.isThisEmailToken(email: params);
  }
}

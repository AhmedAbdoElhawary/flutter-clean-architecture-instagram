import 'package:instagram/core/use_case/use_case.dart';
import '../../repositories/auth_repository.dart';

class SignOutAuthUseCase implements UseCaseTwoParams<void, String,String?> {
  final FirebaseAuthRepository _firebaseAuthRepository;

  SignOutAuthUseCase(this._firebaseAuthRepository);

  @override
  Future<void> call({required String paramsOne, required String? paramsTwo}) {
    return _firebaseAuthRepository.signOut(userId: paramsOne, deviceToken: paramsTwo);
  }
}

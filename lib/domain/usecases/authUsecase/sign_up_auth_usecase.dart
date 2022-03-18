import 'package:firebase_auth/firebase_auth.dart';
import 'package:instegram/core/usecase/usecase.dart';
import '../../entities/unregistered_user.dart';
import '../../repositories/firebase_auth_repository.dart';

class SignUpAuthUseCase implements UseCase<User, UnRegisteredUser>{
  final FirebaseAuthRepository _firebaseAuthRepository;

  SignUpAuthUseCase(this._firebaseAuthRepository);

  @override
  Future<User> call({required UnRegisteredUser params}){
    return _firebaseAuthRepository.signUp(params);
  }
}
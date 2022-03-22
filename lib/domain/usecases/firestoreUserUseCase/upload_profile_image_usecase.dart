import '../../../core/usecase/usecase.dart';
import '../../repositories/user_repository.dart';

class UploadProfileImageUseCase implements UseCase<String, List> {
  final FirestoreUserRepository _addNewUserRepository;

  UploadProfileImageUseCase(this._addNewUserRepository);

  @override
  Future<String> call({required List params}) {
    return _addNewUserRepository.uploadProfileImage(
        photo: params[0], userId: params[1],previousImageUrl: params[2]);
    
  }
}

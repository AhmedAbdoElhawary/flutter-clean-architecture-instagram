import '../../../core/usecase/usecase.dart';
import '../../repositories/firestore_user_repo.dart';

class UploadImageUseCase implements UseCase<String, List> {
  final FirestoreUserRepository _addNewUserRepository;

  UploadImageUseCase(this._addNewUserRepository);

  @override
  Future<String> call({required List params}) {
    return _addNewUserRepository.uploadProfileImage(
        photo: params[0], userId: params[1]);
    
  }
}

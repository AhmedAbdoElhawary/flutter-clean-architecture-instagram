import '../../../core/usecase/usecase.dart';
import '../../../data/models/user_personal_info.dart';
import '../../repositories/firestore_user_repo.dart';

class AddNewUserUseCase implements UseCase<void, UserPersonalInfo> {
  final FirestoreUserRepository _addNewUserRepository;

  AddNewUserUseCase(this._addNewUserRepository);

  @override
  Future<void> call({required UserPersonalInfo params}) {
    return _addNewUserRepository.addNewUser(params);
  }
}

import '../../../core/usecase/usecase.dart';
import '../../../data/models/user_personal_info.dart';
import '../../repositories/user_repository.dart';

class UpdateUserInfoUseCase implements UseCase< UserPersonalInfo,UserPersonalInfo> {
  final FirestoreUserRepository _addNewUserRepository;

  UpdateUserInfoUseCase(this._addNewUserRepository);

  @override
  Future<UserPersonalInfo> call({required UserPersonalInfo params}) {
    return _addNewUserRepository.updateUserInfo(userInfo: params);
  }
}

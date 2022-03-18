import '../../../core/usecase/usecase.dart';
import '../../entities/user_personal_info.dart';
import '../../repositories/firestore_user_repo.dart';

class GetUserInfoUseCase implements UseCase< UserPersonalInfo,String> {
  final FirestoreUserRepository _addNewUserRepository;

  GetUserInfoUseCase(this._addNewUserRepository);

  @override
  Future<UserPersonalInfo> call({required String params}) {
    return _addNewUserRepository.getPersonalInfo(params);
  }
}

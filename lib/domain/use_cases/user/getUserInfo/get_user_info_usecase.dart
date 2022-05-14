import '../../../../core/usecase/usecase.dart';
import '../../../../data/models/user_personal_info.dart';
import '../../../repositories/user_repository.dart';

class GetUserInfoUseCase implements UseCase< UserPersonalInfo,String> {
  final FirestoreUserRepository _addNewUserRepository;

  GetUserInfoUseCase(this._addNewUserRepository);

  @override
  Future<UserPersonalInfo> call({required String params}) {
    return _addNewUserRepository.getPersonalInfo(params);
  }
}

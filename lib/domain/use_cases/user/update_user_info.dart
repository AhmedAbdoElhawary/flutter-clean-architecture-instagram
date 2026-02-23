import 'package:instagram/core/use_case/use_case.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../repositories/user_repository.dart';

class UpdateUserInfoUseCase
    implements UseCase<UserPersonalInfo, UserPersonalInfo> {
  final FirestoreUserRepository _addNewUserRepository;

  UpdateUserInfoUseCase(this._addNewUserRepository);

  @override
  Future<UserPersonalInfo> call({required UserPersonalInfo params}) {
    return _addNewUserRepository.updateUserInfo(userInfo: params);
  }
}

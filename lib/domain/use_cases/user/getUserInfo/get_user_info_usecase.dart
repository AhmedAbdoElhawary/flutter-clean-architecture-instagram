import 'package:instagram/core/use_case/use_case.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../repositories/user_repository.dart';

class GetUserInfoUseCase
    implements UseCaseTwoParams<UserPersonalInfo, String, bool> {
  final FirestoreUserRepository _addNewUserRepository;

  GetUserInfoUseCase(this._addNewUserRepository);

  @override
  Future<UserPersonalInfo> call(
      {required String paramsOne, required bool paramsTwo}) {
    return _addNewUserRepository.getPersonalInfo(
        userId: paramsOne, getDeviceToken: paramsTwo);
  }
}

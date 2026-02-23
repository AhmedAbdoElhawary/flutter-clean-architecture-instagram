import 'package:instagram/core/use_case/use_case.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../repositories/user_repository.dart';

class GetSpecificUsersUseCase
    implements UseCase<List<UserPersonalInfo>, List<dynamic>> {
  final FirestoreUserRepository _fireStoreUserRepository;

  GetSpecificUsersUseCase(this._fireStoreUserRepository);

  @override
  Future<List<UserPersonalInfo>> call({required List<dynamic> params}) {
    return _fireStoreUserRepository.getSpecificUsersInfo(usersIds: params);
  }
}

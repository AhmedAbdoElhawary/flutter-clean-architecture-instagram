import 'package:instagram/core/use_case/use_case.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../repositories/user_repository.dart';

class GetAllUnFollowersUseCase
    implements UseCase<List<UserPersonalInfo>, UserPersonalInfo> {
  final FirestoreUserRepository _getAllUnFollowersUsersUseCase;

  GetAllUnFollowersUseCase(this._getAllUnFollowersUsersUseCase);

  @override
  Future<List<UserPersonalInfo>> call({required UserPersonalInfo params}) {
    return _getAllUnFollowersUsersUseCase.getAllUnFollowersUsers(params);
  }
}

// create interface from UseCase to get all users info
import 'package:instagram/core/use_case/use_case.dart';
import '../../../../data/models/user_personal_info.dart';
import '../../../repositories/user_repository.dart';

class GetAllUsersUseCase implements UseCase<List<UserPersonalInfo>, UserPersonalInfo> {
  final FirestoreUserRepository _getAllUnFollowersUsersUseCase;

  GetAllUsersUseCase(this._getAllUnFollowersUsersUseCase);

  @override
  Future<List<UserPersonalInfo>> call({required UserPersonalInfo params}) {
    return _getAllUnFollowersUsersUseCase.getAllUnFollowersUsers( params);
  }
}

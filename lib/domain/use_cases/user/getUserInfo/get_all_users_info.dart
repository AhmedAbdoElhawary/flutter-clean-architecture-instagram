import 'package:instagram/core/use_case/use_case.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../repositories/user_repository.dart';

class GetAllUsersUseCase
    implements StreamUseCase<List<UserPersonalInfo>, void> {
  final FirestoreUserRepository _getAllUsersUseCase;

  GetAllUsersUseCase(this._getAllUsersUseCase);

  @override
  Stream<List<UserPersonalInfo>> call({required void params}) {
    return _getAllUsersUseCase.getAllUsers();
  }
}

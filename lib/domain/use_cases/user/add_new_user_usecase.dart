import 'package:instagram/core/use_case/use_case.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../repositories/user_repository.dart';

class AddNewUserUseCase implements UseCase<void, UserPersonalInfo> {
  final FirestoreUserRepository _addNewUserRepository;

  AddNewUserUseCase(this._addNewUserRepository);

  @override
  Future<void> call({required UserPersonalInfo params}) {
    return _addNewUserRepository.addNewUser(params);
  }
}

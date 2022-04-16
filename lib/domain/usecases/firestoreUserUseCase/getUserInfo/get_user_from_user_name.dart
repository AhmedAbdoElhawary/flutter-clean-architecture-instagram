import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/repositories/user_repository.dart';
import '../../../../core/usecase/usecase.dart';

class GetUserFromUserNameUseCase implements UseCase<UserPersonalInfo?, String> {
  final FirestoreUserRepository _getUserFromUserNameRepository;

  GetUserFromUserNameUseCase(this._getUserFromUserNameRepository);

  @override
  Future<UserPersonalInfo?> call({required String params}) {
    return _getUserFromUserNameRepository.getUserFromUserName(userName:params);
  }
}

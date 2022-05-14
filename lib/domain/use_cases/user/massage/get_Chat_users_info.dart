import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class GetChatUsersInfoAddMassageUseCase
    implements UseCase<List<UserPersonalInfo>, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  GetChatUsersInfoAddMassageUseCase(this._addPostToUserRepository);

  @override
  Future<List<UserPersonalInfo>> call({required String params}) {
    return _addPostToUserRepository.getChatUserInfo(userId: params);
  }
}

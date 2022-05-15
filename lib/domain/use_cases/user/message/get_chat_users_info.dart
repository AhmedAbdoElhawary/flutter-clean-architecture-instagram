import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/sender_info.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class GetChatUsersInfoAddMessageUseCase
    implements UseCase<List<SenderInfo>, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  GetChatUsersInfoAddMessageUseCase(this._addPostToUserRepository);

  @override
  Future<List<SenderInfo>> call({required String params}) {
    return _addPostToUserRepository.getChatUserInfo(userId: params);
  }
}

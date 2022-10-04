import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/domain/repositories/group_message.dart';

class DeleteMessageForGroupChatUseCase
    implements UseCaseThreeParams<void, String, Message, Message?> {
  final FireStoreGroupMessageRepository _addPostToUserRepository;

  DeleteMessageForGroupChatUseCase(this._addPostToUserRepository);

  @override
  Future<void> call({
    required String paramsOne,
    required Message paramsTwo,
    required Message? paramsThree,
  }) {
    return _addPostToUserRepository.deleteMessage(
        chatOfGroupUid: paramsOne,
        messageInfo: paramsTwo,
        replacedMessage: paramsThree);
  }
}

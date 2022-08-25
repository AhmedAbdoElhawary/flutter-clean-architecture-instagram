import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/domain/repositories/group_message.dart';

class CreateGroupChatUseCase implements UseCase<Message, Message> {
  final FirestoreGroupMessageRepository _createGroupChatRepository;

  CreateGroupChatUseCase(this._createGroupChatRepository);

  @override
  Future<Message> call({required Message params}) {
    return _createGroupChatRepository.createChatForGroups(params);
  }
}

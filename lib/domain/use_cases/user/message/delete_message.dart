import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class DeleteMessageUseCase
    implements UseCaseTwoParams<void, Message, Message?> {
  final FirestoreUserRepository _addPostToUserRepository;

  DeleteMessageUseCase(this._addPostToUserRepository);

  @override
  Future<void> call({required Message paramsOne, required Message? paramsTwo}) {
    return _addPostToUserRepository.deleteMessage(
        messageInfo: paramsOne, replacedMessage: paramsTwo);
  }
}

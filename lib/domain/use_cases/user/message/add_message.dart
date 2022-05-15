import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class AddMessageUseCase
    implements UseCaseThreeParams<Message, Message, String, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  AddMessageUseCase(this._addPostToUserRepository);

  @override
  Future<Message> call(
      {required Message paramsOne,
      required String paramsTwo,
      required String paramsThree}) {
    return _addPostToUserRepository.sendmessage(
        messageInfo: paramsOne,
        pathOfPhoto: paramsTwo,
        pathOfRecorded: paramsThree);
  }
}

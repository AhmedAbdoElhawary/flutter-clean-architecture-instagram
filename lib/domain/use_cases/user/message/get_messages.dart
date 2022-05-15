import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class GetMessagesUseCase implements StreamUseCase<List<Message>, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  GetMessagesUseCase(this._addPostToUserRepository);

  @override
  Stream<List<Message>> call({required String params}) {
    return _addPostToUserRepository.getmessages(receiverId: params);
  }
}

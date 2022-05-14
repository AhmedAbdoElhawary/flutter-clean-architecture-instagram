import 'package:instagram/core/usecase/usecase.dart';
import 'package:instagram/domain/repositories/post/comment/reply_repository.dart';

class RemoveLikeOnThisReplyUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreReplyRepository _removeLikeOnThisReplyRepository;

  RemoveLikeOnThisReplyUseCase(this._removeLikeOnThisReplyRepository);

  @override
  Future<void> call(
      {required String paramsOne, required String paramsTwo}) async {
    return await _removeLikeOnThisReplyRepository.removeLikeOnThisReply(
        replyId: paramsOne, myPersonalId: paramsTwo);
  }
}

import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/domain/repositories/post/comment/reply_repository.dart';

class PutLikeOnThisReplyUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreReplyRepository _putLikeOnThisReplyRepository;

  PutLikeOnThisReplyUseCase(this._putLikeOnThisReplyRepository);

  @override
  Future<void> call(
      {required String paramsOne, required String paramsTwo}) async {
    return await _putLikeOnThisReplyRepository.putLikeOnThisReply(
        replyId: paramsOne, myPersonalId: paramsTwo);
  }
}

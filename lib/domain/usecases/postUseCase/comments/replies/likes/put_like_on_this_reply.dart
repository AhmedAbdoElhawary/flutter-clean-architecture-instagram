import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/domain/repositories/post/comment/reply_repository.dart';

class PutLikeOnThisReplyUseCase
    implements UseCaseFourParams<void, String, String, String, String> {
  final FirestoreReplyRepository _putLikeOnThisReplyRepository;

  PutLikeOnThisReplyUseCase(this._putLikeOnThisReplyRepository);

  @override
  Future<void> call(
      {required String paramsOne,
      required String paramsTwo,
      required String paramsThree,
      required String paramsFour}) async {
    return await _putLikeOnThisReplyRepository.putLikeOnThisReply(
        postId: paramsOne,
        commentId: paramsTwo,
        replyId: paramsThree,
        myPersonalId: paramsFour);
  }
}

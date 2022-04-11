import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/domain/repositories/post/comment/reply_repository.dart';

class RemoveLikeOnThisReplyUseCase
    implements UseCaseFourParams<void, String, String, String, String> {
  final FirestoreReplyRepository _removeLikeOnThisReplyRepository;

  RemoveLikeOnThisReplyUseCase(this._removeLikeOnThisReplyRepository);

  @override
  Future<void> call(
      {required String paramsOne,
      required String paramsTwo,
      required String paramsThree,
      required String paramsFour}) async {
    return await _removeLikeOnThisReplyRepository.removeLikeOnThisReply(
        postId: paramsOne,
        commentId: paramsTwo,
        replyId: paramsThree,
        myPersonalId: paramsFour);
  }
}

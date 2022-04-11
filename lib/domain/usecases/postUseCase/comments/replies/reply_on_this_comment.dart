import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/reply_comment.dart';
import 'package:instegram/domain/repositories/post/comment/reply_repository.dart';

class ReplyOnThisCommentUseCase
    implements UseCaseThreeParams<Comment, String, String, Comment> {
  final FirestoreReplyRepository _replayOnThisCommentRepository;

  ReplyOnThisCommentUseCase(this._replayOnThisCommentRepository);

  @override
  Future<Comment> call(
      {required String paramsOne,
      required String paramsTwo,
      required Comment paramsThree}) async {
    return await _replayOnThisCommentRepository.replyOnThisComment(
        postId: paramsOne, commentId: paramsTwo, replyInfo: paramsThree);
  }
}

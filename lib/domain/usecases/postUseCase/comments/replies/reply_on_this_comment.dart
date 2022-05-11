import 'package:instagram/core/usecase/usecase.dart';
import 'package:instagram/data/models/comment.dart';
import 'package:instagram/domain/repositories/post/comment/reply_repository.dart';

class ReplyOnThisCommentUseCase implements UseCase<Comment, Comment> {
  final FirestoreReplyRepository _replayOnThisCommentRepository;

  ReplyOnThisCommentUseCase(this._replayOnThisCommentRepository);

  @override
  Future<Comment> call({required Comment params}) async {
    return await _replayOnThisCommentRepository.replyOnThisComment(
        replyInfo: params);
  }
}

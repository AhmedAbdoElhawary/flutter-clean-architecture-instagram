import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/domain/repositories/post/comment/reply_repository.dart';

class ReplyOnThisCommentUseCase implements UseCase<Comment, Comment> {
  final FirestoreReplyRepository _replayOnThisCommentRepository;

  ReplyOnThisCommentUseCase(this._replayOnThisCommentRepository);

  @override
  Future<Comment> call({required Comment params}) async {
    return await _replayOnThisCommentRepository.replyOnThisComment(
        replyInfo: params);
  }
}

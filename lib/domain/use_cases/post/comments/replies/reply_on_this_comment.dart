import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';
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

import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/reply_comment.dart';
import 'package:instegram/domain/repositories/post/comment/reply_repository.dart';

class GetRepliesOfThisCommentUseCase
    implements UseCaseTwoParams<List<Comment>, String, String> {
  final FirestoreReplyRepository _getRepliesOfThisCommentRepository;

  GetRepliesOfThisCommentUseCase(this._getRepliesOfThisCommentRepository);

  @override
  Future<List<Comment>> call({
    required String paramsOne,
    required String paramsTwo,
  }) async {
    return await _getRepliesOfThisCommentRepository.getRepliesOfThisComment(
      postId: paramsOne,
      commentId: paramsTwo,
    );
  }
}

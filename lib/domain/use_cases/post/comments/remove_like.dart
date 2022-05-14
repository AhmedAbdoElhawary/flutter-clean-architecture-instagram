import 'package:instagram/core/usecase/usecase.dart';
import 'package:instagram/domain/repositories/post/comment/comment_repository.dart';

class RemoveLikeOnThisCommentUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreCommentRepository _removeLikeRepository;

  RemoveLikeOnThisCommentUseCase(this._removeLikeRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _removeLikeRepository.removeLikeOnThisComment(
        commentId: paramsOne, myPersonalId: paramsTwo);
  }
}

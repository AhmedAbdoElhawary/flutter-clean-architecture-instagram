import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/domain/repositories/post_repository.dart';

class PutLikeOnThisCommentUseCase
    implements UseCaseThreeParams<void, String, String, String> {
  final FirestorePostRepository _putLikeRepository;

  PutLikeOnThisCommentUseCase(this._putLikeRepository);

  @override
  Future<void> call(
      {required String paramsOne,
      required String paramsTwo,
      required String paramsThree}) {
    return _putLikeRepository.putLikeOnThisComment(
        postId: paramsOne, commentId: paramsTwo, myPersonalId: paramsThree);
  }
}

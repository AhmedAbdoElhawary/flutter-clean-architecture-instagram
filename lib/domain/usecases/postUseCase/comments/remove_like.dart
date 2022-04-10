import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/domain/repositories/post_repository.dart';

class RemoveLikeOnThisCommentUseCase
    implements UseCaseThreeParams<void, String, String, String> {
  final FirestorePostRepository _removeLikeRepository;

  RemoveLikeOnThisCommentUseCase(this._removeLikeRepository);

  @override
  Future<void> call(
      {required String paramsOne,
      required String paramsTwo,
      required String paramsThree}) {
    return _removeLikeRepository.removeLikeOnThisComment(
        postId: paramsOne, commentId: paramsTwo, myPersonalId: paramsThree);
  }
}

import 'package:instagram/domain/repositories/post/post_repository.dart';
import 'package:instagram/core/use_case/use_case.dart';

class RemoveTheLikeOnThisPostUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStorePostRepository _removeTheLikeOnThisPostRepository;

  RemoveTheLikeOnThisPostUseCase(this._removeTheLikeOnThisPostRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _removeTheLikeOnThisPostRepository.removeTheLikeOnThisPost(
        postId: paramsOne, userId: paramsTwo);
  }
}

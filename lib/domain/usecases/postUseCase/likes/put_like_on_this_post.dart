import 'package:instagram/domain/repositories/post/post_repository.dart';
import '../../../../core/usecase/usecase.dart';

class PutLikeOnThisPostUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestorePostRepository _putLikeOnThisPostRepository;

  PutLikeOnThisPostUseCase(this._putLikeOnThisPostRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _putLikeOnThisPostRepository.putLikeOnThisPost(
        postId: paramsOne, userId: paramsTwo);
  }
}

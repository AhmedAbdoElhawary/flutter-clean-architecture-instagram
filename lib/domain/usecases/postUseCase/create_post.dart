import '../../../core/usecase/usecase.dart';
import '../../repositories/post_repository.dart';

class CreatePostUseCase implements UseCase<String, List> {
  final FirestorePostRepository _createPostRepository;

  CreatePostUseCase(this._createPostRepository);

  @override
  Future<String> call({required List params}) {
    return _createPostRepository.createPost(
        postInfo: params[0], photo: params[2]);
  }
}

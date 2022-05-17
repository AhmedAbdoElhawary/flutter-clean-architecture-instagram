import 'package:instagram/data/models/post.dart';
import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/domain/repositories/post/post_repository.dart';

class UpdatePostUseCase implements UseCase<Post, Post> {
  final FirestorePostRepository _updatePostRepository;

  UpdatePostUseCase(this._updatePostRepository);

  @override
  Future<Post> call({required Post params}) {
    return _updatePostRepository.updatePost(postInfo: params);
  }
}

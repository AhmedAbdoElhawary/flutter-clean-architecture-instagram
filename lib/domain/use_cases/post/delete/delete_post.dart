import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/domain/repositories/post/post_repository.dart';

class DeletePostUseCase implements UseCase<void, Post> {
  final FireStorePostRepository _deletePostRepository;

  DeletePostUseCase(this._deletePostRepository);

  @override
  Future<void> call({required Post params}) {
    return _deletePostRepository.deletePost(postInfo: params);
  }
}

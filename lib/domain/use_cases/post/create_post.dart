import 'dart:typed_data';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/core/use_case/use_case.dart';
import '../../repositories/post/post_repository.dart';

class CreatePostUseCase
    implements UseCaseThreeParams<Post, Post, List<Uint8List>, Uint8List?> {
  final FirestorePostRepository _createPostRepository;

  CreatePostUseCase(this._createPostRepository);

  @override
  Future<Post> call(
      {required Post paramsOne,
      required List<Uint8List> paramsTwo,
      required Uint8List? paramsThree}) {
    return _createPostRepository.createPost(
        postInfo: paramsOne, files: paramsTwo, coverOfVideo: paramsThree);
  }
}

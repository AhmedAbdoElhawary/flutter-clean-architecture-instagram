import 'dart:typed_data';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/core/use_case/use_case.dart';
import '../../repositories/post/post_repository.dart';

class CreatePostUseCase implements UseCaseTwoParams<String, Post, List<Uint8List>> {
  final FirestorePostRepository _createPostRepository;

  CreatePostUseCase(this._createPostRepository);

  @override
  Future<String> call(
      {required Post paramsOne, required List<Uint8List> paramsTwo}) {
    return _createPostRepository.createPost(
        postInfo: paramsOne, files: paramsTwo);
  }
}

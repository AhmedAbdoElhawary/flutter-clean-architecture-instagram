import 'dart:io';
import 'package:instegram/data/models/post.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/post/post_repository.dart';

class CreatePostUseCase implements UseCaseTwoParams<String, Post , File > {
  final FirestorePostRepository _createPostRepository;

  CreatePostUseCase(this._createPostRepository);

  @override
  Future<String> call({required Post paramsOne,required File paramsTwo}) {
    return _createPostRepository.createPost(
        postInfo: paramsOne, photo: paramsTwo);
  }
}

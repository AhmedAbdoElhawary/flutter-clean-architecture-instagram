import 'dart:typed_data';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/core/use_case/use_case.dart';
import '../../repositories/post/post_repository.dart';

class CreatePostUseCase
    implements UseCaseThreeParams<Post, Post, List<SelectedByte>, Uint8List?> {
  final FireStorePostRepository _createPostRepository;

  CreatePostUseCase(this._createPostRepository);

  @override
  Future<Post> call(
      {required Post paramsOne,
      required List<SelectedByte> paramsTwo,
      required Uint8List? paramsThree}) {
    return _createPostRepository.createPost(
        postInfo: paramsOne, files: paramsTwo, coverOfVideo: paramsThree);
  }
}

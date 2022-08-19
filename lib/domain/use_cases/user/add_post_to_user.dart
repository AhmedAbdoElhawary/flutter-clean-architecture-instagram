import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/post.dart';
import '../../../data/models/user_personal_info.dart';
import '../../repositories/user_repository.dart';

class AddPostToUserUseCase
    implements UseCaseTwoParams<UserPersonalInfo, String, Post> {
  final FirestoreUserRepository _addPostToUserRepository;

  AddPostToUserUseCase(this._addPostToUserRepository);

  @override
  Future<UserPersonalInfo> call(
      {required String paramsOne, required Post paramsTwo}) {
    return _addPostToUserRepository.updateUserPostsInfo(
        userId: paramsOne, postInfo: paramsTwo);
  }
}

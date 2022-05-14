import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class AddStoryToUserUseCase
    implements UseCaseTwoParams<UserPersonalInfo, String, String> {
  final FirestoreUserRepository _addStoryToUserRepository;

  AddStoryToUserUseCase(this._addStoryToUserRepository);

  @override
  Future<UserPersonalInfo> call(
      {required String paramsOne, required String paramsTwo}) {
    return _addStoryToUserRepository.updateUserStoriesInfo(
        userId: paramsOne, storyId: paramsTwo);
  }
}

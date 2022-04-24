import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/repositories/user_repository.dart';

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

import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/repositories/story_repository.dart';

class GetSpecificStoriesInfoUseCase
    implements UseCase<UserPersonalInfo, UserPersonalInfo> {
  final FirestoreStoryRepository _getStoryRepository;

  GetSpecificStoriesInfoUseCase(this._getStoryRepository);

  @override
  Future<UserPersonalInfo> call({required UserPersonalInfo params}) {
    return _getStoryRepository.getSpecificStoriesInfo(userInfo: params);
  }
}

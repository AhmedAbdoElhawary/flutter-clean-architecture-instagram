import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/domain/repositories/story_repository.dart';

class DeleteStoryUseCase implements UseCase<void, String> {
  final FirestoreStoryRepository _getStoryRepository;

  DeleteStoryUseCase(this._getStoryRepository);

  @override
  Future<void> call({required String params}) {
    return _getStoryRepository.deleteThisStory(storyId: params);
  }
}

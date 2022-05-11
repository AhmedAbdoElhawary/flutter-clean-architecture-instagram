import 'dart:io';
import 'package:instagram/core/usecase/usecase.dart';
import 'package:instagram/data/models/story.dart';
import 'package:instagram/domain/repositories/story_repository.dart';

class CreateStoryUseCase implements UseCaseTwoParams<String, Story, File> {
  final FirestoreStoryRepository _createStoryRepository;

  CreateStoryUseCase(this._createStoryRepository);

  @override
  Future<String> call({required Story paramsOne, required File paramsTwo}) {
    return _createStoryRepository.createStory(
        storyInfo: paramsOne, photo: paramsTwo);
  }
}

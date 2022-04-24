import 'dart:io';
import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/story.dart';
import 'package:instegram/domain/repositories/story_repository.dart';

class CreateStoryUseCase implements UseCaseTwoParams<String, Story , File > {
  final FirestoreStoryRepository _createStoryRepository;

  CreateStoryUseCase(this._createStoryRepository);

  @override
  Future<String> call({required Story paramsOne,required File paramsTwo}) {
    return _createStoryRepository.createStory(
        storyInfo: paramsOne, photo: paramsTwo);
  }
}

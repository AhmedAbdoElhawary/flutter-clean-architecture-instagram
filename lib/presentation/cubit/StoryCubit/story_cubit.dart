import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/story.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/usecases/storyUseCase/create_story.dart';
import 'package:instegram/domain/usecases/storyUseCase/get_stories_info.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final CreateStoryUseCase _createStoryUseCase;
  final GetStoriesInfoUseCase _getStoriesInfoUseCase;
  String storyId = '';

  StoryCubit(this._createStoryUseCase, this._getStoriesInfoUseCase)
      : super(StoryInitial());

  static StoryCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> createStory(Story storyInfo, File photo) async {
    emit(CubitStoryLoading());
    await _createStoryUseCase
        .call(paramsOne: storyInfo, paramsTwo: photo)
        .then((storyId) {
      this.storyId = storyId;
      emit(CubitStoryLoaded(storyId));
      return storyId;
    }).catchError((e) {
      emit(CubitStoryFailed(e));
    });
  }

  Future<void> getStoriesInfo(
      {required List<dynamic> usersIds,
      required UserPersonalInfo myPersonalInfo}) async {
    emit(CubitStoryLoading());
    await _getStoriesInfoUseCase
        .call(paramsOne: usersIds, paramsTwo: myPersonalInfo)
        .then((updatedUsersInfo) {
      emit(CubitStoriesInfoLoaded(updatedUsersInfo));
    }).catchError((e) {
      emit(CubitStoryFailed(e));
    });
  }
}

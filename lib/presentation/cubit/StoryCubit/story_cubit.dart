import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/story.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/usecases/storyUseCase/create_story.dart';
import 'package:instegram/domain/usecases/storyUseCase/delete_story.dart';
import 'package:instegram/domain/usecases/storyUseCase/get_specific_stories.dart';
import 'package:instegram/domain/usecases/storyUseCase/get_stories_info.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final CreateStoryUseCase _createStoryUseCase;
  final GetStoriesInfoUseCase _getStoriesInfoUseCase;
  final GetSpecificStoriesInfoUseCase _getSpecificStoriesInfoUseCase;
  final DeleteStoryUseCase _deleteStoryUseCase;
  String storyId = '';

  StoryCubit(this._createStoryUseCase, this._getStoriesInfoUseCase,
      this._deleteStoryUseCase, this._getSpecificStoriesInfoUseCase)
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
    if (!usersIds.contains(myPersonalInfo.userId)) {
      usersIds = [myPersonalInfo.userId] + usersIds;
    }
    emit(CubitStoryLoading());
    await _getStoriesInfoUseCase
        .call(params: usersIds)
        .then((updatedUsersInfo) {
      emit(CubitStoriesInfoLoaded(updatedUsersInfo));
    }).catchError((e) {
      emit(CubitStoryFailed(e));
    });
  }

  Future<void> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo}) async {
    emit(CubitStoryLoading());
    await _getSpecificStoriesInfoUseCase
        .call(params: userInfo)
        .then((updatedUserInfo) {
      emit(SpecificStoriesInfoLoaded(updatedUserInfo));
    }).catchError((e) {
      emit(CubitStoryFailed(e));
    });
  }

  Future<void> deleteStory({required String storyId}) async {
    emit(CubitDeletingStoryLoading());
    await _deleteStoryUseCase.call(params: storyId).then((_) {
      emit(CubitDeletingStoryLoaded());
    }).catchError((e) {
      emit(CubitStoryFailed(e));
    });
  }
}

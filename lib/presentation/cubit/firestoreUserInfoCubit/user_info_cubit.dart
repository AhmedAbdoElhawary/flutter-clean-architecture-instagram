import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/usecases/firestoreUserUseCase/add_post_to_user.dart';
import 'package:instagram/domain/usecases/firestoreUserUseCase/add_story_to_user.dart';
import 'package:instagram/domain/usecases/firestoreUserUseCase/getUserInfo/get_user_from_user_name.dart';
import 'package:instagram/domain/usecases/firestoreUserUseCase/getUserInfo/get_user_info_usecase.dart';
import 'package:instagram/domain/usecases/firestoreUserUseCase/update_user_info.dart';
import 'package:instagram/domain/usecases/firestoreUserUseCase/upload_profile_image_usecase.dart';
part 'user_info_state.dart';

class FirestoreUserInfoCubit extends Cubit<FirestoreGetUserInfoState> {
  final GetUserInfoUseCase _getUserInfoUseCase;
  final UpdateUserInfoUseCase _updateUserInfoUseCase;
  final UploadProfileImageUseCase _uploadImageUseCase;
  final AddPostToUserUseCase _addPostToUserUseCase;
  final AddStoryToUserUseCase _addStoryToUserUseCase;
  final GetUserFromUserNameUseCase _getUserFromUserNameUseCase;
  UserPersonalInfo? myPersonalInfo;

  UserPersonalInfo? userInfo;

  FirestoreUserInfoCubit(
      this._getUserInfoUseCase,
      this._updateUserInfoUseCase,
      this._addPostToUserUseCase,
      this._getUserFromUserNameUseCase,
      this._addStoryToUserUseCase,
      this._uploadImageUseCase)
      : super(CubitInitial());

  static FirestoreUserInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> getUserInfo(String userId,
      {bool isThatMyPersonalId = true}) async {
    emit(CubitUserLoading());
    await _getUserInfoUseCase.call(params: userId).then((userInfo) {
      if (isThatMyPersonalId) {
        myPersonalInfo = userInfo;
        emit(CubitMyPersonalInfoLoaded(userInfo));
      } else {
        this.userInfo = userInfo;
        emit(CubitUserLoaded(userInfo));
      }
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  Future<void> getUserFromUserName(String userName) async {
    emit(CubitUserLoading());
    await _getUserFromUserNameUseCase.call(params: userName).then((userInfo) {
      if (userInfo != null) {
        if (myPersonalInfo!.userName == userName) {
          myPersonalInfo = userInfo;
          emit(CubitMyPersonalInfoLoaded(userInfo));
        } else {
          this.userInfo = userInfo;
          emit(CubitUserLoaded(userInfo));
        }
      } else {
        emit(CubitGetUserInfoFailed(''));
      }
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  Future<void> updateUserInfo(UserPersonalInfo updatedUserInfo) async {
    emit(CubitUserLoading());
    await _updateUserInfoUseCase.call(params: updatedUserInfo).then((userInfo) {
      myPersonalInfo = userInfo;
      emit(CubitMyPersonalInfoLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  Future<void> updateUserPostsInfo(
      {required String userId, required String postId}) async {
    emit(CubitUserLoading());
    await _addPostToUserUseCase
        .call(paramsOne: userId, paramsTwo: postId)
        .then((userInfo) {
      myPersonalInfo = userInfo;
      emit(CubitMyPersonalInfoLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  Future<void> updateStoriesPostsInfo(
      {required String userId, required String storyId}) async {
    emit(CubitUserLoading());
    await _addStoryToUserUseCase
        .call(paramsOne: userId, paramsTwo: storyId)
        .then((userInfo) {
      myPersonalInfo = userInfo;
      emit(CubitMyPersonalInfoLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  Future<void> uploadProfileImage(
      {required File photo,
      required String userId,
      required String previousImageUrl}) async {
    emit(CubitUserLoading());
    await _uploadImageUseCase
        .call(
            paramsOne: photo, paramsTwo: userId, paramsThree: previousImageUrl)
        .then((imageUrl) {
      myPersonalInfo!.profileImageUrl = imageUrl;
      emit(CubitMyPersonalInfoLoaded(myPersonalInfo!));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }
}

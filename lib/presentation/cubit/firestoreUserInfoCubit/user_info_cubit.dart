import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/use_cases/user/add_post_to_user.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_all_un_followers_info.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_user_from_user_name.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_user_info_usecase.dart';
import 'package:instagram/domain/use_cases/user/update_user_info.dart';
import 'package:instagram/domain/use_cases/user/upload_profile_image_usecase.dart';
part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetUserInfoUseCase _getUserInfoUseCase;
  final GetAllUnFollowersUseCase _getAllUnFollowersUsersUseCase;
  final UpdateUserInfoUseCase _updateUserInfoUseCase;
  final UploadProfileImageUseCase _uploadImageUseCase;
  final AddPostToUserUseCase _addPostToUserUseCase;
  final GetUserFromUserNameUseCase _getUserFromUserNameUseCase;
  late UserPersonalInfo myPersonalInfo;

  UserInfoCubit(
      this._getUserInfoUseCase,
      this._updateUserInfoUseCase,
      this._addPostToUserUseCase,
      this._getAllUnFollowersUsersUseCase,
      this._getUserFromUserNameUseCase,
      this._uploadImageUseCase)
      : super(CubitInitial());

  static UserInfoCubit get(BuildContext context) => BlocProvider.of(context);

  static UserPersonalInfo getMyPersonalInfo(BuildContext context) =>
      BlocProvider.of<UserInfoCubit>(context).myPersonalInfo;

  Future<void> getUserInfo(
    String userId, {
    bool isThatMyPersonalId = true,
    bool getDeviceToken = false,
  }) async {
    emit(CubitUserLoading());
    await _getUserInfoUseCase
        .call(paramsOne: userId, paramsTwo: getDeviceToken)
        .then((UserPersonalInfo userInfo) {
      if (isThatMyPersonalId) {
        myPersonalInfo = userInfo;
        emit(CubitMyPersonalInfoLoaded(userInfo));
      } else {
        emit(CubitUserLoaded(userInfo));
      }
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  Future<void> getAllUnFollowersUsers(UserPersonalInfo myPersonalInfo) async {
    emit(CubitAllUnFollowersUserLoading());
    await _getAllUnFollowersUsersUseCase
        .call(params: myPersonalInfo)
        .then((usersInfo) {
      emit(CubitAllUnFollowersUserLoaded(usersInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  void updateMyFollowings({required dynamic userId, bool addThisUser = true}) {
    if (addThisUser) {
      myPersonalInfo.followedPeople.add(userId);
    } else {
      myPersonalInfo.followedPeople.remove(userId);
    }

    emit(CubitMyPersonalInfoLoaded(myPersonalInfo));
  }

  Future<void> getUserFromUserName(String userName) async {
    emit(CubitUserLoading());
    await _getUserFromUserNameUseCase.call(params: userName).then((userInfo) {
      if (userInfo != null) {
        if (myPersonalInfo.userName == userName) {
          myPersonalInfo = userInfo;
          emit(CubitMyPersonalInfoLoaded(userInfo));
        } else {
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
      {required String userId, required Post postInfo}) async {
    emit(CubitUserLoading());
    await _addPostToUserUseCase
        .call(paramsOne: userId, paramsTwo: postInfo)
        .then((userInfo) {
      myPersonalInfo = userInfo;
      emit(CubitMyPersonalInfoLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  void updateMyStories({required String storyId}) {
    emit(CubitUserLoading());
    myPersonalInfo.stories.add(storyId);
    emit(CubitMyPersonalInfoLoaded(myPersonalInfo));
  }

  Future<void> uploadProfileImage(
      {required Uint8List photo,
      required String userId,
      required String previousImageUrl}) async {
    emit(CubitUserLoading());
    await _uploadImageUseCase
        .call(
            paramsOne: photo, paramsTwo: userId, paramsThree: previousImageUrl)
        .then((imageUrl) {
      myPersonalInfo.profileImageUrl = imageUrl;
      emit(CubitMyPersonalInfoLoaded(myPersonalInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }
}

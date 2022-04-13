import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/usecases/firestoreUserUseCase/add_post_to_user.dart';
import 'package:instegram/domain/usecases/firestoreUserUseCase/getUserInfo/get_user_info_usecase.dart';
import 'package:instegram/domain/usecases/firestoreUserUseCase/update_user_info.dart';
import 'package:instegram/domain/usecases/firestoreUserUseCase/upload_profile_image_usecase.dart';
part 'user_info_state.dart';

class FirestoreUserInfoCubit extends Cubit<FirestoreGetUserInfoState> {
  GetUserInfoUseCase getUserInfoUseCase;
  UpdateUserInfoUseCase updateUserInfoUseCase;
  UploadProfileImageUseCase uploadImageUseCase;
  AddPostToUserUseCase addPostToUserUseCase;
  UserPersonalInfo? myPersonalInfo;

  UserPersonalInfo? userInfo;

  FirestoreUserInfoCubit(this.getUserInfoUseCase, this.updateUserInfoUseCase,this.addPostToUserUseCase,
      this.uploadImageUseCase)
      : super(CubitInitial());

  static FirestoreUserInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  void initializeTheCubit() => emit(CubitInitial());

  Future<void> getUserInfo(
      String userId, bool isThatMyPersonalId) async {
    emit(CubitUserLoading());
    await getUserInfoUseCase.call(params: userId).then((userInfo) {
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

  Future<void> updateUserInfo(
      UserPersonalInfo updatedUserInfo) async {
    emit(CubitUserLoading());
    await updateUserInfoUseCase.call(params: updatedUserInfo).then((userInfo) {
      myPersonalInfo = userInfo;
      emit(CubitMyPersonalInfoLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }
  Future<void> updateUserPostsInfo(
      {required String userId,required String postId}) async {
    emit(CubitUserLoading());
    await addPostToUserUseCase.call(paramsOne: userId,paramsTwo:postId ).then((userInfo) {
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
    emit(CubitImageLoading());
    await uploadImageUseCase
        .call(params: [photo, userId, previousImageUrl]).then((imageUrl) {
      emit(CubitImageLoaded(imageUrl));
      myPersonalInfo!.profileImageUrl = imageUrl;
      emit(CubitMyPersonalInfoLoaded(myPersonalInfo!));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }
}

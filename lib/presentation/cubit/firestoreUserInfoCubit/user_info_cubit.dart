import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/usecases/firestoreUserUseCase/get_specific_users_usecase.dart';
import '../../../domain/usecases/firestoreUserUsecase/get_user_info_usecase.dart';
import '../../../domain/usecases/firestoreUserUsecase/update_user_info.dart';
import '../../../domain/usecases/firestoreUserUseCase/upload_profile_image_usecase.dart';
part 'user_info_state.dart';

class FirestoreUserInfoCubit extends Cubit<FirestoreGetUserInfoState> {
  GetUserInfoUseCase getUserInfoUseCase;
  final GetSpecificUsersUseCase _getSpecificUsersUseCase;
  UpdateUserInfoUseCase updateUserInfoUseCase;
  UploadProfileImageUseCase uploadImageUseCase;

  UserPersonalInfo? personalInfo;
  FirestoreUserInfoCubit(this.getUserInfoUseCase, this.updateUserInfoUseCase,this._getSpecificUsersUseCase,
      this.uploadImageUseCase)
      : super(CubitInitial());

  static FirestoreUserInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<UserPersonalInfo?> getUserInfo(String userId) async {
    emit(CubitUserLoading());

    await getUserInfoUseCase.call(params: userId).then((userInfo) {
      personalInfo = userInfo;
      emit(CubitUserLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
    return personalInfo;
  }
  Future<void> getSpecificUsersInfo(List<dynamic> usersIds) async {
    emit(CubitUserLoading());

    await _getSpecificUsersUseCase.call(params: usersIds).then((userInfo) {
      emit(CubitSpecificUsersLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }

  Future<UserPersonalInfo?> updateUserInfo(
      UserPersonalInfo updatedUserInfo) async {
    emit(CubitUserLoading());
    await updateUserInfoUseCase.call(params: updatedUserInfo).then((userInfo) {
      personalInfo = userInfo;
      emit(CubitUserLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
    return personalInfo;
  }

  Future<void> uploadProfileImage(
      {required File photo,
      required String userId,
      required String previousImageUrl}) async {
    emit(CubitImageLoading());
    await uploadImageUseCase
        .call(params: [photo, userId, previousImageUrl]).then((imageUrl) {
      emit(CubitImageLoaded(imageUrl));
      personalInfo!.profileImageUrl = imageUrl;
      emit(CubitUserLoaded(personalInfo!));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import '../../../domain/usecases/firestoreUserUsecase/get_user_info_usecase.dart';
import '../../../domain/usecases/firestoreUserUsecase/update_user_info.dart';
import '../../../domain/usecases/firestoreUserUseCase/upload_profile_image_usecase.dart';
part 'user_info_state.dart';

class FirestoreUserInfoCubit extends Cubit<FirestoreGetUserInfoState> {
  GetUserInfoUseCase getUserInfoUseCase;
  UpdateUserInfoUseCase updateUserInfoUseCase;
  UploadProfileImageUseCase uploadImageUseCase;

  UserPersonalInfo? personalInfo;
  FirestoreUserInfoCubit(this.getUserInfoUseCase, this.updateUserInfoUseCase,
      this.uploadImageUseCase)
      : super(CubitInitial());

  static FirestoreUserInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  initialState() => emit(CubitInitial());

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
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
  }
}

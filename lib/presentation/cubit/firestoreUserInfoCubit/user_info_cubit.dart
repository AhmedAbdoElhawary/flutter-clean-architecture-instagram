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
  UserPersonalInfo? myPersonalInfo;

  UserPersonalInfo? userInfo;

  FirestoreUserInfoCubit(this.getUserInfoUseCase, this.updateUserInfoUseCase,
      this.uploadImageUseCase)
      : super(CubitInitial());

  static FirestoreUserInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  void initializeTheCubit() => emit(CubitInitial());

  Future<UserPersonalInfo?> getUserInfo(
      String userId, bool isThatMyPersonalId) async {
    emit(CubitUserLoading());
    UserPersonalInfo? myInfo;

    await getUserInfoUseCase.call(params: userId).then((userInfo) {
      if (isThatMyPersonalId) {
        myPersonalInfo = userInfo;
        emit(CubitMyPersonalInfoLoaded(userInfo));
      } else {
        this.userInfo = userInfo;
        emit(CubitUserLoaded(userInfo));
      }
      myInfo = userInfo;
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
    return myInfo;
  }

  Future<UserPersonalInfo?> updateUserInfo(
      UserPersonalInfo updatedUserInfo) async {
    emit(CubitUserLoading());
    await updateUserInfoUseCase.call(params: updatedUserInfo).then((userInfo) {
      myPersonalInfo = userInfo;
      emit(CubitMyPersonalInfoLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
    return myPersonalInfo;
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

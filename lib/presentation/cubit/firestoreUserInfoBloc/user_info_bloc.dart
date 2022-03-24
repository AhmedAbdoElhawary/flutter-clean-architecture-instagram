// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instegram/core/bloc/bloc_with_state.dart';
import 'package:instegram/core/resources/data_state.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import '../../../domain/usecases/firestoreUserUseCase/get_user_info_usecase.dart';
import '../../../domain/usecases/firestoreUserUseCase/update_user_info.dart';
import '../../../domain/usecases/firestoreUserUseCase/upload_profile_image_usecase.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class FirestoreUserInfoBloc
    extends BlocWithState<UserInfoEvent, FirestoreUserInfoState> {
  GetUserInfoUseCase getUserInfoUseCase;
  UpdateUserInfoUseCase updateUserInfoUseCase;
  UploadProfileImageUseCase uploadImageUseCase;
  UserPersonalInfo? personalInfo;

  FirestoreUserInfoBloc(this.getUserInfoUseCase, this.updateUserInfoUseCase,
      this.uploadImageUseCase)
      : super(CubitInitial()) {
    on<GetUserInfoEvent>( getUserInfo);
    on<UpdateUserInfoEvent>(
        (event, emit) => updateUserInfo(event.updatedUserInfo, emit));
    on<UploadProfileImageEvent>(
        (event, emit) => uploadProfileImage(event, emit));
  }

  // @override
  // Stream<FirestoreUserInfoState> mapEventToState(UserInfoEvent event) async* {
  //   if (event is GetUserInfoEvent) yield* getUserInfo(event.userId);
  //   if (event is UpdateUserInfoEvent) {
  //     yield* updateUserInfo(event.updatedUserInfo);
  //   }
  //   if (event is UploadProfileImageEvent) {
  //     yield* uploadProfileImage(
  //         photo: event.photo,
  //         previousImageUrl: event.previousImageUrl,
  //         userId: event.userId);
  //   }
  // }




  Future<void> getUserInfo(  GetUserInfoEvent event, Emitter emit) async {
    emit(CubitUserLoading());
   final dataState= await getUserInfoUseCase.call(params:event.userId);
   if(dataState is DataSuccess){
     emit(CubitUserLoaded(dataState.data!));
   }
   if(dataState is DataFailed){
     emit(CubitGetUserInfoFailed(dataState.error!));
   }

  }
  // Stream<FirestoreUserInfoState> getUserInfo(
  //     String userId, Emitter emit) async* {
  //   yield* runBlocProcess(() async* {
  //     emit(CubitUserLoading());
  //
  //     yield CubitUserLoading();
  //     final dataState = await getUserInfoUseCase.call(params: userId);
  //     if (dataState is DataSuccess) {
  //       personalInfo = dataState.data;
  //       emit(CubitUserLoaded(dataState.data!));
  //
  //       yield CubitUserLoaded(dataState.data!);
  //     }
  //     if (dataState is DataFailed) {
  //       emit(CubitGetUserInfoFailed(dataState.error!));
  //
  //       yield CubitGetUserInfoFailed(dataState.error!);
  //     }
  //   });
  // }

  Stream<FirestoreUserInfoState> updateUserInfo(
      UserPersonalInfo updatedUserInfo, Emitter emit) async* {
    yield* runBlocProcess(() async* {
      emit(CubitUserLoading());
      yield CubitUserLoading();
      final dataState =
          await updateUserInfoUseCase.call(params: updatedUserInfo);
      if (dataState is DataSuccess) {
        personalInfo = dataState.data;
        emit(CubitUserLoaded(dataState.data!));
        yield CubitUserLoaded(dataState.data!);
      }
      if (dataState is DataFailed) {
        emit(CubitGetUserInfoFailed(dataState.error!));
        yield CubitGetUserInfoFailed(dataState.error!);
      }
    });
  }

  Stream<FirestoreUserInfoState> uploadProfileImage(
      UploadProfileImageEvent event, Emitter emit) async* {
    yield* runBlocProcess(() async* {
      emit(CubitImageLoading());
      yield CubitImageLoading();
      final dataState = await uploadImageUseCase
          .call(params: [event.photo, event.userId, event.previousImageUrl]);
      if (dataState is DataSuccess) {
        emit(CubitImageLoaded(dataState.data!));
        yield CubitImageLoaded(dataState.data!);
      }
      if (dataState is DataFailed) {
        emit(CubitGetUserInfoFailed(dataState.error!));
        yield CubitGetUserInfoFailed(dataState.error!);
      }
    });
  }
}

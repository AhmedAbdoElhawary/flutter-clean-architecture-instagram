import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/domain/entities/user_personal_info.dart';
import 'package:instegram/domain/usecases/firestoreUsecase/get_user_info_usecase.dart';
part 'firestore_get_user_info_state.dart';

class FirestoreGetUserInfoCubit extends Cubit<FirestoreGetUserInfoState> {
  GetUserInfoUseCase getUserInfoUseCase;

  UserPersonalInfo? personalInfo;
  FirestoreGetUserInfoCubit(this.getUserInfoUseCase) : super(CubitInitial());

  static FirestoreGetUserInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  UserPersonalInfo? getUserInfo(String userId)  {
    emit(CubitUserLoading());
     getUserInfoUseCase.call(params: userId).then((userInfo) {
      personalInfo = userInfo;
      emit(CubitUserLoaded(userInfo));
    }).catchError((e) {
      emit(CubitGetUserInfoFailed(e.toString()));
    });
    return personalInfo;
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/new_user_info.dart';
import '../../../domain/entities/user_personal_info.dart';
import '../../../domain/usecases/firestoreUsecase/add_new_user_usecase.dart';
part 'firestore_add_new_user_state.dart';

class FirestoreAddNewUserCubit extends Cubit<FirestoreAddNewUserState> {
  AddNewUserUseCase addNewUserUseCase;

  FirestoreAddNewUserCubit(this.addNewUserUseCase) : super(CubitInitial());

  static FirestoreAddNewUserCubit get(BuildContext context) =>
      BlocProvider.of(context);

  void addNewUser(UserPersonalInfo newUserInfo) {
    emit(CubitUserAdding());
    addNewUserUseCase.call(params: newUserInfo).then((userInfo) {
      emit(CubitUserAdded());
    }).catchError((e) {
      emit(CubitAddNewUserFailed(e));
    });
  }
}

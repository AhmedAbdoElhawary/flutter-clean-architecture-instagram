import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../domain/use_cases/user/add_new_user_usecase.dart';
part 'add_new_user_state.dart';

class FireStoreAddNewUserCubit extends Cubit<FirestoreAddNewUserState> {
  final AddNewUserUseCase _addNewUserUseCase;

  FireStoreAddNewUserCubit(this._addNewUserUseCase) : super(CubitInitial());

  static FireStoreAddNewUserCubit get(BuildContext context) =>
      BlocProvider.of(context);

  void addNewUser(UserPersonalInfo newUserInfo) {
    emit(CubitUserAdding());
    _addNewUserUseCase.call(params: newUserInfo).then((userInfo) {
      emit(CubitUserAdded());
    }).catchError((e) {
      emit(CubitAddNewUserFailed(e));
    });
  }
}

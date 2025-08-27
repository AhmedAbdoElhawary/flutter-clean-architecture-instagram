import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_all_users_info.dart';
import 'package:instagram/domain/use_cases/user/my_personal_info.dart';

part 'users_info_reel_time_event.dart';
part 'users_info_reel_time_state.dart';

class UsersInfoReelTimeBloc
    extends Bloc<UsersInfoReelTimeEvent, UsersInfoReelTimeState> {
  final GetMyInfoUseCase _getMyInfoUseCase;
  final GetAllUsersUseCase _getAllUsersUseCase;

  UserPersonalInfo? myPersonalInfoInReelTime;
  List<UserPersonalInfo> allUsersInfoInReelTime = [];

  UsersInfoReelTimeBloc(this._getMyInfoUseCase, this._getAllUsersUseCase)
      : super(MyPersonalInfoInitial()) {
    on<LoadMyPersonalInfo>(_onLoadMyInfo);
    on<UpdateMyPersonalInfo>(_onUpdateMyInfo);
    on<LoadAllUsersInfoInfo>(_onLoadAllUsersInfo);
    on<UpdateAllUsersInfoInfo>(_onUpdateAllUsersInfo);
  }

  static UsersInfoReelTimeBloc get(BuildContext context) =>
      BlocProvider.of(context);

  static UserPersonalInfo? getMyInfoInReelTime(BuildContext context) =>
      BlocProvider.of<UsersInfoReelTimeBloc>(context).myPersonalInfoInReelTime;

  Future<void> _onLoadMyInfo(
      LoadMyPersonalInfo event,
      Emitter<UsersInfoReelTimeState> emit,
      ) async {
    await emit.forEach<UserPersonalInfo>(
      _getMyInfoUseCase.call(params: null),
      onData: (myInfo) {
        add(UpdateMyPersonalInfo(myInfo));
        return MyPersonalInfoLoaded(myPersonalInfoInReelTime: myInfo);
      },
      onError: (e, _) => MyPersonalInfoFailed(e.toString()),
    );
  }

  void _onUpdateMyInfo(
      UpdateMyPersonalInfo event,
      Emitter<UsersInfoReelTimeState> emit,
      ) {
    myPersonalInfoInReelTime = event.myPersonalInfoInReelTime;
    isMyInfoInReelTimeReady = true;

    emit(MyPersonalInfoLoaded(
        myPersonalInfoInReelTime: event.myPersonalInfoInReelTime));
  }

  Future<void> _onLoadAllUsersInfo(
      LoadAllUsersInfoInfo event,
      Emitter<UsersInfoReelTimeState> emit,
      ) async {
    await emit.forEach<List<UserPersonalInfo>>(
      _getAllUsersUseCase.call(params: null),
      onData: (allUsers) {
        add(UpdateAllUsersInfoInfo(allUsers));
        return AllUsersInfoLoaded(allUsersInfoInReelTime: allUsers);
      },
      onError: (e, _) => MyPersonalInfoFailed(e.toString()),
    );
  }

  void _onUpdateAllUsersInfo(
      UpdateAllUsersInfoInfo event,
      Emitter<UsersInfoReelTimeState> emit,
      ) {
    allUsersInfoInReelTime = event.allUsersInfoInReelTime;
    emit(AllUsersInfoLoaded(
        allUsersInfoInReelTime: event.allUsersInfoInReelTime));
  }
}

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
  UsersInfoReelTimeBloc(this._getMyInfoUseCase, this._getAllUsersUseCase)
      : super(MyPersonalInfoInitial());

  static UsersInfoReelTimeBloc get(BuildContext context) =>
      BlocProvider.of(context);
  UserPersonalInfo? myPersonalInfoInReelTime;
  List<UserPersonalInfo> allUsersInfoInReelTime = [];

  static UserPersonalInfo? getMyInfoInReelTime(BuildContext context) =>
      BlocProvider.of<UsersInfoReelTimeBloc>(context).myPersonalInfoInReelTime;

  @override
  Stream<UsersInfoReelTimeState> mapEventToState(
    UsersInfoReelTimeEvent event,
  ) async* {
    if (event is LoadMyPersonalInfo) {
      yield* _mapLoadMyInfoToState();
    } else if (event is UpdateMyPersonalInfo) {
      yield* _mapUpdateMyInfoToState(event);
    }
    if (event is LoadAllUsersInfoInfo) {
      yield* _mapLoadUsersInfoToState();
    } else if (event is UpdateAllUsersInfoInfo) {
      yield* _mapUpdateUsersInfoToState(event);
    }
  }

  Stream<UsersInfoReelTimeState> _mapLoadMyInfoToState() async* {
    _getMyInfoUseCase.call(params: null).listen(
      (myPersonalInfo) {
        add(UpdateMyPersonalInfo(myPersonalInfo));
      },
    ).onError((e) async* {
      yield MyPersonalInfoFailed(e.toString());
    });
  }

  Stream<UsersInfoReelTimeState> _mapUpdateMyInfoToState(
      UpdateMyPersonalInfo event) async* {
    myPersonalInfoInReelTime = event.myPersonalInfoInReelTime;
    isMyInfoInReelTimeReady = true;

    yield MyPersonalInfoLoaded(
        myPersonalInfoInReelTime: event.myPersonalInfoInReelTime);
  }

  Stream<UsersInfoReelTimeState> _mapLoadUsersInfoToState() async* {
    _getAllUsersUseCase.call(params: null).listen(
      (allUsersInfo) {
        add(UpdateAllUsersInfoInfo(allUsersInfo));
      },
    ).onError((e) async* {
      yield MyPersonalInfoFailed(e.toString());
    });
  }

  Stream<UsersInfoReelTimeState> _mapUpdateUsersInfoToState(
      UpdateAllUsersInfoInfo event) async* {
    allUsersInfoInReelTime = event.allUsersInfoInReelTime;
    yield AllUsersInfoLoaded(
        allUsersInfoInReelTime: event.allUsersInfoInReelTime);
  }
}

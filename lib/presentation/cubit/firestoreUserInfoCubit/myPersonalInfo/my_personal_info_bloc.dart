import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/use_cases/user/my_personal_info.dart';

part 'my_personal_info_event.dart';
part 'my_personal_info_state.dart';

class MyPersonalInfoBloc
    extends Bloc<MyPersonalInfoEvent, MyPersonalInfoState> {
  final GetMyInfoUseCase _getMyInfoUseCase;

  MyPersonalInfoBloc(this._getMyInfoUseCase) : super(MyPersonalInfoInitial());

  static MyPersonalInfoBloc get(BuildContext context) =>
      BlocProvider.of(context);
  UserPersonalInfo? myPersonalInfoInReelTime;

  static UserPersonalInfo? getMyInfoInReelTime(BuildContext context) =>
      BlocProvider.of<MyPersonalInfoBloc>(context).myPersonalInfoInReelTime;

  @override
  Stream<MyPersonalInfoState> mapEventToState(
    MyPersonalInfoEvent event,
  ) async* {
    if (event is LoadMyPersonalInfo) {
      yield* _mapLoadInfoToState();
    } else if (event is UpdateMyPersonalInfo) {
      yield* _mapUpdateInfoToState(event);
    }
  }

  Stream<MyPersonalInfoState> _mapLoadInfoToState() async* {
    _getMyInfoUseCase.call(params: null).listen(
      (myPersonalInfo) {
        add(UpdateMyPersonalInfo(myPersonalInfo));
      },
    ).onError((e) async* {
      yield MyPersonalInfoFailed(e.toString());
    });
  }

  Stream<MyPersonalInfoState> _mapUpdateInfoToState(
      UpdateMyPersonalInfo event) async* {
    myPersonalInfoInReelTime = event.myPersonalInfoInReelTime;
    yield MyPersonalInfoLoaded(
        myPersonalInfoInReelTime: event.myPersonalInfoInReelTime);
  }
}

part of 'my_personal_info_bloc.dart';

abstract class MyPersonalInfoEvent extends Equatable {
  const MyPersonalInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadMyPersonalInfo extends MyPersonalInfoEvent {}

class UpdateMyPersonalInfo extends MyPersonalInfoEvent {
  final UserPersonalInfo myPersonalInfoInReelTime;

  const UpdateMyPersonalInfo(this.myPersonalInfoInReelTime);
  @override
  List<Object> get props => [myPersonalInfoInReelTime];
}

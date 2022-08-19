part of 'users_info_reel_time_bloc.dart';

abstract class UsersInfoReelTimeEvent extends Equatable {
  const UsersInfoReelTimeEvent();

  @override
  List<Object> get props => [];
}

class LoadMyPersonalInfo extends UsersInfoReelTimeEvent {}

class LoadAllUsersInfoInfo extends UsersInfoReelTimeEvent {}

class UpdateMyPersonalInfo extends UsersInfoReelTimeEvent {
  final UserPersonalInfo myPersonalInfoInReelTime;

  const UpdateMyPersonalInfo(this.myPersonalInfoInReelTime);
  @override
  List<Object> get props => [myPersonalInfoInReelTime];
}

class UpdateAllUsersInfoInfo extends UsersInfoReelTimeEvent {
  final List<UserPersonalInfo> allUsersInfoInReelTime;

  const UpdateAllUsersInfoInfo(this.allUsersInfoInReelTime);
  @override
  List<Object> get props => [allUsersInfoInReelTime];
}

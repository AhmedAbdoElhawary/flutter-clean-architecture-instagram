part of 'users_info_reel_time_bloc.dart';

abstract class UsersInfoReelTimeState extends Equatable {
  const UsersInfoReelTimeState();

  @override
  List<Object> get props => [];
}

class MyPersonalInfoInitial extends UsersInfoReelTimeState {}

class MyPersonalInfoLoaded extends UsersInfoReelTimeState {
  final UserPersonalInfo myPersonalInfoInReelTime;

  const MyPersonalInfoLoaded({required this.myPersonalInfoInReelTime});
  @override
  List<Object> get props => [myPersonalInfoInReelTime];
}

class AllUsersInfoLoaded extends UsersInfoReelTimeState {
  final List<UserPersonalInfo> allUsersInfoInReelTime;

  const AllUsersInfoLoaded({required this.allUsersInfoInReelTime});
  @override
  List<Object> get props => [allUsersInfoInReelTime];
}

class MyPersonalInfoFailed extends UsersInfoReelTimeState {
  final String error;
  const MyPersonalInfoFailed(this.error);
  @override
  List<Object> get props => [error];
}

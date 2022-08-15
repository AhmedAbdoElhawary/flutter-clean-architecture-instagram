part of 'my_personal_info_bloc.dart';

abstract class MyPersonalInfoState extends Equatable {
  const MyPersonalInfoState();

  @override
  List<Object> get props => [];
}

class MyPersonalInfoInitial extends MyPersonalInfoState {}

class MyPersonalInfoLoaded extends MyPersonalInfoState {
  final UserPersonalInfo myPersonalInfoInReelTime;

  const MyPersonalInfoLoaded({required this.myPersonalInfoInReelTime});
  @override
  List<Object> get props => [myPersonalInfoInReelTime];
}

class MyPersonalInfoFailed extends MyPersonalInfoState {
  final String error;
  const MyPersonalInfoFailed(this.error);
  @override
  List<Object> get props => [error];
}

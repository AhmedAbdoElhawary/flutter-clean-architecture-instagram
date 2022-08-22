part of '../firestoreUserInfoCubit/user_info_cubit.dart';

abstract class UserInfoState {}

class CubitInitial extends UserInfoState {}

class CubitUserLoading extends UserInfoState {}

class CubitImageLoading extends UserInfoState {}

class CubitImageLoaded extends UserInfoState {
  String imageUrl;

  CubitImageLoaded(this.imageUrl);
}

class CubitMyPersonalInfoLoaded extends UserInfoState {
  UserPersonalInfo userPersonalInfo;

  CubitMyPersonalInfoLoaded(this.userPersonalInfo);
}

// all user info loaded
class CubitAllUnFollowersUserLoaded extends UserInfoState {
  List<UserPersonalInfo> usersInfo;

  CubitAllUnFollowersUserLoaded(this.usersInfo);
}

// all user info loading
class CubitAllUnFollowersUserLoading extends UserInfoState {}

class CubitUserLoaded extends UserInfoState {
  UserPersonalInfo userPersonalInfo;

  CubitUserLoaded(this.userPersonalInfo);
}

class CubitGetUserInfoFailed extends UserInfoState {
  final String error;
  CubitGetUserInfoFailed(this.error);
}

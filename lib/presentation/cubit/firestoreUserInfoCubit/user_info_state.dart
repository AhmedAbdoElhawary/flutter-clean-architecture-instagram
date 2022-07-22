part of '../firestoreUserInfoCubit/user_info_cubit.dart';

abstract class FirestoreUserInfoState {}

class CubitInitial extends FirestoreUserInfoState {}

class CubitUserLoading extends FirestoreUserInfoState {}

class CubitImageLoading extends FirestoreUserInfoState {}

class CubitImageLoaded extends FirestoreUserInfoState {
  String imageUrl;

  CubitImageLoaded(this.imageUrl);
}

class CubitMyPersonalInfoLoaded extends FirestoreUserInfoState {
  UserPersonalInfo userPersonalInfo;

  CubitMyPersonalInfoLoaded(this.userPersonalInfo);
}

// all user info loaded
class CubitAllUnFollowersUserLoaded extends FirestoreUserInfoState {
  List<UserPersonalInfo> usersInfo;

  CubitAllUnFollowersUserLoaded(this.usersInfo);
}
// all user info loading
class CubitAllUnFollowersUserLoading extends FirestoreUserInfoState {}

class CubitUserLoaded extends FirestoreUserInfoState {
  UserPersonalInfo userPersonalInfo;

  CubitUserLoaded(this.userPersonalInfo);
}

class CubitGetUserInfoFailed extends FirestoreUserInfoState {
  final String error;
  CubitGetUserInfoFailed(this.error);
}

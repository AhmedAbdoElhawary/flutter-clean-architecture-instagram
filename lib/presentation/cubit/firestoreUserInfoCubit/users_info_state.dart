part of 'users_info_cubit.dart';

abstract class UsersInfoState {}

class UsersInfoInitial extends UsersInfoState {}

class CubitFollowersAndFollowingsLoading extends UsersInfoState {}

class CubitFollowersAndFollowingsLoaded extends UsersInfoState {
  FollowersAndFollowingsInfo followersAndFollowingsInfo;

  CubitFollowersAndFollowingsLoaded(this.followersAndFollowingsInfo);
}

class CubitGettingSpecificUsersLoaded extends UsersInfoState {
  List<UserPersonalInfo> specificUsersInfo;

  CubitGettingSpecificUsersLoaded(this.specificUsersInfo);
}

class CubitGettingSpecificUsersFailed extends UsersInfoState {
  final String error;
  CubitGettingSpecificUsersFailed(this.error);
}

class CubitGettingChatUsersInfoLoading extends UsersInfoState {}

class CubitGettingChatUsersInfoLoaded extends UsersInfoState {
  List<SenderInfo> usersInfo;

  CubitGettingChatUsersInfoLoaded(this.usersInfo);
}

part of 'user_info_bloc.dart';

abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object> get props => [];
}

class GetUserInfoEvent extends UserInfoEvent {
  final String userId;

  const GetUserInfoEvent(this.userId);
  @override
  List<Object> get props => [userId];
}

class UpdateUserInfoEvent extends UserInfoEvent {
  final UserPersonalInfo updatedUserInfo;

  const UpdateUserInfoEvent(this.updatedUserInfo);
  @override
  List<Object> get props => [updatedUserInfo];
}

class UploadProfileImageEvent extends UserInfoEvent {
  final File photo;
  final String userId;
  final String previousImageUrl;

  const UploadProfileImageEvent(
      {required this.photo,
      required this.userId,
      required this.previousImageUrl});

  @override
  List<Object> get props => [photo, userId, previousImageUrl];
}

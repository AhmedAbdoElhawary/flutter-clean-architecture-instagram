part of 'user_info_bloc.dart';

abstract class FirestoreUserInfoState extends Equatable {
  const FirestoreUserInfoState();

  @override
  List<Object> get props => [];
}

class CubitInitial extends FirestoreUserInfoState {}

class CubitUserLoading extends FirestoreUserInfoState {}

class CubitImageLoading extends FirestoreUserInfoState {}

class CubitImageLoaded extends FirestoreUserInfoState {
  final String imageUrl;

  const CubitImageLoaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class CubitUserLoaded extends FirestoreUserInfoState {
  final UserPersonalInfo userPersonalInfo;

  const CubitUserLoaded(this.userPersonalInfo);
  @override
  List<Object> get props => [userPersonalInfo];
}

class CubitGetUserInfoFailed extends FirestoreUserInfoState {
  final String error;
  const CubitGetUserInfoFailed(this.error);
  @override
  List<Object> get props => [error];
}

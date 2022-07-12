part of 'follow_cubit.dart';

abstract class FollowState extends Equatable {
  const FollowState();

  @override
  List<Object> get props => [];
}

class FollowInitial extends FollowState {}

class CubitFollowThisUserLoading extends FollowState {}

class CubitFollowThisUserLoaded extends FollowState {}

class CubitFollowThisUserFailed extends FollowState {
  final String error;
  const CubitFollowThisUserFailed(this.error);
}

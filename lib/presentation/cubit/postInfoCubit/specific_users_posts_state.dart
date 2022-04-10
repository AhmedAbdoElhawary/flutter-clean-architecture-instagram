part of 'specific_users_posts_cubit.dart';

abstract class SpecificUsersPostsState extends Equatable {
  const SpecificUsersPostsState();

  @override
  List<Object> get props => [];
}

class SpecificUsersPostsInitial extends SpecificUsersPostsState {}

class SpecificUsersPostsLoading extends SpecificUsersPostsState {}

class SpecificUsersPostsLoaded extends SpecificUsersPostsState {
  final List allSpecificPostInfo;
  const SpecificUsersPostsLoaded(this.allSpecificPostInfo);
}

class SpecificUsersPostsFailed extends SpecificUsersPostsState {
  final String error;
  const SpecificUsersPostsFailed(this.error);
}

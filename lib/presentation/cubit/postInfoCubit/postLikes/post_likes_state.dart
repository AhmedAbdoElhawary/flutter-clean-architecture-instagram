part of 'post_likes_cubit.dart';

abstract class PostLikesState extends Equatable {
  const PostLikesState();

  @override
  List<Object> get props => [];
}

class PostLikesInitial extends PostLikesState {}

class CubitPostLikesLoading extends PostLikesState {}

class CubitPostLikesLoaded extends PostLikesState {}

class CubitPostLikesFailed extends PostLikesState {
  final String error;
  const CubitPostLikesFailed(this.error);
}

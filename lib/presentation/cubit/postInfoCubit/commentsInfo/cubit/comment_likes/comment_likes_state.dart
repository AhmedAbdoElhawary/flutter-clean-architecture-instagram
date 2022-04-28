part of 'comment_likes_cubit.dart';

abstract class CommentLikesState extends Equatable {
  const CommentLikesState();

  @override
  List<Object> get props => [];
}

class CommentLikesInitial extends CommentLikesState {}

class CubitCommentLikesLoading extends CommentLikesState {}

class CubitCommentLikesLoaded extends CommentLikesState {}

class CubitCommentLikesFailed extends CommentLikesState {
  final String error;
  const CubitCommentLikesFailed(this.error);
}

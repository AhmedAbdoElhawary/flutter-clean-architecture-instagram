part of 'comments_info_cubit.dart';

abstract class CommentsInfoState extends Equatable {
  const CommentsInfoState();

  @override
  List<Object> get props => [];
}

class CommentsInfoInitial extends CommentsInfoState {}

class CubitCommentsInfoLoading extends CommentsInfoState {}

class CubitCommentsInfoLoaded extends CommentsInfoState {
  final List<Comment> commentsOfThePost;

  const CubitCommentsInfoLoaded(this.commentsOfThePost);
}

class CubitCommentsInfoFailed extends CommentsInfoState {
  final String error;
  const CubitCommentsInfoFailed(this.error);
}

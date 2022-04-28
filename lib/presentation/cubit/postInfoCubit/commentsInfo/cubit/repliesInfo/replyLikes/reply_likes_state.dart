part of 'reply_likes_cubit.dart';

abstract class ReplyLikesState extends Equatable {
  const ReplyLikesState();

  @override
  List<Object> get props => [];
}

class ReplyLikesInitial extends ReplyLikesState {}

class CubitReplyLikesLoading extends ReplyLikesState {}

class CubitReplyLikesLoaded extends ReplyLikesState {}

class CubitReplyLikesFailed extends ReplyLikesState {
  final String error;
  const CubitReplyLikesFailed(this.error);
}

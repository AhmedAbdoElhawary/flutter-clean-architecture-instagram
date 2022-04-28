part of 'reply_info_cubit.dart';

abstract class ReplyInfoState extends Equatable {
  const ReplyInfoState();

  @override
  List<Object> get props => [];
}

class ReplyInfoInitial extends ReplyInfoState {}

class CubitReplyInfoLoading extends ReplyInfoState {}

class CubitReplyInfoLoaded extends ReplyInfoState {
  final List<Comment> repliesInfo;

  const CubitReplyInfoLoaded(this.repliesInfo);
}

class CubitReplyInfoFailed extends ReplyInfoState {
  final String error;
  const CubitReplyInfoFailed(this.error);
}

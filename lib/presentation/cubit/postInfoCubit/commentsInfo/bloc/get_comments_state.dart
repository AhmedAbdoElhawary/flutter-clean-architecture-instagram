part of 'get_comments_bloc.dart';

abstract class GetCommentsState extends Equatable {
  const GetCommentsState();

  @override
  List<Object> get props => [];
}

class GetCommentsInitial extends GetCommentsState {}

class GetCommentsLoading extends GetCommentsState {}

class GetCommentsLoaded extends GetCommentsState {
  final List<Comment> comments;

  const GetCommentsLoaded({this.comments = const <Comment>[]});
  @override
  List<Object> get props => [comments];
}

part of 'get_comments_bloc.dart';

abstract class GetCommentsEvent extends Equatable {
  const GetCommentsEvent();

  @override
  List<Object> get props => [];
}
class LoadComments extends GetCommentsEvent {
  final String postId;

  const LoadComments({required this.postId});
  @override
  List<Object> get props => [postId];
}

class UpdateComments extends GetCommentsEvent {
  final List<Comment> commentsOfThePost;

  const UpdateComments(this.commentsOfThePost);
  @override
  List<Object> get props => [commentsOfThePost];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/domain/usecases/postUseCase/comments/getComment/get_all_comment.dart';
import 'package:instegram/domain/usecases/postUseCase/comments/getComment/get_comment.dart';

part 'get_comments_event.dart';
part 'get_comments_state.dart';

class GetCommentsBloc extends Bloc<GetCommentsEvent, GetCommentsState> {
  final GetPostInfoStreamedUseCase _getSpecificCommentsUseCase;
  final GetCommentUseCase _getCommentUseCase;
  List<Comment> commentsOfThePost = [];
  GetCommentsBloc(this._getSpecificCommentsUseCase, this._getCommentUseCase)
      : super(GetCommentsLoading());
  @override
  Stream<GetCommentsState> mapEventToState(
    GetCommentsEvent event,
  ) async* {
    if (event is LoadComments) {
      yield* _mapLoadCommentsToState(postId: event.postId);
    } else if (event is UpdateComments) {
      yield* _mapUpdateCommentsToState(event);
    }
  }

  Stream<GetCommentsState> _mapLoadCommentsToState(
      {required String postId}) async* {
    _getSpecificCommentsUseCase.call(params: postId).listen((postInfo) {
      _getCommentUseCase
          .call(params: postInfo.comments)
          .then((updatedCommentsInfo) {
        add(UpdateComments(updatedCommentsInfo));
      });
    });
  }

  Stream<GetCommentsState> _mapUpdateCommentsToState(
      UpdateComments event) async* {
    yield GetCommentsLoaded(comments: event.commentsOfThePost);
  }
}

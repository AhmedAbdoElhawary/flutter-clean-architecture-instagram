import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/domain/usecases/postUseCase/comments/add_comment_use_case.dart';
import 'package:instegram/domain/usecases/postUseCase/comments/get_all_comment.dart';

part 'comments_info_state.dart';

class CommentsInfoCubit extends Cubit<CommentsInfoState> {
  final GetAllCommentsUseCase _getAllCommentsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  List<Comment> commentsOfThePost = [];

  CommentsInfoCubit(this._getAllCommentsUseCase, this._addCommentUseCase)
      : super(CommentsInfoInitial());

  static CommentsInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> getCommentsOfThisPost({required String postId}) async {
    emit(CubitCommentsInfoLoading());
    await _getAllCommentsUseCase.call(params: postId).then((commentsInfo) {
      commentsOfThePost = commentsInfo;
      emit(CubitCommentsInfoLoaded(commentsInfo));
    }).catchError((e) {
      emit(CubitCommentsInfoFailed(e.toString()));
    });
  }

  Future<void> addComment({required Comment commentInfo}) async {
    emit(CubitCommentsInfoLoading());
    await _addCommentUseCase
        .call(params: commentInfo)
        .then((updatedCommentInfo) {
      commentsOfThePost = [updatedCommentInfo] + commentsOfThePost;
      print("done adding");
      emit(CubitCommentsInfoLoaded(commentsOfThePost));
    }).catchError((e) {
      emit(CubitCommentsInfoFailed(e.toString()));
    });
  }

}

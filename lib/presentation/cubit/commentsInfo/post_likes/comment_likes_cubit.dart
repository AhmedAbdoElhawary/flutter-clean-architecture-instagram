import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/domain/usecases/postUseCase/comments/put_like.dart';
import 'package:instegram/domain/usecases/postUseCase/comments/remove_like.dart';

part 'comment_likes_state.dart';

class CommentLikesCubit extends Cubit<CommentLikesState> {
  final PutLikeOnThisCommentUseCase _putLikeOnThisCommentUseCase;
  final RemoveLikeOnThisCommentUseCase _removeLikeOnThisCommentUseCase;
  CommentLikesCubit(
      this._putLikeOnThisCommentUseCase, this._removeLikeOnThisCommentUseCase)
      : super(CommentLikesInitial());

  static CommentLikesCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> putLikeOnThisComment(
      {required String postId,
      required String commentId,
      required String myPersonalId}) async {
    emit(CubitCommentLikesLoading());

    await _putLikeOnThisCommentUseCase
        .call(
            paramsOne: postId, paramsTwo: commentId, paramsThree: myPersonalId)
        .then((_) {
      emit(CubitCommentLikesLoaded());
    }).catchError((e) {
      emit(CubitCommentLikesFailed(e.toString()));
    });
  }

  Future<void> removeLikeOnThisComment(
      {required String postId,
        required String commentId,
        required String myPersonalId}) async {
    emit(CubitCommentLikesLoading());

    await _removeLikeOnThisCommentUseCase
        .call(
        paramsOne: postId, paramsTwo: commentId, paramsThree: myPersonalId)
        .then((_) {
      emit(CubitCommentLikesLoaded());
    }).catchError((e) {
      emit(CubitCommentLikesFailed(e.toString()));
    });
  }
}

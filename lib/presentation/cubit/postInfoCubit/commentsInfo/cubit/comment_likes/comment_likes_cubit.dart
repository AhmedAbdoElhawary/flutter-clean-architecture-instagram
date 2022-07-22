import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/domain/use_cases/post/comments/put_like.dart';
import 'package:instagram/domain/use_cases/post/comments/remove_like.dart';

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
        .call(paramsOne: commentId, paramsTwo: myPersonalId)
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
        .call(paramsOne: commentId, paramsTwo: myPersonalId)
        .then((_) {
      emit(CubitCommentLikesLoaded());
    }).catchError((e) {
      emit(CubitCommentLikesFailed(e.toString()));
    });
  }
}

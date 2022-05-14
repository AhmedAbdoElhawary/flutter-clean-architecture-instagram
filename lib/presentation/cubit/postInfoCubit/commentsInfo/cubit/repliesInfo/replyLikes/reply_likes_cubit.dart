import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/domain/use_cases/post/comments/replies/likes/put_like_on_this_reply.dart';
import 'package:instagram/domain/use_cases/post/comments/replies/likes/remove_like_on_this_reply.dart';

part 'reply_likes_state.dart';

class ReplyLikesCubit extends Cubit<ReplyLikesState> {
  final PutLikeOnThisReplyUseCase _putLikeOnThisReplyUseCase;
  final RemoveLikeOnThisReplyUseCase _removeLikeOnThisReplyUseCase;
  ReplyLikesCubit(
      this._putLikeOnThisReplyUseCase, this._removeLikeOnThisReplyUseCase)
      : super(ReplyLikesInitial());

  static ReplyLikesCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    emit(CubitReplyLikesLoading());

    await _putLikeOnThisReplyUseCase
        .call(paramsOne: replyId, paramsTwo: myPersonalId)
        .then((_) {
      emit(CubitReplyLikesLoaded());
    }).catchError((e) {
      emit(CubitReplyLikesFailed(e.toString()));
    });
  }

  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    emit(CubitReplyLikesLoading());

    await _removeLikeOnThisReplyUseCase
        .call(paramsOne: replyId, paramsTwo: myPersonalId)
        .then((_) {
      emit(CubitReplyLikesLoaded());
    }).catchError((e) {
      emit(CubitReplyLikesFailed(e.toString()));
    });
  }
}

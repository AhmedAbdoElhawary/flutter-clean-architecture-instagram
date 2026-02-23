import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instagram/domain/use_cases/post/comments/replies/get_replies_of_this_comment.dart';
import 'package:instagram/domain/use_cases/post/comments/replies/reply_on_this_comment.dart';

part 'reply_info_state.dart';

class ReplyInfoCubit extends Cubit<ReplyInfoState> {
  final ReplyOnThisCommentUseCase _replyOnThisCommentUseCase;
  final GetRepliesOfThisCommentUseCase _getRepliesOfThisCommentUseCase;
  List<Comment> repliesOnComment = [];

  ReplyInfoCubit(
      this._getRepliesOfThisCommentUseCase, this._replyOnThisCommentUseCase)
      : super(ReplyInfoInitial());

  static ReplyInfoCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getRepliesOfThisComment({required String commentId}) async {
    emit(CubitReplyInfoLoading());
    await _getRepliesOfThisCommentUseCase
        .call(params: commentId)
        .then((repliesInfo) {
      repliesOnComment = repliesInfo;
      emit(CubitReplyInfoLoaded(repliesInfo));
    }).catchError((e) {
      emit(CubitReplyInfoFailed(e.toString()));
    });
  }

  Future<void> replyOnThisComment({required Comment replyInfo}) async {
    emit(CubitReplyInfoLoading());
    await _replyOnThisCommentUseCase
        .call(params: replyInfo)
        .then((updatedReplyInfo) {
      repliesOnComment = [updatedReplyInfo] + repliesOnComment;
      emit(CubitReplyInfoLoaded(repliesOnComment));
    }).catchError((e) {
      emit(CubitReplyInfoFailed(e.toString()));
    });
  }
}

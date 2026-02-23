import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/domain/use_cases/post/likes/put_like_on_this_post.dart';
import 'package:instagram/domain/use_cases/post/likes/remove_the_like_on_this_post.dart';

part 'post_likes_state.dart';

class PostLikesCubit extends Cubit<PostLikesState> {
  final PutLikeOnThisPostUseCase _putLikeOnThisPostUseCase;
  final RemoveTheLikeOnThisPostUseCase _removeTheLikeOnThisPostUseCase;
  PostLikesCubit(
      this._removeTheLikeOnThisPostUseCase, this._putLikeOnThisPostUseCase)
      : super(PostLikesInitial());
  static PostLikesCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> putLikeOnThisPost(
      {required String postId, required String userId}) async {
    emit(CubitPostLikesLoading());

    await _putLikeOnThisPostUseCase
        .call(paramsOne: postId, paramsTwo: userId)
        .then((_) {
      emit(CubitPostLikesLoaded());
    }).catchError((e) {
      emit(CubitPostLikesFailed(e.toString()));
    });
  }

  Future<void> removeTheLikeOnThisPost(
      {required String postId, required String userId}) async {
    emit(CubitPostLikesLoading());

    await _removeTheLikeOnThisPostUseCase
        .call(paramsOne: postId, paramsTwo: userId)
        .then((_) {
      emit(CubitPostLikesLoaded());
    }).catchError((e) {
      emit(CubitPostLikesFailed(e.toString()));
    });
  }
}

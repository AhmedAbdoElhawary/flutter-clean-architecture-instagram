import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/domain/use_cases/follow/follow_this_user.dart';
import 'package:instagram/domain/use_cases/follow/remove_this_follower.dart';
part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowThisUserUseCase followThisUserUseCase;
  UnFollowThisUserUseCase unFollowThisUserUseCase;
  FollowCubit(this.followThisUserUseCase, this.unFollowThisUserUseCase)
      : super(FollowInitial());

  static FollowCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> followThisUser(
      {required String followingUserId, required String myPersonalId}) async {
    emit(CubitFollowThisUserLoading());

    await followThisUserUseCase
        .call(paramsOne: followingUserId, paramsTwo: myPersonalId)
        .then((_) {
      emit(CubitFollowThisUserLoaded());
    }).catchError((e) {
      emit(CubitFollowThisUserFailed(e.toString()));
    });
  }

  Future<void> unFollowThisUser(
      {required String followingUserId, required String myPersonalId}) async {
    emit(CubitFollowThisUserLoading());

    await unFollowThisUserUseCase
        .call(paramsOne: followingUserId, paramsTwo: myPersonalId)
        .then((_) {
      emit(CubitFollowThisUserLoaded());
    }).catchError((e) {
      emit(CubitFollowThisUserFailed(e.toString()));
    });
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/domain/usecases/followUseCase/follow_this_user.dart';
import 'package:instegram/domain/usecases/followUseCase/remove_this_follower.dart';
part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowThisUserUseCase followThisUserUseCase;
  RemoveThisFollowerUseCase removeThisFollowerUseCase;
  FollowCubit(this.followThisUserUseCase, this.removeThisFollowerUseCase)
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

  Future<void> removeThisFollower(
      {required String followingUserId, required String myPersonalId}) async {
    emit(CubitFollowThisUserLoading());

    await removeThisFollowerUseCase
        .call(paramsOne: followingUserId, paramsTwo: myPersonalId)
        .then((_) {
      emit(CubitFollowThisUserLoaded());
    }).catchError((e) {
      emit(CubitFollowThisUserFailed(e.toString()));
    });
  }
}

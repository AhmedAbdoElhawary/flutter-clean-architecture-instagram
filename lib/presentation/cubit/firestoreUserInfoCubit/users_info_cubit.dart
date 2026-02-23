import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/domain/entities/sender_info.dart';
import 'package:instagram/domain/entities/specific_users_info.dart';
import 'package:instagram/domain/use_cases/message/single_message/get_chat_users_info.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_followers_and_followings_usecase.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_specific_users_usecase.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';

part 'users_info_state.dart';

class UsersInfoCubit extends Cubit<UsersInfoState> {
  final GetFollowersAndFollowingsUseCase getFollowersAndFollowingsUseCase;
  final GetSpecificUsersUseCase getSpecificUsersUseCase;
  final GetChatUsersInfoAddMessageUseCase _getChatUsersInfoAddMessageUseCase;

  UsersInfoCubit(this.getFollowersAndFollowingsUseCase,
      this.getSpecificUsersUseCase, this._getChatUsersInfoAddMessageUseCase)
      : super(UsersInfoInitial());
  static UsersInfoCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds}) async {
    emit(CubitFollowersAndFollowingsLoading());

    await getFollowersAndFollowingsUseCase
        .call(paramsOne: followersIds, paramsTwo: followingsIds)
        .then((specificUsersInfo) {
      emit(CubitFollowersAndFollowingsLoaded(specificUsersInfo));
    }).catchError((e) {
      emit(CubitGettingSpecificUsersFailed(e.toString()));
    });
  }

  Future<void> getSpecificUsersInfo({required List<dynamic> usersIds}) async {
    emit(CubitFollowersAndFollowingsLoading());
    await getSpecificUsersUseCase.call(params: usersIds).then((usersIds) {
      emit(CubitGettingSpecificUsersLoaded(usersIds));
    }).catchError((e) {
      emit(CubitGettingSpecificUsersFailed(e.toString()));
    });
  }

  Future<void> getChatUsersInfo(
      {required UserPersonalInfo myPersonalInfo}) async {
    emit(CubitGettingChatUsersInfoLoading());
    await _getChatUsersInfoAddMessageUseCase
        .call(params: myPersonalInfo)
        .then((usersInfo) {
      emit(CubitGettingChatUsersInfoLoaded(usersInfo));
    }).catchError((e) {
      emit(CubitGettingSpecificUsersFailed(e.toString()));
    });
  }
}

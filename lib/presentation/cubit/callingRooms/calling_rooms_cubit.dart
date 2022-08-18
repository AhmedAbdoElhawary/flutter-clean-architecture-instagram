import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/entities/calling_status.dart';
import 'package:instagram/domain/use_cases/calling_rooms/cancel_joining_to_room.dart';
import 'package:instagram/domain/use_cases/calling_rooms/create_calling_room.dart';
import 'package:instagram/domain/use_cases/calling_rooms/delete_the_room.dart';
import 'package:instagram/domain/use_cases/calling_rooms/get_users_info_in_room.dart';
import 'package:instagram/domain/use_cases/calling_rooms/join_to_calling_room.dart';

part 'calling_rooms_state.dart';

class CallingRoomsCubit extends Cubit<CallingRoomsState> {
  final JoinToCallingRoomUseCase _joinToRoomUseCase;
  final CreateCallingRoomUseCase _createCallingRoomUseCase;
  final CancelJoiningToRoomUseCase _cancelJoiningToRoomUseCase;
  final GetUsersInfoInRoomUseCase _getUsersInfoInRoomUseCase;
  final DeleteTheRoomUseCase _deleteTheRoomUseCase;
  CallingRoomsCubit(
    this._createCallingRoomUseCase,
    this._joinToRoomUseCase,
    this._cancelJoiningToRoomUseCase,
    this._deleteTheRoomUseCase,
    this._getUsersInfoInRoomUseCase,
  ) : super(CallingRoomsInitial());

  static CallingRoomsCubit get(BuildContext context) =>
      BlocProvider.of(context);
  Future<void> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required String callToThisUserId}) async {
    emit(CallingRoomsLoading());
    await _createCallingRoomUseCase
        .call(paramsOne: myPersonalInfo, paramsTwo: callToThisUserId)
        .then((channelId) {
      emit(CallingRoomsLoaded(channelId: channelId));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }

  Future<void> getUsersInfoInThisRoom({required String channelId}) async {
    emit(CallingRoomsLoading());
    await _getUsersInfoInRoomUseCase.call(params: channelId).then((usersInfo) {
      emit(UsersInfoInRoomLoaded(usersInfo: usersInfo));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }

  Future<void> joinToRoom(
      {required String channelId, required UserPersonalInfo userInfo}) async {
    emit(CallingRoomsLoading());
    await _joinToRoomUseCase
        .call(paramsOne: channelId, paramsTwo: userInfo)
        .then((_) {
      emit(CallingRoomsLoaded(channelId: channelId));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }

  Future<void> deleteTheRoom(
      {required String channelId, required String userId}) async {
    emit(CallingRoomsLoading());
    await _deleteTheRoomUseCase
        .call(paramsOne: channelId, paramsTwo: userId)
        .then((_) {
      emit(const CallingRoomsLoaded(channelId: ""));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }

  Future<void> cancelJoiningToRoom({required String userId}) async {
    emit(CallingRoomsLoading());
    await _cancelJoiningToRoomUseCase.call(params: userId).then((_) {
      emit(const CallingRoomsLoaded(channelId: ""));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }
}

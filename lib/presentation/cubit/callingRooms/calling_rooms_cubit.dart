import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
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
      required List<UserPersonalInfo> callThoseUsersInfo}) async {
    emit(CallingRoomsLoading());
    await _createCallingRoomUseCase
        .call(paramsOne: myPersonalInfo, paramsTwo: callThoseUsersInfo)
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
      {required String channelId,
      required UserPersonalInfo myPersonalInfo}) async {
    emit(CallingRoomsLoading());
    await _joinToRoomUseCase
        .call(paramsOne: channelId, paramsTwo: myPersonalInfo)
        .then((_) {
      emit(CallingRoomsLoaded(channelId: channelId));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }

  Future<void> deleteTheRoom(
      {required String channelId, List<dynamic> usersIds = const []}) async {
    emit(CallingRoomsLoading());
    await _deleteTheRoomUseCase
        .call(paramsOne: channelId, paramsTwo: usersIds)
        .then((_) {
      emit(const CallingRoomsLoaded(channelId: ""));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }

  Future<void> leaveTheRoom({
    required String userId,
    required String channelId,
    required bool isThatAfterJoining,
  }) async {
    emit(CallingRoomsLoading());
    await _cancelJoiningToRoomUseCase
        .call(
            paramsOne: userId,
            paramsTwo: channelId,
            paramsThree: isThatAfterJoining)
        .then((_) {
      emit(const CallingRoomsLoaded(channelId: ""));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }
}

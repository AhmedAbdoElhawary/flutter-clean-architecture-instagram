import 'dart:io';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/domain/entities/sender_info.dart';
import 'package:instagram/domain/use_cases/message/common/get_specific_chat_info.dart';
import 'package:instagram/domain/use_cases/message/single_message/add_message.dart';
import 'package:instagram/domain/use_cases/message/single_message/delete_message.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final AddMessageUseCase _addMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final GetSpecificChatInfo _getSpecificChatInfo;
  List<Message> messagesInfo = [];
  MessageCubit(this._addMessageUseCase, this._deleteMessageUseCase,
      this._getSpecificChatInfo)
      : super(MessageInitial());

  static MessageCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> sendMessage({
    required Message messageInfo,
    Uint8List? pathOfPhoto,
    File? recordFile,
  }) async {
    emit(SendMessageLoading());
    await _addMessageUseCase
        .call(
            paramsOne: messageInfo,
            paramsTwo: pathOfPhoto,
            paramsThree: recordFile)
        .then((messageInfo) {
      emit(SendMessageLoaded(messageInfo));
    }).catchError((e) {
      emit(SendMessageFailed(e.toString()));
    });
  }

  Future<void> getSpecificChatInfo(
      {required String chatUid, required bool isThatGroup}) async {
    emit(GetSpecificChatLoading());
    await _getSpecificChatInfo
        .call(paramsOne: chatUid, paramsTwo: isThatGroup)
        .then((coverMessageDetails) {
      emit(GetSpecificChatLoaded(coverMessageDetails));
    }).catchError((e) {
      emit(GetMessageFailed(e.toString()));
    });
  }

  Future<void> deleteMessage({
    required Message messageInfo,
    Message? replacedMessage,
    bool isThatOnlyMessageInChat = false,
  }) async {
    emit(DeleteMessageLoading());
    await _deleteMessageUseCase
        .call(
            paramsOne: messageInfo,
            paramsTwo: replacedMessage,
            paramsThree: isThatOnlyMessageInChat)
        .then((_) {
      emit(DeleteMessageLoaded());
    }).catchError((e) {
      emit(SendMessageFailed(e.toString()));
    });
  }
}

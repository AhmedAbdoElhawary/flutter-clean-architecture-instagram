import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/domain/use_cases/message/group_message/add_message.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:instagram/domain/use_cases/message/group_message/delete_message.dart';

part 'message_for_group_chat_state.dart';

class MessageForGroupChatCubit extends Cubit<MessageForGroupChatState> {
  final AddMessageForGroupChatUseCase _addMessageForGroupChatUseCase;
  final DeleteMessageForGroupChatUseCase _deleteMessageForGroupChatUseCase;
  MessageForGroupChatCubit(this._addMessageForGroupChatUseCase,
      this._deleteMessageForGroupChatUseCase)
      : super(MessageForGroupChatInitial());

  late Message lastMessage;

  static MessageForGroupChatCubit get(BuildContext context) =>
      BlocProvider.of(context);

  static Message getLastMessage(BuildContext context) =>
      BlocProvider.of<MessageForGroupChatCubit>(context).lastMessage;

  Future<void> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      File? recordFile}) async {
    emit(MessageForGroupChatLoading());
    await _addMessageForGroupChatUseCase
        .call(
            paramsOne: messageInfo,
            paramsTwo: pathOfPhoto,
            paramsThree: recordFile)
        .then((messageInfo) {
      lastMessage = messageInfo;
      emit(MessageForGroupChatLoaded(messageInfo));
    }).catchError((e) {
      emit(MessageForGroupChatFailed(e.toString()));
    });
  }

  Future<void> deleteMessage({
    required Message messageInfo,
    required String chatOfGroupUid,
    Message? replacedMessage,
  }) async {
    emit(DeleteMessageForGroupChatLoading());
    await _deleteMessageForGroupChatUseCase
        .call(
            paramsOne: chatOfGroupUid,
            paramsTwo: messageInfo,
            paramsThree: replacedMessage)
        .then((_) {
      emit(DeleteMessageForGroupChatLoaded());
    }).catchError((e) {
      emit(MessageForGroupChatFailed(e.toString()));
    });
  }
}

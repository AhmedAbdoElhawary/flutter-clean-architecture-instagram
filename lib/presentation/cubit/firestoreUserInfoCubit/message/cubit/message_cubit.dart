import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/domain/use_cases/user/message/add_message.dart';
import 'package:instagram/domain/use_cases/user/message/delete_message.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final AddMessageUseCase _addMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  List<Message> messagesInfo = [];
  MessageCubit(this._addMessageUseCase, this._deleteMessageUseCase)
      : super(MessageInitial());

  static MessageCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> sendMessage(
      {required Message messageInfo,
      String pathOfPhoto = "",
      String pathOfRecorded = ""}) async {
    emit(SendMessageLoading());
    await _addMessageUseCase
        .call(
            paramsOne: messageInfo,
            paramsTwo: pathOfPhoto,
            paramsThree: pathOfRecorded)
        .then((messageInfo) {
      emit(SendMessageLoaded(messageInfo));
    }).catchError((e) {
      emit(SendMessageFailed(e.toString()));
    });
  }

  Future<void> deleteMessage(
      {required Message messageInfo, Message? replacedMessage}) async {
    emit(DeleteMessageLoading());
    await _deleteMessageUseCase
        .call(paramsOne: messageInfo, paramsTwo: replacedMessage!)
        .then((_) {
      emit(DeleteMessageLoaded());
    }).catchError((e) {
      emit(SendMessageFailed(e.toString()));
    });
  }
}

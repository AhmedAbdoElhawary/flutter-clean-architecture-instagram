import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/domain/use_cases/message/group_message/get_messages.dart';
import 'package:instagram/domain/use_cases/message/single_message/get_messages.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageBlocState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final GetMessagesGroGroupChatUseCase _getMessagesGroGroupChatUseCase;

  MessageBloc(this._getMessagesUseCase, this._getMessagesGroGroupChatUseCase)
      : super(MessageBlocInitial()) {
    on<LoadMessagesForSingleChat>(_onLoadMessagesForSingleChat);
    on<UpdateMessages>(_onUpdateMessages);
    on<LoadMessagesForGroupChat>(_onLoadMessagesForGroupChat);
    on<UpdateMessagesForGroup>(_onUpdateMessagesForGroup);
  }

  static MessageBloc get(BuildContext context) => BlocProvider.of(context);

  Future<void> _onLoadMessagesForSingleChat(
    LoadMessagesForSingleChat event,
    Emitter<MessageBlocState> emit,
  ) async {
    await emit.forEach<List<Message>>(
      _getMessagesUseCase.call(params: event.receiverId),
      onData: (messages) => MessageBlocLoaded(messages: messages),
    );
  }

  void _onUpdateMessages(
    UpdateMessages event,
    Emitter<MessageBlocState> emit,
  ) {
    emit(MessageBlocLoaded(messages: event.messages));
  }

  Future<void> _onLoadMessagesForGroupChat(
    LoadMessagesForGroupChat event,
    Emitter<MessageBlocState> emit,
  ) async {
    await emit.forEach<List<Message>>(
      _getMessagesGroGroupChatUseCase.call(params: event.groupChatUid),
      onData: (messages) => MessageBlocLoaded(messages: messages),
    );
  }

  void _onUpdateMessagesForGroup(
    UpdateMessagesForGroup event,
    Emitter<MessageBlocState> emit,
  ) {
    emit(MessageBlocLoaded(messages: event.messages));
  }
}

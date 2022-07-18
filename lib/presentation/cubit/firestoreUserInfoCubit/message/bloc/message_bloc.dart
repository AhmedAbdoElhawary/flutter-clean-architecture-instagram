import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/domain/use_cases/user/message/get_messages.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageBlocState> {
  final GetMessagesUseCase _getMessagesUseCase;
  MessageBloc(this._getMessagesUseCase) : super(const MessageBlocLoaded());

  @override
  Stream<MessageBlocState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is LoadMessages) {
      yield* _mapLoadMessagesToState(event.receiverId);
    } else if (event is UpdateMessages) {
      yield* _mapUpdateMessagesToState(event);
    }
  }

  static MessageBloc get(BuildContext context) => BlocProvider.of(context);

  Stream<MessageBlocState> _mapLoadMessagesToState(String receiverId) async* {
    _getMessagesUseCase.call(params: receiverId).listen(
      (messages) {
        add(UpdateMessages(messages));
      },
    );
  }

  Stream<MessageBlocState> _mapUpdateMessagesToState(
      UpdateMessages event) async* {
    yield MessageBlocLoaded(messages: event.messages);
  }

}

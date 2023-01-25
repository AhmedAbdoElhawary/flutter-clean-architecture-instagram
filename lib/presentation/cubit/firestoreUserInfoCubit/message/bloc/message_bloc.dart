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
      : super(MessageBlocInitial());

  @override
  Stream<MessageBlocState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is LoadMessagesForSingleChat) {
      yield* _mapLoadMessagesToState(event.receiverId);
    } else if (event is UpdateMessages) {
      yield* _mapUpdateMessagesToState(event);
    }
    if (event is LoadMessagesForGroupChat) {
      yield* _mapLoadMessagesForGroupToState(event.groupChatUid);
    } else if (event is UpdateMessagesForGroup) {
      yield* _mapUpdateMessagesForGroupToState(event);
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

  Stream<MessageBlocState> _mapLoadMessagesForGroupToState(
      String groupChatUid) async* {
    _getMessagesGroGroupChatUseCase.call(params: groupChatUid).listen(
      (messages) {
        add(UpdateMessagesForGroup(messages));
      },
    );
  }

  Stream<MessageBlocState> _mapUpdateMessagesForGroupToState(
      UpdateMessagesForGroup event) async* {
    yield MessageBlocLoaded(messages: event.messages);
  }
}

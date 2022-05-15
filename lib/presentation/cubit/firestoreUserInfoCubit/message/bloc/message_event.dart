part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends MessageEvent {
  final String receiverId;

  const LoadMessages(this.receiverId);
  @override
  List<Object> get props => [receiverId];
}

class UpdateMessages extends MessageEvent {
  final List<Message> messages;

  const UpdateMessages(this.messages);
  @override
  List<Object> get props => [messages];
}

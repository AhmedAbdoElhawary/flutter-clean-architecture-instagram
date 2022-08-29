part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessagesForSingleChat extends MessageEvent {
  final String receiverId;

  const LoadMessagesForSingleChat(this.receiverId);
  @override
  List<Object> get props => [receiverId];
}

class LoadMessagesForGroupChat extends MessageEvent {
  final String groupChatUid;

  const LoadMessagesForGroupChat({required this.groupChatUid});
  @override
  List<Object> get props => [groupChatUid];
}

class UpdateMessagesForGroup extends MessageEvent {
  final List<Message> messages;

  const UpdateMessagesForGroup(this.messages);
  @override
  List<Object> get props => [messages];
}

class UpdateMessages extends MessageEvent {
  final List<Message> messages;

  const UpdateMessages(this.messages);
  @override
  List<Object> get props => [messages];
}

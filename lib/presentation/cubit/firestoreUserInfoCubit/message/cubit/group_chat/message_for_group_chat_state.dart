part of 'message_for_group_chat_cubit.dart';

abstract class MessageForGroupChatState extends Equatable {
  const MessageForGroupChatState();

  @override
  List<Object> get props => [];
}

class MessageForGroupChatInitial extends MessageForGroupChatState {}

class MessageForGroupChatLoading extends MessageForGroupChatState {}

class DeleteMessageForGroupChatLoading extends MessageForGroupChatState {}

class DeleteMessageForGroupChatLoaded extends MessageForGroupChatState {}

class MessageForGroupChatLoaded extends MessageForGroupChatState {
  final Message messageInfo;

  const MessageForGroupChatLoaded(this.messageInfo);
  @override
  List<Object> get props => [messageInfo];
}

class MessageForGroupChatFailed extends MessageForGroupChatState {
  final String error;

  const MessageForGroupChatFailed(this.error);
  @override
  List<Object> get props => [error];
}

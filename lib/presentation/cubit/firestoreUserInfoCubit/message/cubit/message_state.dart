part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class SendMessageLoaded extends MessageState {
  final Message messageInfo;

  const SendMessageLoaded(this.messageInfo);
  @override
  List<Object> get props => [messageInfo];
}

class CreatingChatForGroupLoading extends MessageState {}

class CreatingChatForGroupLoaded extends MessageState {
  final Message messageInfo;

  const CreatingChatForGroupLoaded(this.messageInfo);
  @override
  List<Object> get props => [messageInfo];
}

class GetSpecificChatLoading extends MessageState {}

class GetSpecificChatLoaded extends MessageState {
  final SenderInfo coverMessageDetails;

  const GetSpecificChatLoaded(this.coverMessageDetails);
  @override
  List<Object> get props => [coverMessageDetails];
}

class SendMessageLoading extends MessageState {}

class DeleteMessageLoading extends MessageState {}

class DeleteMessageLoaded extends MessageState {}

class SendMessageFailed extends MessageState {
  final String error;
  const SendMessageFailed(this.error);
}

class CreatingChatFailed extends MessageState {
  final String error;
  const CreatingChatFailed(this.error);
}

class GetMessageSuccess extends MessageState {}

class GetMessageFailed extends MessageState {
  final String error;
  const GetMessageFailed(this.error);
}

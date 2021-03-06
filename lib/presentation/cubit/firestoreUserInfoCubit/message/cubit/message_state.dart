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
}

class SendMessageLoading extends MessageState {}

class DeleteMessageLoading extends MessageState {}

class DeleteMessageLoaded extends MessageState {}

class SendMessageFailed extends MessageState {
  final String error;
  const SendMessageFailed(this.error);
}

class GetMessageSuccess extends MessageState {}

class GetMessageFailed extends MessageState {
  final String error;
  const GetMessageFailed(this.error);
}

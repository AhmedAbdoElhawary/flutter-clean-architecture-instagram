part of 'message_bloc.dart';

abstract class MessageBlocState extends Equatable {
  const MessageBlocState();

  @override
  List<Object> get props => [];
}

class MessageBlocInitial extends MessageBlocState {}

class MessageBlocLoaded extends MessageBlocState {
  final List<Message> messages;

  const MessageBlocLoaded({this.messages = const <Message>[]});
  @override
  List<Object> get props => [messages];
}

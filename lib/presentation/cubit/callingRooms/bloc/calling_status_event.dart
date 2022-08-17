part of 'calling_status_bloc.dart';

abstract class CallingStatusEvent extends Equatable {
  const CallingStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadCallingStatus extends CallingStatusEvent {
  final String userIAmCalling;

  const LoadCallingStatus(this.userIAmCalling);
  @override
  List<Object> get props => [userIAmCalling];
}

class UpdateCallingStatus extends CallingStatusEvent {
  final bool callingStatus;

  const UpdateCallingStatus(this.callingStatus);
  @override
  List<Object> get props => [callingStatus];
}

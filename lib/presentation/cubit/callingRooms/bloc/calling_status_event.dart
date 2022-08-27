part of 'calling_status_bloc.dart';

abstract class CallingStatusEvent extends Equatable {
  const CallingStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadCallingStatus extends CallingStatusEvent {
  final String channelUid;

  const LoadCallingStatus(this.channelUid);
  @override
  List<Object> get props => [channelUid];
}

class UpdateCallingStatus extends CallingStatusEvent {
  final bool callingStatus;

  const UpdateCallingStatus(this.callingStatus);
  @override
  List<Object> get props => [callingStatus];
}

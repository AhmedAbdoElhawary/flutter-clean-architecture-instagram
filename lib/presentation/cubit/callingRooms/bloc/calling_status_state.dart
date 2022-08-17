part of 'calling_status_bloc.dart';

abstract class CallingStatusState extends Equatable {
  const CallingStatusState();

  @override
  List<Object> get props => [];
}

class CallingStatusInitial extends CallingStatusState {}

class CallingStatusLoaded extends CallingStatusState {
  final bool callingStatus;

  const CallingStatusLoaded({required this.callingStatus});
  @override
  List<Object> get props => [callingStatus];
}

class CallingStatusFailed extends CallingStatusState {
  final String error;
  const CallingStatusFailed(this.error);
  @override
  List<Object> get props => [error];
}

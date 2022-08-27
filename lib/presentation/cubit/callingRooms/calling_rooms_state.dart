part of 'calling_rooms_cubit.dart';

abstract class CallingRoomsState extends Equatable {
  const CallingRoomsState();

  @override
  List<Object> get props => [];
}

class CallingRoomsInitial extends CallingRoomsState {}

class CallingRoomsLoading extends CallingRoomsState {}

class UsersInfoInRoomLoaded extends CallingRoomsState {
  final List<UsersInfoInCallingRoom> usersInfo;

  const UsersInfoInRoomLoaded({required this.usersInfo});
  @override
  List<Object> get props => [usersInfo];
}

class CallingRoomsLoaded extends CallingRoomsState {
  final String channelId;

  const CallingRoomsLoaded({required this.channelId});
  @override
  List<Object> get props => [channelId];
}

class CallingRoomsFailed extends CallingRoomsState {
  final String error;
  const CallingRoomsFailed(this.error);
  @override
  List<Object> get props => [error];
}

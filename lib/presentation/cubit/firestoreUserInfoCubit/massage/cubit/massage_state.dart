part of 'massage_cubit.dart';

abstract class MassageState extends Equatable {
  const MassageState();

  @override
  List<Object> get props => [];
}

class MassageInitial extends MassageState {}

class SendMassageLoaded extends MassageState {
  final Massage massageInfo;

  const SendMassageLoaded(this.massageInfo);
}

class SendMassageLoading extends MassageState {}

class DeleteMassageLoading extends MassageState {}

class DeleteMassageLoaded extends MassageState {}

class SendMassageFailed extends MassageState {
  final String error;
  const SendMassageFailed(this.error);
}

class GetMassageSuccess extends MassageState {}

class GetMassageFailed extends MassageState {
  final String error;
  const GetMassageFailed(this.error);
}

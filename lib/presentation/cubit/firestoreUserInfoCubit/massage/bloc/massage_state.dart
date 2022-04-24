part of 'massage_bloc.dart';

abstract class MassageBlocState extends Equatable {
  const MassageBlocState();

  @override
  List<Object> get props => [];
}

class MassageBlocInitial extends MassageBlocState {}

class MassageBlocLoading extends MassageBlocState {}

class MassageBlocLoaded extends MassageBlocState {
  final List<Massage> massages;

  const MassageBlocLoaded({this.massages = const <Massage>[]});
  @override
  List<Object> get props => [massages];
}

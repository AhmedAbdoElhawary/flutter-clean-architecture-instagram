part of 'massage_bloc.dart';

abstract class MassageEvent extends Equatable {
  const MassageEvent();

  @override
  List<Object> get props => [];
}

class LoadMassages extends MassageEvent {
  final String receiverId;

  const LoadMassages(this.receiverId);
  @override
  List<Object> get props => [receiverId];
}

class UpdateMassages extends MassageEvent {
  final List<Massage> massages;

  const UpdateMassages(this.massages);
  @override
  List<Object> get props => [massages];
}

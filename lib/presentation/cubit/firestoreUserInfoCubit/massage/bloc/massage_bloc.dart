import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/domain/usecases/firestoreUserUseCase/massage/get_massages.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/cubit/massage_cubit.dart';

part 'massage_event.dart';
part 'massage_state.dart';

class MassageBloc extends Bloc<MassageEvent, MassageBlocState> {
  final GetMassagesUseCase _getMassagesUseCase;
  MassageBloc(this._getMassagesUseCase) : super(const MassageBlocLoaded());

  @override
  Stream<MassageBlocState> mapEventToState(
    MassageEvent event,
  ) async* {
    if (event is LoadMassages) {
      yield* _mapLoadMassagesToState(event.receiverId);
    } else if (event is UpdateMassages) {
      yield* _mapUpdateMassagesToState(event);
    }
  }

  static MassageCubit get(BuildContext context) => BlocProvider.of(context);

  Stream<MassageBlocState> _mapLoadMassagesToState(String receiverId) async* {
    _getMassagesUseCase.call(params: receiverId).listen(
          (massages) => add(
            UpdateMassages(massages),
          ),
        );
  }

  Stream<MassageBlocState> _mapUpdateMassagesToState(UpdateMassages event) async* {
    yield MassageBlocLoaded(massages: event.massages);
  }
}

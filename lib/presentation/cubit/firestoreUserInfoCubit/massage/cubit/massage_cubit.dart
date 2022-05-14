import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/massage.dart';
import 'package:instagram/domain/use_cases/user/massage/add_massage.dart';
import 'package:instagram/domain/use_cases/user/massage/delete_massage.dart';

part 'massage_state.dart';

class MassageCubit extends Cubit<MassageState> {
  final AddMassageUseCase _addMassageUseCase;
  final DeleteMassageUseCase _deleteMassageUseCase;
  List<Massage> massagesInfo = [];
  MassageCubit(this._addMassageUseCase, this._deleteMassageUseCase)
      : super(MassageInitial());

  static MassageCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> sendMassage(
      {required Massage massageInfo,
      String pathOfPhoto = "",
      String pathOfRecorded = ""}) async {
    emit(SendMassageLoading());
    await _addMassageUseCase
        .call(
            paramsOne: massageInfo,
            paramsTwo: pathOfPhoto,
            paramsThree: pathOfRecorded)
        .then((massageInfo) {
      emit(SendMassageLoaded(massageInfo));
    }).catchError((e) {
      emit(SendMassageFailed(e.toString()));
    });
  }

  Future<void> deleteMassage({required Massage massageInfo}) async {
    emit(DeleteMassageLoading());
    await _deleteMassageUseCase.call(params: massageInfo).then((_) {
      emit(DeleteMassageLoaded());
    }).catchError((e) {
      emit(SendMassageFailed(e.toString()));
    });
  }
}

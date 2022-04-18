import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/domain/usecases/firestoreUserUseCase/massage/add_massage.dart';
import 'package:instegram/domain/usecases/firestoreUserUseCase/massage/get_massages.dart';

part 'massage_state.dart';

class MassageCubit extends Cubit<MassageState> {
  final AddMassageUseCase _addMassageUseCase;
  final GetMassagesUseCase _getMassagesUseCase;
  List<Massage> massagesInfo = [];
  MassageCubit(this._addMassageUseCase, this._getMassagesUseCase)
      : super(MassageInitial());

  static MassageCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> sendMassage({required Massage massageInfo,required String pathOfPhoto}) async {
    emit(SendMassageLoading());
    await _addMassageUseCase.call(paramsOne: massageInfo,paramsTwo: pathOfPhoto).then((massageInfo) {
      emit(SendMassageLoaded(massageInfo));
    }).catchError((e) {
      emit(SendMassageFailed(e.toString()));
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMassages(String receiverId) async* {
   yield* _getMassagesUseCase.call(params: receiverId);
  }
}

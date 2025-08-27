import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/domain/use_cases/calling_rooms/get_calling_status.dart';

part 'calling_status_event.dart';
part 'calling_status_state.dart';

class CallingStatusBloc extends Bloc<CallingStatusEvent, CallingStatusState> {
  final GetCallingStatusUseCase _getCallingStatusUseCase;

  CallingStatusBloc(this._getCallingStatusUseCase) : super(CallingStatusInitial()) {
    on<LoadCallingStatus>(_onLoadCallingStatus);
    on<UpdateCallingStatus>(_onUpdateCallingStatus);
  }

  static CallingStatusBloc get(BuildContext context) => BlocProvider.of(context);

  Future<void> _onLoadCallingStatus(
    LoadCallingStatus event,
    Emitter<CallingStatusState> emit,
  ) async {
    await emit.forEach<bool>(
      _getCallingStatusUseCase.call(params: event.channelUid),
      onData: (isHeOnLine) {
        // also dispatch UpdateCallingStatus event to keep two-step flow
        add(UpdateCallingStatus(isHeOnLine));
        return CallingStatusLoaded(callingStatus: isHeOnLine);
      },
      onError: (e, _) => CallingStatusFailed(e.toString()),
    );
  }

  void _onUpdateCallingStatus(
    UpdateCallingStatus event,
    Emitter<CallingStatusState> emit,
  ) {
    emit(CallingStatusLoaded(callingStatus: event.callingStatus));
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/domain/use_cases/calling_rooms/get_calling_status.dart';

part 'calling_status_event.dart';
part 'calling_status_state.dart';

class CallingStatusBloc extends Bloc<CallingStatusEvent, CallingStatusState> {
  final GetCallingStatusUseCase _getCallingStatusUseCase;

  CallingStatusBloc(this._getCallingStatusUseCase)
      : super(CallingStatusInitial());

  static CallingStatusBloc get(BuildContext context) =>
      BlocProvider.of(context);

  @override
  Stream<CallingStatusState> mapEventToState(
    CallingStatusEvent event,
  ) async* {
    if (event is LoadCallingStatus) {
      yield* _mapLoadInfoToState(event.channelUid);
    } else if (event is UpdateCallingStatus) {
      yield* _mapUpdateInfoToState(event);
    }
  }

  Stream<CallingStatusState> _mapLoadInfoToState(String channelUid) async* {
    _getCallingStatusUseCase.call(params: channelUid).listen(
      (isHeOnLine) {
        add(UpdateCallingStatus(isHeOnLine));
      },
    ).onError((e) async* {
      yield CallingStatusFailed(e.toString());
    });
  }

  Stream<CallingStatusState> _mapUpdateInfoToState(
      UpdateCallingStatus event) async* {
    yield CallingStatusLoaded(callingStatus: event.callingStatus);
  }
}

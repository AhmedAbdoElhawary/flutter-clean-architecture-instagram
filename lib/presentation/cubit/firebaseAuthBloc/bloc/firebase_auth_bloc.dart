import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instegram/core/bloc/bloc_with_state.dart';
import 'package:instegram/core/resources/data_state.dart';
import 'package:instegram/domain/entities/registered_user.dart';
import 'package:instegram/domain/entities/unregistered_user.dart';
import 'package:instegram/domain/usecases/authUseCase/log_in_auth_usecase.dart';
import 'package:instegram/domain/usecases/authUseCase/sign_out_auth_usecase.dart';
import 'dart:async';

import 'package:instegram/domain/usecases/authUseCase/sign_up_auth_usecase.dart';
part 'firebase_auth_event.dart';
part 'firebase_auth_state.dart';

class FirebaseAuthBloc
    extends BlocWithState<FirebaseAuthEvent, FirebaseAuthState> {
  final SignUpAuthUseCase signUpAuthUseCase;
  final LogInAuthUseCase logInAuthUseCase;
  final SignOutAuthUseCase signOutAuthUseCase;
  User? user;
  FirebaseAuthBloc(
      this.signUpAuthUseCase, this.logInAuthUseCase, this.signOutAuthUseCase)
      : super(AuthInitial()) {
    print('on method');
    on<SignUpEvent> (signUp);
    on<LogInEvent>(logIn);
    on<SignOutEvent>(signOut);
  }

  // @override
  // Stream<FirebaseAuthState> mapEventToState(FirebaseAuthEvent event) async* {
  //   if (event is SignUpEvent) yield* signUp(event.newUserInfo);
  //   if (event is LogInEvent) yield* logIn(event.userInfo);
  //   if (event is SignOutEvent) yield* signOut();
  // }

  Stream<FirebaseAuthState> signUp(
      SignUpEvent event, Emitter<FirebaseAuthState> emit) async* {
    yield* runBlocProcess(() async* {
      final dataState = await signUpAuthUseCase(params: event.newUserInfo);
      if (dataState is DataSuccess && dataState.data!.uid.isNotEmpty) {
        user = dataState.data!;
        emit(AuthConfirmed(dataState.data!));
        yield AuthConfirmed(dataState.data!);
      }
      if (dataState is DataFailed) {
        emit(AuthFailed(dataState.error.toString()));
        yield AuthFailed(dataState.error.toString());
      }
    });
  }
  Future<void> logIn(LogInEvent event, Emitter<FirebaseAuthState> emit) async {
    emit(AuthConfirming());
    final dataState =await logInAuthUseCase(params:event. userInfo);
      if(dataState is DataSuccess){
        emit(AuthConfirmed(dataState.data!));
      }
      if(dataState is DataFailed) {
        emit(AuthFailed(dataState.error!));
      }
  }
  //
  // Stream<FirebaseAuthState> logIn(
  //     LogInEvent event, Emitter<FirebaseAuthState> emit) async* {
  //   print('on stream ');
  //
  //   yield* runBlocProcess(() async* {
  //     print('on stream 2');
  //
  //     final dataState = await logInAuthUseCase(params: event.userInfo);
  //     if (dataState is DataSuccess && dataState.data!.uid.isNotEmpty) {
  //       user = dataState.data!;
  //       print('on stream 3');
  //
  //       emit(AuthConfirmed(dataState.data!));
  //       yield AuthConfirmed(dataState.data!);
  //     }
  //     if (dataState is DataFailed) {
  //       emit(AuthFailed(dataState.error.toString()));
  //       yield AuthFailed(dataState.error.toString());
  //     }
  //   });
  // }

  Stream<FirebaseAuthState> signOut(SignOutEvent event,Emitter<FirebaseAuthState> emit) async* {
    yield* runBlocProcess(() async* {
      final dataState = await signOutAuthUseCase.call(params: null);
      if (dataState is DataSuccess) {
        emit(AuthSignOut());
        yield AuthSignOut();
      }
      if (dataState is DataFailed) {
        emit(AuthFailed(dataState.error.toString()));

        yield AuthFailed(dataState.error.toString());
      }
    });
  }

  @override
  void onChange(Change<FirebaseAuthState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<FirebaseAuthEvent, FirebaseAuthState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}

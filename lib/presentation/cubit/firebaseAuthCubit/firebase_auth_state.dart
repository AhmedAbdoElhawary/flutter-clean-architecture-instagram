part of '../firebaseAuthCubit/firebase_auth_cubit.dart';

abstract class FirebaseAuthCubitState {}

class CubitInitial extends FirebaseAuthCubitState {}

class CubitAuthConfirming extends FirebaseAuthCubitState {}

class CubitAuthConfirmed extends FirebaseAuthCubitState {
  final User user;

  CubitAuthConfirmed(this.user);
}

class CubitAuthSignOut extends FirebaseAuthCubitState {}

class CubitAuthFailed extends FirebaseAuthCubitState {
  final String error;
  CubitAuthFailed(this.error);
}

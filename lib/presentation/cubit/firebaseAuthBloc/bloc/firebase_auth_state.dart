part of 'firebase_auth_bloc.dart';

abstract class FirebaseAuthState extends Equatable {
  const FirebaseAuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends FirebaseAuthState {}

class AuthConfirming extends FirebaseAuthState {}

class AuthConfirmed extends FirebaseAuthState {
  final User user;
  const AuthConfirmed(this.user);

  @override
  List<Object> get props => [user];
}

class AuthSignOut extends FirebaseAuthState {}

class AuthFailed extends FirebaseAuthState {
  final String error;
  const AuthFailed(this.error);
  @override
  List<Object> get props => [error];
}

part of 'firebase_auth_bloc.dart';

abstract class FirebaseAuthEvent extends Equatable {
  const FirebaseAuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends FirebaseAuthEvent {
  final UnRegisteredUser newUserInfo;
  const SignUpEvent(this.newUserInfo);
  @override
  List<Object> get props => [newUserInfo];
}

class LogInEvent extends FirebaseAuthEvent {
  final RegisteredUser userInfo;
  const LogInEvent(this.userInfo);
  @override
  List<Object> get props => [userInfo];
}

class SignOutEvent extends FirebaseAuthEvent {}

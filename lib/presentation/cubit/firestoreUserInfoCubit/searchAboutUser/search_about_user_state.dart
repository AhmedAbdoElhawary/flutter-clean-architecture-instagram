part of 'search_about_user_bloc.dart';

abstract class SearchAboutUserState extends Equatable {
  const SearchAboutUserState();

  @override
  List<Object> get props => [];
}

class SearchAboutUserInitial extends SearchAboutUserState {}

class SearchAboutUserBlocLoading extends SearchAboutUserState {}

class SearchAboutUserBlocLoaded extends SearchAboutUserState {
  final List<UserPersonalInfo> users;

  const SearchAboutUserBlocLoaded({this.users = const <UserPersonalInfo>[]});
  @override
  List<Object> get props => [users];
}

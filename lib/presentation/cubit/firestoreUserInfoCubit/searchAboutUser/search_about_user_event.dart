part of 'search_about_user_bloc.dart';

abstract class SearchAboutUserEvent extends Equatable {
  const SearchAboutUserEvent();

  @override
  List<Object> get props => [];
}

class FindSpecificUser extends SearchAboutUserEvent {
  final String name;
  final bool searchForSingleLetter;
  const FindSpecificUser(this.name, {this.searchForSingleLetter = false});
  @override
  List<Object> get props => [name];
}

class UpdateUser extends SearchAboutUserEvent {
  final List<UserPersonalInfo> users;

  const UpdateUser(this.users);
  @override
  List<Object> get props => [users];
}

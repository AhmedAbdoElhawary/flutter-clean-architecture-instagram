import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/use_cases/user/search_about_user.dart';

part 'search_about_user_event.dart';
part 'search_about_user_state.dart';

class SearchAboutUserBloc
    extends Bloc<SearchAboutUserEvent, SearchAboutUserState> {
  final SearchAboutUserUseCase _searchAboutUserUseCase;
  SearchAboutUserBloc(this._searchAboutUserUseCase)
      : super(SearchAboutUserInitial());

  @override
  Stream<SearchAboutUserState> mapEventToState(
    SearchAboutUserEvent event,
  ) async* {
    if (event is FindSpecificUser) {
      yield* _mapLoadSearchToState(event.name, event.searchForSingleLetter);
    } else if (event is UpdateUser) {
      yield* _mapUpdateSearchToState(event);
    }
  }

  static SearchAboutUserBloc get(BuildContext context) =>
      BlocProvider.of(context);

  Stream<SearchAboutUserState> _mapLoadSearchToState(
      String receiverId, bool searchForSingleLetter) async* {
    _searchAboutUserUseCase
        .call(paramsOne: receiverId, paramsTwo: searchForSingleLetter)
        .listen((users) => add(UpdateUser(users)));
  }

  Stream<SearchAboutUserState> _mapUpdateSearchToState(
      UpdateUser event) async* {
    yield SearchAboutUserBlocLoaded(users: event.users);
  }
}

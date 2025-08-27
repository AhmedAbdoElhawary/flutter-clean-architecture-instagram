import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/use_cases/user/search_about_user.dart';

part 'search_about_user_event.dart';
part 'search_about_user_state.dart';

class SearchAboutUserBloc extends Bloc<SearchAboutUserEvent, SearchAboutUserState> {
  final SearchAboutUserUseCase _searchAboutUserUseCase;

  SearchAboutUserBloc(this._searchAboutUserUseCase) : super(SearchAboutUserInitial()) {
    on<FindSpecificUser>(_onFindSpecificUser);
    on<UpdateUser>(_onUpdateUser);
  }

  static SearchAboutUserBloc get(BuildContext context) => BlocProvider.of(context);

  Future<void> _onFindSpecificUser(
    FindSpecificUser event,
    Emitter<SearchAboutUserState> emit,
  ) async {
    await emit.forEach<List<UserPersonalInfo>>(
      _searchAboutUserUseCase.call(
        paramsOne: event.name,
        paramsTwo: event.searchForSingleLetter,
      ),
      onData: (users) {
        // still keep two-step flow (UpdateUser event) if you want consistency
        add(UpdateUser(users));
        return SearchAboutUserBlocLoaded(users: users);
      },
    );
  }

  void _onUpdateUser(
    UpdateUser event,
    Emitter<SearchAboutUserState> emit,
  ) {
    emit(SearchAboutUserBlocLoaded(users: event.users));
  }
}

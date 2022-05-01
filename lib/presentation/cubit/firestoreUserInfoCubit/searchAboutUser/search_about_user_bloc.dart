import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_about_user_event.dart';
part 'search_about_user_state.dart';

class SearchAboutUserBloc extends Bloc<SearchAboutUserEvent, SearchAboutUserState> {
  SearchAboutUserBloc() : super(SearchAboutUserInitial()) {
    on<SearchAboutUserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

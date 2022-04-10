import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/domain/usecases/postUseCase/get_specific_users_posts.dart';

part 'specific_users_posts_state.dart';

class SpecificUsersPostsCubit extends Cubit<SpecificUsersPostsState> {
  GetSpecificUsersPostsUseCase getSpecificUsersPostsUseCase;
  SpecificUsersPostsCubit(this.getSpecificUsersPostsUseCase)
      : super(SpecificUsersPostsInitial());

  static SpecificUsersPostsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<List> getSpecificUsersPostsInfo(
      {required List<dynamic> usersIds}) async {
    List usersPostsInfo=[];
    emit(SpecificUsersPostsLoading());
    await getSpecificUsersPostsUseCase
        .call(params: usersIds)
        .then((specificPostsInfo) {
      usersPostsInfo=specificPostsInfo;
      emit(SpecificUsersPostsLoaded(specificPostsInfo));
    }).catchError((e) {
      emit(SpecificUsersPostsFailed(e.toString()));
    });
    return usersPostsInfo;
  }
}

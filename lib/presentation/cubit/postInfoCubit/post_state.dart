part of '../postInfoCubit/post_cubit.dart';

abstract class PostState {}

class CubitInitial extends PostState {}

class CubitPostLoading extends PostState {}

class CubitPostLoaded extends PostState {}

class CubitMyPostsInfoLoaded extends PostState {
  List<Post> postsInfo;

  CubitMyPostsInfoLoaded(this.postsInfo);
}
class CubitPostsInfoLoaded extends PostState {
  List<Post> postsInfo;

  CubitPostsInfoLoaded(this.postsInfo);
}
class CubitAllPostsLoaded extends PostState {
  List<Post> allPostInfo;
  CubitAllPostsLoaded(this.allPostInfo);
}

class CubitPostFailed extends PostState {
  final String error;
  CubitPostFailed(this.error);
}

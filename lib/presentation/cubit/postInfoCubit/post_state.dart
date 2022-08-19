part of '../postInfoCubit/post_cubit.dart';

abstract class PostState {}

class CubitInitial extends PostState {}

class CubitPostLoading extends PostState {}

class CubitUpdatePostLoading extends PostState {}

class CubitUpdatePostLoaded extends PostState {
  Post postUpdatedInfo;

  CubitUpdatePostLoaded(this.postUpdatedInfo);
}

class CubitDeletePostLoading extends PostState {}

class CubitDeletePostLoaded extends PostState {}

class CubitPostLoaded extends PostState {
  Post postInfo;

  CubitPostLoaded(this.postInfo);
}

class CubitMyPersonalPostsLoaded extends PostState {
  List<Post> postsInfo;

  CubitMyPersonalPostsLoaded(this.postsInfo);
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

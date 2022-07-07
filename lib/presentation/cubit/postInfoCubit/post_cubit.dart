import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/domain/use_cases/post/delete/delete_post.dart';
import 'package:instagram/domain/use_cases/post/get/get_all_posts.dart';
import 'package:instagram/domain/use_cases/post/get/get_post_info.dart';
import 'package:instagram/domain/use_cases/post/update/update_post.dart';
import '../../../domain/use_cases/post/create_post.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUseCase _createPostUseCase;
  final GetPostsInfoUseCase _getPostsInfoUseCase;
  final GetAllPostsInfoUseCase _getAllPostInfoUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  String postId = '';
  List<Post>? myPostsInfo;
  List<Post>? userPostsInfo;

  List<Post>? allPostsInfo;

  PostCubit(
      this._createPostUseCase,
      this._getPostsInfoUseCase,
      this._updatePostUseCase,
      this._deletePostUseCase,
      this._getAllPostInfoUseCase)
      : super(CubitPostLoading());

  static PostCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> createPost(Post postInfo, List<File> files) async {
    emit(CubitPostLoading());
    await _createPostUseCase
        .call(paramsOne: postInfo, paramsTwo: files)
        .then((postId) {
      this.postId = postId;
      emit(CubitPostLoaded(postId));
      return postId;
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
  }

  Future<void> getPostsInfo(
      {required List<dynamic> postsIds,
      required bool isThatMyPosts,
      int lengthOfCurrentList = -1}) async {
    emit(CubitPostLoading());
    await _getPostsInfoUseCase
        .call(
            paramsOne: postsIds,
            paramsTwo: lengthOfCurrentList)
        .then((postsInfo) {
      if (isThatMyPosts) {
        myPostsInfo = postsInfo;
        emit(CubitMyPersonalPostsLoaded(postsInfo));
      } else {
        userPostsInfo = postsInfo;
        emit(CubitPostsInfoLoaded(postsInfo));
      }
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
  }

  Future<void> getAllPostInfo() async {
    emit(CubitPostLoading());
    await _getAllPostInfoUseCase.call(params: null).then((allPostsInfo) {
      this.allPostsInfo = allPostsInfo;
      emit(CubitAllPostsLoaded(allPostsInfo));
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
  }

  Future<void> updatePostInfo({required Post postInfo}) async {
    emit(CubitUpdatePostLoading());
    await _updatePostUseCase.call(params: postInfo).then((postUpdatedInfo) {
      if (myPostsInfo != null) {
        int index = myPostsInfo!.indexOf(postInfo);
        myPostsInfo![index] = postUpdatedInfo;
        emit(CubitMyPersonalPostsLoaded(myPostsInfo!));
      }
      emit(CubitUpdatePostLoaded(postUpdatedInfo));
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
  }

  Future<void> deletePostInfo({required Post postInfo}) async {
    emit(CubitDeletePostLoading());
    await _deletePostUseCase.call(params: postInfo).then((_) {
      if (myPostsInfo != null) {
        myPostsInfo!
            .removeWhere((element) => element.postUid == postInfo.postUid);
        emit(CubitMyPersonalPostsLoaded(myPostsInfo!));
      }
      emit(CubitDeletePostLoaded());
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
  }
}

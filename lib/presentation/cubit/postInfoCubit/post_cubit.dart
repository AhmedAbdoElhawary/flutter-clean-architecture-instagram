import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/domain/usecases/postUseCase/get_all_posts.dart';
import 'package:instegram/domain/usecases/postUseCase/get_post_info.dart';
import '../../../domain/usecases/postUseCase/create_post.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUseCase _createPostUseCase;
  final GetPostsInfoUseCase _getPostsInfoUseCase;
  final GetAllPostsInfoUseCase _getAllPostInfoUseCase;
  String? postId;
  List<Post>? postsInfo;
  List<Post>? allPostsInfo;

  PostCubit(this._createPostUseCase,this._getPostsInfoUseCase,this._getAllPostInfoUseCase) : super(CubitPostLoading());

  static PostCubit get(BuildContext context) => BlocProvider.of(context);

  Future<String?> createPost(Post postInfo,Comment commentInfo, File photo) async {
    emit(CubitPostLoading());
    await _createPostUseCase.call(params: [postInfo,commentInfo, photo]).then((postId) {
      this.postId=postId;
      emit(CubitPostLoaded());
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
    return postId;
  }

  Future<List<Post>?> getPostInfo(List<dynamic> postIds) async {
    emit(CubitPostLoading());
    await _getPostsInfoUseCase.call(params:postIds).then((postsInfo) {
      this.postsInfo=postsInfo;
      emit(CubitPostsInfoLoaded(postsInfo));
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
    return postsInfo;
  }

  Future<List<Post>?> getAllPostInfo() async {
    // emit(CubitPostLoading());
    await _getAllPostInfoUseCase.call(params:null).then((allPostsInfo) {
      this.allPostsInfo=allPostsInfo;
      emit(CubitAllPostsLoaded(allPostsInfo));
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
    return postsInfo;
  }
}

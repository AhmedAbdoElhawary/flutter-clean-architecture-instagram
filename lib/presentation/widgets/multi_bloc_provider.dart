import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instegram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/bloc/massage_bloc.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/cubit/massage_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instegram/presentation/cubit/followCubit/follow_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comment_likes/comment_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/replyLikes/reply_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import '../../core/utility/injector.dart';
import '../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../cubit/postInfoCubit/post_cubit.dart';

// ignore: must_be_immutable
class MultiBloc extends StatelessWidget {
  Widget materialApp;

  MultiBloc(this.materialApp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<FirebaseAuthCubit>(
        create: (context) => injector<FirebaseAuthCubit>(),
      ),
      BlocProvider<FirestoreUserInfoCubit>(
        create: (context) => injector<FirestoreUserInfoCubit>(),
      ),
      BlocProvider<FirestoreAddNewUserCubit>(
        create: (context) => injector<FirestoreAddNewUserCubit>(),
      ),
      BlocProvider<PostCubit>(
        create: (context) => injector<PostCubit>()..getAllPostInfo(),
      ),
      BlocProvider<FollowCubit>(
        create: (context) => injector<FollowCubit>(),
      ),
      BlocProvider<UsersInfoCubit>(
        create: (context) => injector<UsersInfoCubit>(),
      ),
      BlocProvider<SpecificUsersPostsCubit>(
        create: (context) => injector<SpecificUsersPostsCubit>(),
      ),
      BlocProvider<PostLikesCubit>(
        create: (context) => injector<PostLikesCubit>(),
      ),
      BlocProvider<CommentsInfoCubit>(
        create: (context) => injector<CommentsInfoCubit>(),
      ),
      BlocProvider<CommentLikesCubit>(
        create: (context) => injector<CommentLikesCubit>(),
      ),
      BlocProvider<ReplyLikesCubit>(
        create: (context) => injector<ReplyLikesCubit>(),
      ),
      BlocProvider<ReplyInfoCubit>(
        create: (context) => injector<ReplyInfoCubit>(),
      ),
      BlocProvider<MassageCubit>(
        create: (context) => injector<MassageCubit>(),
      ),
      BlocProvider<MassageBloc>(
        create: (context) => injector<MassageBloc>(),
      ),
      BlocProvider<StoryCubit>(
        create: (context) => injector<StoryCubit>(),
      ),
      BlocProvider<SearchAboutUserBloc>(
        create: (context) => injector<SearchAboutUserBloc>(),
      ),
    ], child: materialApp);
  }
}

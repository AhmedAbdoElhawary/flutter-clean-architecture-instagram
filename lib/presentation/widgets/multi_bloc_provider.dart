import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/cubit/followCubit/follow_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comment_likes/comment_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/replyLikes/reply_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import '../../core/utility/injector.dart';
import '../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../cubit/postInfoCubit/post_cubit.dart';

// ignore: must_be_immutable
class MultiBlocs extends StatelessWidget {
  Widget materialApp;

  MultiBlocs(this.materialApp, {Key? key}) : super(key: key);

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
      BlocProvider<MessageCubit>(
        create: (context) => injector<MessageCubit>(),
      ),
      BlocProvider<MessageBloc>(
        create: (context) => injector<MessageBloc>(),
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

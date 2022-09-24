import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/cubit/callingRooms/bloc/calling_status_bloc.dart';
import 'package:instagram/presentation/cubit/callingRooms/calling_rooms_cubit.dart';
import 'package:instagram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/group_chat/message_for_group_chat_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:instagram/presentation/cubit/follow/follow_cubit.dart';
import 'package:instagram/presentation/cubit/notification/notification_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comment_likes/comment_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/replyLikes/reply_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import '../../../../core/utility/injector.dart';
import '../../../cubit/postInfoCubit/post_cubit.dart';

class MultiBlocs extends StatelessWidget {
  final Widget materialApp;

  const MultiBlocs(this.materialApp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<FirebaseAuthCubit>(
        create: (context) => injector<FirebaseAuthCubit>(),
      ),
      BlocProvider<UserInfoCubit>(
        create: (context) => injector<UserInfoCubit>(),
      ),
      BlocProvider<FireStoreAddNewUserCubit>(
        create: (context) => injector<FireStoreAddNewUserCubit>(),
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
      BlocProvider<NotificationCubit>(
        create: (context) => injector<NotificationCubit>(),
      ),
      BlocProvider<CallingRoomsCubit>(
        create: (context) => injector<CallingRoomsCubit>(),
      ),
      BlocProvider<CallingStatusBloc>(
        create: (context) => injector<CallingStatusBloc>(),
      ),
      BlocProvider<MessageForGroupChatCubit>(
        create: (context) => injector<MessageForGroupChatCubit>(),
      ),
      BlocProvider<UsersInfoReelTimeBloc>(
        create: (context1) {
          if (myPersonalId.isNotEmpty) {
            return injector<UsersInfoReelTimeBloc>()..add(LoadMyPersonalInfo());
          } else {
            return injector<UsersInfoReelTimeBloc>();
          }
        },
      ),
    ], child: materialApp);
  }
}

import 'package:get_it/get_it.dart';
import 'package:instagram/data/repositories_impl/calling_rooms_repo_impl.dart';
import 'package:instagram/data/repositories_impl/firebase_auth_repository_impl.dart';
import 'package:instagram/data/repositories_impl/firestore_notification.dart';
import 'package:instagram/data/repositories_impl/firestore_story_repo_impl.dart';
import 'package:instagram/data/repositories_impl/firestore_user_repo_impl.dart';
import 'package:instagram/data/repositories_impl/group_message_repo_impl.dart';
import 'package:instagram/data/repositories_impl/post/comment/firestore_comment_repo_impl.dart';
import 'package:instagram/data/repositories_impl/post/comment/firestore_reply_repo_impl.dart';
import 'package:instagram/data/repositories_impl/post/firestore_post_repo_impl.dart';
import 'package:instagram/domain/repositories/auth_repository.dart';
import 'package:instagram/domain/repositories/calling_rooms_repository.dart';
import 'package:instagram/domain/repositories/firestore_notification.dart';
import 'package:instagram/domain/repositories/group_message.dart';
import 'package:instagram/domain/repositories/post/comment/comment_repository.dart';
import 'package:instagram/domain/repositories/post/comment/reply_repository.dart';
import 'package:instagram/domain/repositories/post/post_repository.dart';
import 'package:instagram/domain/repositories/story_repository.dart';
import 'package:instagram/domain/repositories/user_repository.dart';
import 'package:instagram/domain/use_cases/auth/email_verification_usecase.dart';
import 'package:instagram/domain/use_cases/auth/log_in_auth_usecase.dart';
import 'package:instagram/domain/use_cases/auth/sign_out_auth_usecase.dart';
import 'package:instagram/domain/use_cases/auth/sign_up_auth_usecase.dart';
import 'package:instagram/domain/use_cases/calling_rooms/cancel_joining_to_room.dart';
import 'package:instagram/domain/use_cases/calling_rooms/create_calling_room.dart';
import 'package:instagram/domain/use_cases/calling_rooms/delete_the_room.dart';
import 'package:instagram/domain/use_cases/calling_rooms/get_calling_status.dart';
import 'package:instagram/domain/use_cases/calling_rooms/get_users_info_in_room.dart';
import 'package:instagram/domain/use_cases/calling_rooms/join_to_calling_room.dart';
import 'package:instagram/domain/use_cases/follow/follow_this_user.dart';
import 'package:instagram/domain/use_cases/follow/remove_this_follower.dart';
import 'package:instagram/domain/use_cases/message/common/get_specific_chat_info.dart';
import 'package:instagram/domain/use_cases/message/group_message/add_message.dart';
import 'package:instagram/domain/use_cases/message/group_message/delete_message.dart';
import 'package:instagram/domain/use_cases/message/group_message/get_messages.dart';
import 'package:instagram/domain/use_cases/message/single_message/add_message.dart';
import 'package:instagram/domain/use_cases/message/single_message/delete_message.dart';
import 'package:instagram/domain/use_cases/message/single_message/get_chat_users_info.dart';
import 'package:instagram/domain/use_cases/message/single_message/get_messages.dart';
import 'package:instagram/domain/use_cases/notification/create_notification_use_case.dart';
import 'package:instagram/domain/use_cases/notification/delete_notification.dart';
import 'package:instagram/domain/use_cases/notification/get_notifications_use_case.dart';
import 'package:instagram/domain/use_cases/post/comments/add_comment_use_case.dart';
import 'package:instagram/domain/use_cases/post/comments/getComment/get_all_comment.dart';
import 'package:instagram/domain/use_cases/post/comments/put_like.dart';
import 'package:instagram/domain/use_cases/post/comments/remove_like.dart';
import 'package:instagram/domain/use_cases/post/comments/replies/get_replies_of_this_comment.dart';
import 'package:instagram/domain/use_cases/post/comments/replies/likes/put_like_on_this_reply.dart';
import 'package:instagram/domain/use_cases/post/comments/replies/likes/remove_like_on_this_reply.dart';
import 'package:instagram/domain/use_cases/post/comments/replies/reply_on_this_comment.dart';
import 'package:instagram/domain/use_cases/post/create_post.dart';
import 'package:instagram/domain/use_cases/post/delete/delete_post.dart';
import 'package:instagram/domain/use_cases/post/get/get_all_posts.dart';
import 'package:instagram/domain/use_cases/post/get/get_post_info.dart';
import 'package:instagram/domain/use_cases/post/get/get_specific_users_posts.dart';
import 'package:instagram/domain/use_cases/post/likes/put_like_on_this_post.dart';
import 'package:instagram/domain/use_cases/post/likes/remove_the_like_on_this_post.dart';
import 'package:instagram/domain/use_cases/post/update/update_post.dart';
import 'package:instagram/domain/use_cases/story/create_story.dart';
import 'package:instagram/domain/use_cases/story/delete_story.dart';
import 'package:instagram/domain/use_cases/story/get_specific_stories.dart';
import 'package:instagram/domain/use_cases/story/get_stories_info.dart';
import 'package:instagram/domain/use_cases/user/add_new_user_usecase.dart';
import 'package:instagram/domain/use_cases/user/add_post_to_user.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_all_un_followers_info.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_all_users_info.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_followers_and_followings_usecase.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_specific_users_usecase.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_user_from_user_name.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_user_info_usecase.dart';
import 'package:instagram/domain/use_cases/user/my_personal_info.dart';
import 'package:instagram/domain/use_cases/user/search_about_user.dart';
import 'package:instagram/domain/use_cases/user/update_user_info.dart';
import 'package:instagram/domain/use_cases/user/upload_profile_image_usecase.dart';
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
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final injector = GetIt.I;

Future<void> initializeDependencies() async {
  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  injector.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Repository

  // Post
  injector.registerLazySingleton<FireStorePostRepository>(
    () => FireStorePostRepositoryImpl(),
  );
  // comment
  injector.registerLazySingleton<FirestoreCommentRepository>(
    () => FirestoreCommentRepositoryImpl(),
  );
  //reply

  injector.registerLazySingleton<FirestoreReplyRepository>(
    () => FireStoreRepliesRepositoryImpl(),
  );
  // *
  // *
  // *
  injector.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepositoryImpl(),
  );
  injector.registerLazySingleton<FirestoreUserRepository>(
    () => FirebaseUserRepoImpl(),
  );
  // story
  injector.registerLazySingleton<FirestoreStoryRepository>(
    () => FireStoreStoryRepositoryImpl(),
  );
  // notification
  injector.registerLazySingleton<FireStoreNotificationRepository>(
    () => FireStoreNotificationRepoImpl(),
  );
  // calling rooms repository
  injector.registerLazySingleton<CallingRoomsRepository>(
      () => CallingRoomsRepoImpl());

  injector.registerLazySingleton<FireStoreGroupMessageRepository>(
      () => FirebaseGroupMessageRepoImpl());

  // *
  /// ========================================================================>

  // Firebase auth useCases
  injector.registerLazySingleton<LogInAuthUseCase>(
      () => LogInAuthUseCase(injector()));

  injector.registerLazySingleton<SignUpAuthUseCase>(
      () => SignUpAuthUseCase(injector()));

  injector.registerLazySingleton<SignOutAuthUseCase>(
      () => SignOutAuthUseCase(injector()));

  injector.registerLazySingleton<EmailVerificationUseCase>(
      () => EmailVerificationUseCase(injector()));
  // *
  // FireStore user useCases
  injector.registerLazySingleton<AddNewUserUseCase>(
      () => AddNewUserUseCase(injector()));
  injector.registerLazySingleton<GetUserInfoUseCase>(
      () => GetUserInfoUseCase(injector()));

  injector.registerLazySingleton<GetFollowersAndFollowingsUseCase>(
      () => GetFollowersAndFollowingsUseCase(injector()));

  injector.registerLazySingleton<UpdateUserInfoUseCase>(
      () => UpdateUserInfoUseCase(injector()));

  injector.registerLazySingleton<UploadProfileImageUseCase>(
      () => UploadProfileImageUseCase(injector()));

  injector.registerLazySingleton<GetSpecificUsersUseCase>(
      () => GetSpecificUsersUseCase(injector()));

  injector.registerLazySingleton<AddPostToUserUseCase>(
      () => AddPostToUserUseCase(injector()));

  injector.registerLazySingleton<GetUserFromUserNameUseCase>(
      () => GetUserFromUserNameUseCase(injector()));
  injector.registerLazySingleton<GetAllUnFollowersUseCase>(
      () => GetAllUnFollowersUseCase(injector()));

  injector.registerLazySingleton<SearchAboutUserUseCase>(
      () => SearchAboutUserUseCase(injector()));

  injector.registerLazySingleton<GetChatUsersInfoAddMessageUseCase>(
      () => GetChatUsersInfoAddMessageUseCase(injector()));

  injector.registerLazySingleton<GetMyInfoUseCase>(
      () => GetMyInfoUseCase(injector()));

  // message use case
  injector.registerLazySingleton<AddMessageUseCase>(
      () => AddMessageUseCase(injector()));
  injector.registerLazySingleton<GetMessagesUseCase>(
      () => GetMessagesUseCase(injector()));
  injector.registerLazySingleton<DeleteMessageUseCase>(
      () => DeleteMessageUseCase(injector()));
  // *
  // *
  // FireStore Post useCases
  injector.registerLazySingleton<CreatePostUseCase>(
      () => CreatePostUseCase(injector()));
  injector.registerLazySingleton<GetPostsInfoUseCase>(
      () => GetPostsInfoUseCase(injector()));

  injector.registerLazySingleton<GetAllPostsInfoUseCase>(
      () => GetAllPostsInfoUseCase(injector()));

  injector.registerLazySingleton<GetSpecificUsersPostsUseCase>(
      () => GetSpecificUsersPostsUseCase(injector()));

  injector.registerLazySingleton<PutLikeOnThisPostUseCase>(
      () => PutLikeOnThisPostUseCase(injector()));

  injector.registerLazySingleton<RemoveTheLikeOnThisPostUseCase>(
      () => RemoveTheLikeOnThisPostUseCase(injector()));

  injector.registerLazySingleton<GetSpecificStoriesInfoUseCase>(
      () => GetSpecificStoriesInfoUseCase(injector()));

  injector.registerLazySingleton<DeletePostUseCase>(
      () => DeletePostUseCase(injector()));

  injector.registerLazySingleton<UpdatePostUseCase>(
      () => UpdatePostUseCase(injector()));
  //FireStore Comment UseCase
  injector.registerLazySingleton<GetSpecificCommentsUseCase>(
      () => GetSpecificCommentsUseCase(injector()));

  injector.registerLazySingleton<AddCommentUseCase>(
      () => AddCommentUseCase(injector()));

  injector.registerLazySingleton<PutLikeOnThisCommentUseCase>(
      () => PutLikeOnThisCommentUseCase(injector()));

  injector.registerLazySingleton<RemoveLikeOnThisCommentUseCase>(
      () => RemoveLikeOnThisCommentUseCase(injector()));

  //FireStore reply UseCase
  injector.registerLazySingleton<PutLikeOnThisReplyUseCase>(
      () => PutLikeOnThisReplyUseCase(injector()));

  injector.registerLazySingleton<RemoveLikeOnThisReplyUseCase>(
      () => RemoveLikeOnThisReplyUseCase(injector()));

  injector.registerLazySingleton<GetRepliesOfThisCommentUseCase>(
      () => GetRepliesOfThisCommentUseCase(injector()));

  injector.registerLazySingleton<ReplyOnThisCommentUseCase>(
      () => ReplyOnThisCommentUseCase(injector()));
  // *
  // *

  // follow useCases
  injector.registerLazySingleton<FollowThisUserUseCase>(
      () => FollowThisUserUseCase(injector()));
  injector.registerLazySingleton<UnFollowThisUserUseCase>(
      () => UnFollowThisUserUseCase(injector()));

  // *

  // story useCases
  injector.registerLazySingleton<GetStoriesInfoUseCase>(
      () => GetStoriesInfoUseCase(injector()));

  injector.registerLazySingleton<CreateStoryUseCase>(
      () => CreateStoryUseCase(injector()));
  injector.registerLazySingleton<DeleteStoryUseCase>(
      () => DeleteStoryUseCase(injector()));

  // *
  // notification useCases
  injector.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(injector()));
  injector.registerLazySingleton<CreateNotificationUseCase>(
      () => CreateNotificationUseCase(injector()));
  injector.registerLazySingleton<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCase(injector()));
  // *
  // calling rooms useCases
  injector.registerLazySingleton<CreateCallingRoomUseCase>(
      () => CreateCallingRoomUseCase(injector()));
  // join room useCases
  injector.registerLazySingleton<JoinToCallingRoomUseCase>(
      () => JoinToCallingRoomUseCase(injector()));
  // cancel room useCases
  injector.registerLazySingleton<CancelJoiningToRoomUseCase>(
      () => CancelJoiningToRoomUseCase(injector()));
  injector.registerLazySingleton<GetCallingStatusUseCase>(
      () => GetCallingStatusUseCase(injector()));

  injector.registerLazySingleton<GetUsersInfoInRoomUseCase>(
      () => GetUsersInfoInRoomUseCase(injector()));

  injector.registerLazySingleton<DeleteTheRoomUseCase>(
      () => DeleteTheRoomUseCase(injector()));

  injector.registerLazySingleton<GetAllUsersUseCase>(
      () => GetAllUsersUseCase(injector()));

  injector.registerLazySingleton<DeleteMessageForGroupChatUseCase>(
      () => DeleteMessageForGroupChatUseCase(injector()));

  injector.registerLazySingleton<GetMessagesGroGroupChatUseCase>(
      () => GetMessagesGroGroupChatUseCase(injector()));

  injector.registerLazySingleton<AddMessageForGroupChatUseCase>(
      () => AddMessageForGroupChatUseCase(injector()));

  injector.registerLazySingleton<GetSpecificChatInfo>(
      () => GetSpecificChatInfo(injector()));

  /// ========================================================================>

  // auth Blocs
  injector.registerFactory<FirebaseAuthCubit>(
    () => FirebaseAuthCubit(injector(), injector(), injector(), injector()),
  );
  // *

  // user Blocs
  injector.registerFactory<FireStoreAddNewUserCubit>(
    () => FireStoreAddNewUserCubit(injector()),
  );
  injector.registerFactory<UserInfoCubit>(() => UserInfoCubit(
        injector(),
        injector(),
        injector(),
        injector(),
        injector(),
        injector(),
      ));

  injector.registerFactory<UsersInfoCubit>(
    () => UsersInfoCubit(injector(), injector(), injector()),
  );

  injector.registerFactory<SearchAboutUserBloc>(
      () => SearchAboutUserBloc(injector()));

  injector.registerFactory<UsersInfoReelTimeBloc>(
      () => UsersInfoReelTimeBloc(injector(), injector()));

  // message searchAboutUser
  injector.registerFactory<MessageCubit>(
    () => MessageCubit(injector(), injector(), injector()),
  );
  injector.registerFactory<MessageBloc>(
    () => MessageBloc(injector(), injector()),
  );
  // *
  // *

  // follow Blocs
  injector.registerFactory<FollowCubit>(
    () => FollowCubit(injector(), injector()),
  );
  // *

  // post likes searchAboutUser
  injector.registerFactory<PostLikesCubit>(
    () => PostLikesCubit(injector(), injector()),
  );
  // *

  // comment searchAboutUser
  injector.registerFactory<CommentsInfoCubit>(
    () => CommentsInfoCubit(injector(), injector()),
  );
  injector.registerFactory<CommentLikesCubit>(
    () => CommentLikesCubit(injector(), injector()),
  );

  // *
  // post Blocs
  injector.registerFactory<ReplyInfoCubit>(
    () => ReplyInfoCubit(injector(), injector()),
  );
  injector.registerFactory<ReplyLikesCubit>(
    () => ReplyLikesCubit(injector(), injector()),
  );
  // *

  // post Blocs
  injector.registerFactory<PostCubit>(
    () => PostCubit(injector(), injector(), injector(), injector(), injector()),
  );
  injector.registerFactory<SpecificUsersPostsCubit>(
    () => SpecificUsersPostsCubit(injector()),
  );
  // story Blocs
  injector.registerFactory<StoryCubit>(
    () => StoryCubit(injector(), injector(), injector(), injector()),
  );
  // *
  // notification Blocs
  injector.registerFactory<NotificationCubit>(
    () => NotificationCubit(injector(), injector(), injector()),
  );
  // *
  // calling rooms cubit
  injector.registerFactory<CallingRoomsCubit>(
    () => CallingRoomsCubit(
      injector(),
      injector(),
      injector(),
      injector(),
      injector(),
    ),
  );
  injector
      .registerFactory<CallingStatusBloc>(() => CallingStatusBloc(injector()));

  injector.registerFactory<MessageForGroupChatCubit>(
      () => MessageForGroupChatCubit(injector(), injector()));
  // *
}

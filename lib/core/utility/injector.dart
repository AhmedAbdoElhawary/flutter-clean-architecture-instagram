import 'package:get_it/get_it.dart';
import 'package:instagram/core/app_prefs.dart';
import 'package:instagram/data/repositories_impl/firebase_auth_repository_impl.dart';
import 'package:instagram/data/repositories_impl/firestore_story_repo_impl.dart';
import 'package:instagram/data/repositories_impl/firestore_user_repo_impl.dart';
import 'package:instagram/data/repositories_impl/post/comment/firestore_comment_repo_impl.dart';
import 'package:instagram/data/repositories_impl/post/comment/firestore_reply_repo_impl.dart';
import 'package:instagram/data/repositories_impl/post/firestore_post_repo_impl.dart';
import 'package:instagram/domain/repositories/auth_repository.dart';
import 'package:instagram/domain/repositories/post/comment/comment_repository.dart';
import 'package:instagram/domain/repositories/post/comment/reply_repository.dart';
import 'package:instagram/domain/repositories/post/post_repository.dart';
import 'package:instagram/domain/repositories/story_repository.dart';
import 'package:instagram/domain/repositories/user_repository.dart';
import 'package:instagram/domain/use_cases/auth/log_in_auth_usecase.dart';
import 'package:instagram/domain/use_cases/auth/sign_out_auth_usecase.dart';
import 'package:instagram/domain/use_cases/auth/sign_up_auth_usecase.dart';
import 'package:instagram/domain/use_cases/follow/follow_this_user.dart';
import 'package:instagram/domain/use_cases/follow/remove_this_follower.dart';
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
import 'package:instagram/domain/use_cases/user/add_story_to_user.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_followers_and_followings_usecase.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_specific_users_usecase.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_user_from_user_name.dart';
import 'package:instagram/domain/use_cases/user/getUserInfo/get_user_info_usecase.dart';
import 'package:instagram/domain/use_cases/user/message/add_message.dart';
import 'package:instagram/domain/use_cases/user/message/delete_message.dart';
import 'package:instagram/domain/use_cases/user/message/get_chat_users_info.dart';
import 'package:instagram/domain/use_cases/user/message/get_messages.dart';
import 'package:instagram/domain/use_cases/user/search_about_user.dart';
import 'package:instagram/domain/use_cases/user/update_user_info.dart';
import 'package:instagram/domain/use_cases/user/upload_profile_image_usecase.dart';
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
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final injector = GetIt.I;

Future<void> initializeDependencies() async {
  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  injector.registerSingleton<SharedPreferences>(sharedPrefs);

  // app prefs instance
  injector.registerSingleton<AppPreferences>(AppPreferences(injector()));

  // Repository

  // Post
  injector.registerSingleton<FirestorePostRepository>(
    FirestorePostRepositoryImpl(),
  );
  // comment
  injector.registerSingleton<FirestoreCommentRepository>(
    FirestoreCommentRepositoryImpl(),
  );
  //reply

  injector.registerSingleton<FirestoreReplyRepository>(
    FirestoreRepliesRepositoryImpl(),
  );
  // *
  // *
  // *
  injector.registerSingleton<FirebaseAuthRepository>(
    FirebaseAuthRepositoryImpl(),
  );
  injector.registerSingleton<FirestoreUserRepository>(
    FirebaseUserRepoImpl(),
  );
  // story
  injector.registerSingleton<FirestoreStoryRepository>(
    FirestoreStoryRepositoryImpl(),
  );
  // *
  /// ==============================================================================================>

  // Firebase auth useCases
  injector.registerSingleton<LogInAuthUseCase>(LogInAuthUseCase(injector()));

  injector.registerSingleton<SignUpAuthUseCase>(SignUpAuthUseCase(injector()));
  injector
      .registerSingleton<SignOutAuthUseCase>(SignOutAuthUseCase(injector()));
  // *
  // Firestore user useCases
  injector.registerSingleton<AddNewUserUseCase>(AddNewUserUseCase(injector()));
  injector
      .registerSingleton<GetUserInfoUseCase>(GetUserInfoUseCase(injector()));

  injector.registerSingleton<GetFollowersAndFollowingsUseCase>(
      GetFollowersAndFollowingsUseCase(injector()));

  injector.registerSingleton<UpdateUserInfoUseCase>(
      UpdateUserInfoUseCase(injector()));

  injector.registerSingleton<UploadProfileImageUseCase>(
      UploadProfileImageUseCase(injector()));

  injector.registerSingleton<GetSpecificUsersUseCase>(
      GetSpecificUsersUseCase(injector()));

  injector.registerSingleton<AddPostToUserUseCase>(
      AddPostToUserUseCase(injector()));

  injector.registerSingleton<GetUserFromUserNameUseCase>(
      GetUserFromUserNameUseCase(injector()));

  injector.registerSingleton<AddStoryToUserUseCase>(
      AddStoryToUserUseCase(injector()));

  injector.registerSingleton<SearchAboutUserUseCase>(
      SearchAboutUserUseCase(injector()));
  injector.registerSingleton<GetChatUsersInfoAddMessageUseCase>(
      GetChatUsersInfoAddMessageUseCase(injector()));

  // message use case
  injector.registerSingleton<AddMessageUseCase>(AddMessageUseCase(injector()));
  injector
      .registerSingleton<GetMessagesUseCase>(GetMessagesUseCase(injector()));
  injector.registerSingleton<DeleteMessageUseCase>(
      DeleteMessageUseCase(injector()));
  // *
  // *
  // Firestore Post useCases
  injector.registerSingleton<CreatePostUseCase>(CreatePostUseCase(injector()));
  injector
      .registerSingleton<GetPostsInfoUseCase>(GetPostsInfoUseCase(injector()));

  injector.registerSingleton<GetAllPostsInfoUseCase>(
      GetAllPostsInfoUseCase(injector()));

  injector.registerSingleton<GetSpecificUsersPostsUseCase>(
      GetSpecificUsersPostsUseCase(injector()));

  injector.registerSingleton<PutLikeOnThisPostUseCase>(
      PutLikeOnThisPostUseCase(injector()));

  injector.registerSingleton<RemoveTheLikeOnThisPostUseCase>(
      RemoveTheLikeOnThisPostUseCase(injector()));

  injector.registerSingleton<GetSpecificStoriesInfoUseCase>(
      GetSpecificStoriesInfoUseCase(injector()));

  injector.registerSingleton<DeletePostUseCase>(DeletePostUseCase(injector()));

  injector.registerSingleton<UpdatePostUseCase>(UpdatePostUseCase(injector()));
  //Firestore Comment UseCase
  injector.registerSingleton<GetSpecificCommentsUseCase>(
      GetSpecificCommentsUseCase(injector()));

  injector.registerSingleton<AddCommentUseCase>(AddCommentUseCase(injector()));

  injector.registerSingleton<PutLikeOnThisCommentUseCase>(
      PutLikeOnThisCommentUseCase(injector()));

  injector.registerSingleton<RemoveLikeOnThisCommentUseCase>(
      RemoveLikeOnThisCommentUseCase(injector()));

  //Firestore reply UseCase
  injector.registerSingleton<PutLikeOnThisReplyUseCase>(
      PutLikeOnThisReplyUseCase(injector()));

  injector.registerSingleton<RemoveLikeOnThisReplyUseCase>(
      RemoveLikeOnThisReplyUseCase(injector()));

  injector.registerSingleton<GetRepliesOfThisCommentUseCase>(
      GetRepliesOfThisCommentUseCase(injector()));

  injector.registerSingleton<ReplyOnThisCommentUseCase>(
      ReplyOnThisCommentUseCase(injector()));
  // *
  // *

  // follow useCases
  injector.registerSingleton<FollowThisUserUseCase>(
      FollowThisUserUseCase(injector()));
  injector.registerSingleton<RemoveThisFollowerUseCase>(
      RemoveThisFollowerUseCase(injector()));

  // *

  // story useCases
  injector.registerSingleton<GetStoriesInfoUseCase>(
      GetStoriesInfoUseCase(injector()));
  injector
      .registerSingleton<CreateStoryUseCase>(CreateStoryUseCase(injector()));
  injector
      .registerSingleton<DeleteStoryUseCase>(DeleteStoryUseCase(injector()));

  // *
  /// ==============================================================================================>

  // auth Blocs
  injector.registerFactory<FirebaseAuthCubit>(
    () => FirebaseAuthCubit(injector(), injector(), injector()),
  );
  // *

  // user Blocs
  injector.registerFactory<FirestoreAddNewUserCubit>(
    () => FirestoreAddNewUserCubit(injector()),
  );
  injector.registerFactory<FirestoreUserInfoCubit>(() => FirestoreUserInfoCubit(
      injector(), injector(), injector(), injector(), injector(), injector()));

  injector.registerFactory<UsersInfoCubit>(
    () => UsersInfoCubit(injector(), injector(), injector()),
  );

  injector.registerFactory<SearchAboutUserBloc>(
    () => SearchAboutUserBloc(injector()),
  );
  // message searchAboutUser
  injector.registerFactory<MessageCubit>(
    () => MessageCubit(injector(), injector()),
  );
  injector.registerFactory<MessageBloc>(
    () => MessageBloc(injector()),
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
  // *
}

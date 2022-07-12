# Diff Details

Date : 2022-04-18 03:51:23

Directory d:\updated_instagram_day_4_6\instagram

Total : 56 files,  1364 codes, -558 comments, 138 blanks, all 944 lines

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [android/app/src/main/AndroidManifest.xml](/android/app/src/main/AndroidManifest.xml) | XML | 1 | 0 | 1 | 2 |
| [lib/config/routes/app_routes.dart](/lib/config/routes/app_routes.dart) | Dart | -4 | 2 | 0 | -2 |
| [lib/core/globall.dart](/lib/core/functions/date_of_now.dart) | Dart | 10 | 0 | 1 | 11 |
| [lib/core/usecase/usecase.dart](/lib/core/use_case/use_case.dart) | Dart | 3 | 0 | 0 | 3 |
| [lib/data/datasourses/remote/firestore_user_info.dart](/lib/data/datasourses/remote/user/firestore_user_info.dart) | Dart | 49 | 7 | 8 | 64 |
| [lib/data/datasourses/remote/post/comment/firestore_comment.dart](/lib/data/datasourses/remote/post/comment/firestore_comment.dart) | Dart | 1 | 0 | 0 | 1 |
| [lib/data/datasourses/remote/post/firestore_post.dart](/lib/data/datasourses/remote/post/firestore_post.dart) | Dart | -5 | -1 | -2 | -8 |
| [lib/data/datasourses/remote/post/firestore_reel.dart](/lib/data/datasourses/remote/post/firestore_reel.dart) | Dart | 0 | 19 | 1 | 20 |
| [lib/data/models/comment.dart](/lib/data/models/comment.dart) | Dart | 0 | -43 | -2 | -45 |
| [lib/data/models/garbage.dart](/lib/data/models/garbage.dart) | Dart | 0 | -75 | -1 | -76 |
| [lib/data/models/message.dart](/lib/data/models/message.dart) | Dart | 34 | 0 | 5 | 39 |
| [lib/data/models/post.dart](/lib/data/models/post.dart) | Dart | -4 | -1 | -1 | -6 |
| [lib/data/models/reply_comment.dart](/lib/data/models/reply_comment.dart) | Dart | 0 | -94 | -1 | -95 |
| [lib/data/models/user_personal_info.dart](/lib/data/models/user_personal_info.dart) | Dart | 2 | 0 | 0 | 2 |
| [lib/data/repositories/firestore_user_repo_impl.dart](/lib/data/repositories/firestore_user_repo_impl.dart) | Dart | 38 | 5 | 5 | 48 |
| [lib/data/repositories/post/comment/firestore_reply_repo_impl.dart](/lib/data/repositories/post/comment/firestore_reply_repo_impl.dart) | Dart | -1 | 0 | 0 | -1 |
| [lib/domain/repositories/post/comment/reply_repository.dart](/lib/domain/repositories/post/comment/reply_repository.dart) | Dart | -1 | 0 | 0 | -1 |
| [lib/domain/repositories/post/post_repository.dart](/lib/domain/repositories/post/post_repository.dart) | Dart | -1 | 0 | 0 | -1 |
| [lib/domain/repositories/user_repository.dart](/lib/domain/repositories/user_repository.dart) | Dart | 5 | 0 | 1 | 6 |
| [lib/domain/usecases/firestoreUserUseCase/getUserInfo/get_user_from_user_name.dart](/lib/domain/use_cases/user/getUserInfo/get_user_from_user_name.dart) | Dart | 11 | 0 | 4 | 15 |
| [lib/domain/usecases/firestoreUserUseCase/message/add_message.dart](/lib/domain/use_cases/user/message/add_message.dart) | Dart | 11 | 0 | 4 | 15 |
| [lib/domain/usecases/firestoreUserUseCase/message/get_messages.dart](/lib/domain/use_cases/user/message/get_messages.dart) | Dart | 11 | 0 | 4 | 15 |
| [lib/domain/usecases/firestoreUserUseCase/upload_profile_image_usecase.dart](/lib/domain/use_cases/user/upload_profile_image_usecase.dart) | Dart | 5 | -1 | 0 | 4 |
| [lib/injector.dart](/lib/core/utility/injector.dart) | Dart | 12 | 4 | -1 | 15 |
| [lib/main.dart](/lib/main.dart) | Dart | 0 | 12 | -1 | 11 |
| [lib/presentation/cubit/blocObserver/bloc_observer.dart](/lib/presentation/cubit/blocObserver/bloc_observer.dart) | Dart | -30 | 30 | 0 | 0 |
| [lib/presentation/cubit/firestoreUserInfoCubit/message/message_cubit.dart](/lib/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart) | Dart | 28 | 10 | 7 | 45 |
| [lib/presentation/cubit/firestoreUserInfoCubit/message/message_state.dart](/lib/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_state.dart) | Dart | 21 | 2 | 8 | 31 |
| [lib/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart](/lib/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart) | Dart | 24 | 1 | 2 | 27 |
| [lib/presentation/cubit/firestoreUserInfoCubit/user_info_state.dart](/lib/presentation/cubit/firestoreUserInfoCubit/user_info_state.dart) | Dart | -4 | 6 | -2 | 0 |
| [lib/presentation/cubit/postInfoCubit/commentsInfo/repliesInfo/reply_info_cubit.dart](/lib/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart) | Dart | -1 | 0 | 0 | -1 |
| [lib/presentation/cubit/postInfoCubit/post_cubit.dart](/lib/presentation/cubit/postInfoCubit/post_cubit.dart) | Dart | -3 | 0 | 0 | -3 |
| [lib/presentation/pages/comments_page.dart](/lib/presentation/pages/comments/comments_page.dart) | Dart | -5 | -28 | 0 | -33 |
| [lib/presentation/pages/edit_profile_page.dart](/lib/presentation/pages/profile/edit_profile_page.dart) | Dart | 8 | 0 | -2 | 6 |
| [lib/presentation/pages/home_page.dart](/lib/presentation/pages/time_line/my_own_time_line/home_page.dart) | Dart | -12 | 0 | -1 | -13 |
| [lib/presentation/pages/login_page.dart](/lib/presentation/pages/register/login_page.dart) | Dart | -1 | 0 | 0 | -1 |
| [lib/presentation/pages/messages_page.dart](/lib/presentation/pages/messages/messages_page.dart) | Dart | 52 | 2 | 6 | 60 |
| [lib/presentation/pages/new_post_page.dart](/lib/presentation/pages/profile/create_post_page.dart) | Dart | -1 | -1 | -3 | -5 |
| [lib/presentation/pages/personal_profile_page.dart](/lib/presentation/pages/profile/personal_profile_page.dart) | Dart | 23 | 0 | 1 | 24 |
| [lib/presentation/pages/play_this_video.dart](/lib/presentation/pages/video/play_this_video.dart) | Dart | 38 | 0 | 10 | 48 |
| [lib/presentation/pages/texting_page.dart](/lib/presentation/pages/messages/chatting_page.dart) | Dart | 357 | 13 | 23 | 393 |
| [lib/presentation/pages/ttry.dart](/lib/presentation/pages/ttry.dart) | Dart | 133 | 11 | 22 | 166 |
| [lib/presentation/pages/videos_page.dart](/lib/presentation/pages/video/videos_page.dart) | Dart | 192 | 14 | 9 | 215 |
| [lib/presentation/pages/which_profile_page.dart](/lib/presentation/widgets/belong_to/profile_w/which_profile_page.dart) | Dart | 21 | 0 | 2 | 23 |
| [lib/presentation/widgets/commentator.dart](/lib/presentation/widgets/belong_to/comments_w/commentator.dart) | Dart | 12 | -165 | -4 | -157 |
| [lib/presentation/widgets/custom_grid_view.dart](/lib/presentation/widgets/global/custom_widgets/custom_grid_view_display.dart) | Dart | 36 | 9 | 3 | 48 |
| [lib/presentation/widgets/custom_videos_grid_view.dart](/lib/presentation/widgets/belong_to/profile_w/custom_videos_grid_view.dart) | Dart | 138 | 1 | 12 | 151 |
| [lib/presentation/widgets/fade_animation.dart](/lib/presentation/widgets/global/aimation/fade_animation.dart) | Dart | 50 | 0 | 10 | 60 |
| [lib/presentation/widgets/multi_bloc_provider.dart](/lib/presentation/widgets/global/others/multi_bloc_provider.dart) | Dart | 4 | 0 | -1 | 3 |
| [lib/presentation/widgets/post_list_view.dart](/lib/presentation/widgets/belong_to/time_line_w/image_of_post_for_time_line.dart) | Dart | 10 | 6 | 0 | 16 |
| [lib/presentation/widgets/profile_page.dart](/lib/presentation/widgets/belong_to/profile_w/profile_page.dart) | Dart | -3 | 0 | 0 | -3 |
| [lib/presentation/widgets/reel_video_play.dart](/lib/presentation/widgets/belong_to/videos_w/reel_video_play.dart) | Dart | 76 | 0 | 10 | 86 |
| [lib/presentation/widgets/show_me_the_users.dart](/lib/presentation/widgets/belong_to/profile_w/show_me_the_users.dart) | Dart | 0 | -15 | -1 | -16 |
| [lib/presentation/widgets/user_profile_page.dart](/lib/presentation/pages/profile/user_profile_page.dart) | Dart | 16 | 0 | 1 | 17 |
| [lib/try.dart](/lib/try.dart) | Dart | 0 | -289 | -1 | -290 |
| [pubspec.yaml](/pubspec.yaml) | YAML | 8 | 1 | 2 | 11 |

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details
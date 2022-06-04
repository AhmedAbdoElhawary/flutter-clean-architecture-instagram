# Diff Details

Date : 2022-04-26 02:36:59

Directory d:\updated_instagram_day_4_6\instagram

Total : 73 files,  4428 codes, -267 comments, 600 blanks, all 4761 lines

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [analysis_options.yaml](/analysis_options.yaml) | YAML | 3 | 2 | 0 | 5 |
| [lib/core/resources/assets_manager.dart](/lib/core/resources/assets_manager.dart) | Dart | 2 | 0 | 0 | 2 |
| [lib/data/datasourses/remote/firestore_user_info.dart](/lib/data/datasourses/remote/user/firestore_user_info.dart) | Dart | 3 | -8 | 1 | -4 |
| [lib/data/datasourses/remote/post/comment/firestore_comment.dart](/lib/data/datasourses/remote/post/comment/firestore_comment.dart) | Dart | 0 | 0 | -1 | -1 |
| [lib/data/datasourses/remote/post/firestore_post.dart](/lib/data/datasourses/remote/post/firestore_post.dart) | Dart | -5 | 11 | 2 | 8 |
| [lib/data/repositories_impl/post/comment/firestore_comment_repo_impl.dart](/lib/data/repositories_impl/post/comment/firestore_comment_repo_impl.dart) | Dart | 5 | 0 | 0 | 5 |
| [lib/domain/repositories/post/comment/comment_repository.dart](/lib/domain/repositories/post/comment/comment_repository.dart) | Dart | 3 | 0 | 0 | 3 |
| [lib/domain/usecases/postUseCase/comments/getComment/get_all_comment.dart](/lib/domain/use_cases/post/comments/getComment/get_all_comment.dart) | Dart | 13 | 0 | 4 | 17 |
| [lib/domain/usecases/postUseCase/comments/getComment/get_comment.dart](/lib/domain/use_cases/post/comments/getComment/get_comment.dart) | Dart | 11 | 0 | 4 | 15 |
| [lib/domain/usecases/postUseCase/comments/get_all_comment.dart](/lib/domain/use_cases/post/comments/get_all_comment.dart) | Dart | -11 | 0 | -4 | -15 |
| [lib/injector.dart](/lib/core/utility/injector.dart) | Dart | 7 | 0 | 1 | 8 |
| [lib/presentation/cubit/StoryCubit/story_cubit.dart](/lib/presentation/cubit/StoryCubit/story_cubit.dart) | Dart | 4 | 0 | 0 | 4 |
| [lib/presentation/cubit/bloc/get_comments_bloc.dart](/lib/presentation/cubit/postInfoCubit/commentsInfo/bloc/get_comments_bloc.dart) | Dart | 38 | -30 | 4 | 12 |
| [lib/presentation/cubit/bloc/get_comments_event.dart](/lib/presentation/cubit/postInfoCubit/commentsInfo/bloc/get_comments_event.dart) | Dart | 18 | -23 | 5 | 0 |
| [lib/presentation/cubit/bloc/get_comments_state.dart](/lib/presentation/cubit/postInfoCubit/commentsInfo/bloc/get_comments_state.dart) | Dart | 14 | -20 | 6 | 0 |
| [lib/presentation/cubit/postInfoCubit/commentsInfo/comments_info_cubit.dart](/lib/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart) | Dart | -9 | 9 | 0 | 0 |
| [lib/presentation/customPackages/story_view/sory_controller.dart](/lib/presentation/customPackages/story_view/sory_controller.dart) | Dart | 20 | 10 | 8 | 38 |
| [lib/presentation/customPackages/story_view/story_image.dart](/lib/presentation/customPackages/story_view/story_image.dart) | Dart | 167 | 13 | 38 | 218 |
| [lib/presentation/customPackages/story_view/story_video.dart](/lib/presentation/customPackages/story_view/story_video.dart) | Dart | 127 | 0 | 25 | 152 |
| [lib/presentation/customPackages/story_view/story_view.dart](/lib/presentation/customPackages/story_view/story_view.dart) | Dart | 703 | 71 | 98 | 872 |
| [lib/presentation/customPackages/story_view/utils.dart](/lib/presentation/customPackages/story_view/utils.dart) | Dart | 18 | 0 | 8 | 26 |
| [lib/presentation/pages/comments_page.dart](/lib/presentation/pages/comments/comments_page.dart) | Dart | -2 | 5 | 3 | 6 |
| [lib/presentation/pages/home_page.dart](/lib/presentation/pages/time_line/my_own_time_line/home_page.dart) | Dart | 2 | 0 | -1 | 1 |
| [lib/presentation/screens/main_screen.dart](/lib/presentation/screens/main_screen.dart) | Dart | -2 | 0 | 0 | -2 |
| [lib/presentation/widgets/commentator.dart](/lib/presentation/widgets/belong_to/comments_w/commentator.dart) | Dart | 9 | 2 | 2 | 13 |
| [lib/presentation/widgets/create_post.dart](/lib/presentation/widgets/create_post.dart) | Dart | 0 | -44 | -1 | -45 |
| [lib/presentation/widgets/custom_grid_view.dart](/lib/presentation/widgets/global/custom_widgets/custom_grid_view_display.dart) | Dart | 7 | 0 | 1 | 8 |
| [lib/presentation/widgets/custom_posts_display.dart](/lib/presentation/widgets/custom_posts_display.dart) | Dart | 12 | 0 | 0 | 12 |
| [lib/presentation/widgets/custom_videos_grid_view.dart](/lib/presentation/widgets/belong_to/profile_w/custom_videos_grid_view.dart) | Dart | -3 | 0 | 0 | -3 |
| [lib/presentation/widgets/fade_in_image.dart](/lib/presentation/widgets/global/custom_widgets/custom_network_image_display.dart) | Dart | 3 | 0 | 1 | 4 |
| [lib/presentation/widgets/instagram_story_swipe.dart](/lib/presentation/widgets/belong_to/story_w/story_swipe.dart) | Dart | -2 | 0 | -1 | -3 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/app.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/app.dart) | Dart | 5 | 0 | 1 | 6 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/navigation/custom_rect_tween.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/navigation/custom_rect_tween.dart) | Dart | 19 | 6 | 4 | 29 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/navigation/hero_dialog_route.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/navigation/hero_dialog_route.dart) | Dart | 32 | 6 | 11 | 49 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/navigation/navigation.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/navigation/navigation.dart) | Dart | 2 | 0 | 1 | 3 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/state/app_state.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/state/app_state.dart) | Dart | 63 | 28 | 18 | 109 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/state/demo_users.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/state/demo_users.dart) | Dart | 49 | 7 | 6 | 62 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/state/models/models.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/state/models/models.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/state/models/user.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/state/models/user.dart) | Dart | 84 | 13 | 18 | 115 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/state/state.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/state/state.dart) | Dart | 3 | 0 | 1 | 4 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/stream_agram.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/stream_agram.dart) | Dart | 39 | 9 | 8 | 56 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/theme.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/theme.dart) | Dart | 174 | 20 | 22 | 216 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/app/utils.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/app/utils.dart) | Dart | 14 | 5 | 5 | 24 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/app_widgets.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/app_widgets.dart) | Dart | 4 | 0 | 1 | 5 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/avatars.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/avatars.dart) | Dart | 143 | 23 | 25 | 191 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/comment_box.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/comment_box.dart) | Dart | 159 | 4 | 13 | 176 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/favorite_icon.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/favorite_icon.dart) | Dart | 46 | 9 | 9 | 64 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/tap_fade_icon.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/app_widgets/tap_fade_icon.dart) | Dart | 49 | 8 | 13 | 70 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/comments/comments.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/comments/comments.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/comments/comments_screen.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/comments/comments_screen.dart) | Dart | 444 | 6 | 42 | 492 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/comments/state/comment_state.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/comments/state/comment_state.dart) | Dart | 44 | 27 | 16 | 87 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/comments/state/state.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/comments/state/state.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/home/home.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/home/home.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/home/home_screen.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/home/home_screen.dart) | Dart | 155 | 8 | 19 | 182 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/login/login.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/login/login.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/login/login_screen.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/login/login_screen.dart) | Dart | 79 | 4 | 8 | 91 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/new_post/new_post.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/new_post/new_post.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/new_post/new_post_screen.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/new_post/new_post_screen.dart) | Dart | 190 | 3 | 22 | 215 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/profile/edit_profile_screen.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/profile/edit_profile_screen.dart) | Dart | 167 | 5 | 11 | 183 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/profile/profile.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/profile/profile.dart) | Dart | 2 | 0 | 1 | 3 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/profile/profile_page.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/profile/profile_page.dart) | Dart | 282 | 4 | 16 | 302 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/search/search.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/search/search.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/search/search_page.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/search/search_page.dart) | Dart | 154 | 3 | 19 | 176 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/timeline/timeline.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/timeline/timeline.dart) | Dart | 2 | 0 | 1 | 3 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/timeline/timeline_page.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/timeline/timeline_page.dart) | Dart | 182 | 4 | 19 | 205 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/timeline/widgets/post_card.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/timeline/widgets/post_card.dart) | Dart | 429 | 11 | 38 | 478 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/components/timeline/widgets/widgets.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/components/timeline/widgets/widgets.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/presentation/widgets/mmmmmmmmmm/lib/main.dart](/lib/presentation/widgets/mmmmmmmmmm/lib/main.dart) | Dart | 7 | 0 | 3 | 10 |
| [lib/presentation/widgets/mmmmmmmmmm/try.dart](/lib/presentation/widgets/mmmmmmmmmm/try.dart) | Dart | 0 | 0 | 1 | 1 |
| [lib/presentation/widgets/multi_bloc_provider.dart](/lib/presentation/widgets/multi_bloc_provider.dart) | Dart | 4 | 0 | 1 | 5 |
| [lib/presentation/widgets/story_page.dart](/lib/presentation/widgets/story_page.dart) | Dart | 230 | 9 | 18 | 257 |
| [lib/presentation/widgets/try.dart](/lib/presentation/customPackages/in_view_notifier/in_view_notifier_widget.dart) | Dart | 0 | -487 | -1 | -488 |
| [pubspec.yaml](/pubspec.yaml) | YAML | 9 | 0 | -1 | 8 |

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details
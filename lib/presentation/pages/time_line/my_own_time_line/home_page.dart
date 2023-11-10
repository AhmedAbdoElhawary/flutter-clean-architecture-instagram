import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/notifications_permissions.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_list.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import 'package:instagram/presentation/pages/story/create_story.dart';
import 'package:instagram/presentation/pages/story/story_for_web.dart';
import 'package:instagram/presentation/pages/story/story_page_for_mobile.dart';
import 'package:instagram/presentation/pages/time_line/widgets/all_catch_up_icon.dart';
import 'package:instagram/presentation/pages/time_line/widgets/image_of_post_for_time_line.dart';
import 'package:instagram/presentation/pages/time_line/widgets/welcome_cards.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/common/jump_arrow.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final bool playVideo;

  const HomePage({Key? key, required this.userId, this.playVideo = true})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  late UserPersonalInfo personalInfo;
  ValueNotifier<bool> reLoadData = ValueNotifier(false);
  Post? selectedPostInfo;
  bool rebuild = true;
  List postsIds = [];
  ValueNotifier<List<Post>> postsInfo = ValueNotifier([]);
  List<UserPersonalInfo>? storiesOwnersInfo;

  Future<void> _getData(int index) async {
    storiesOwnersInfo = null;
    reLoadData.value = false;
    UserInfoCubit userCubit =
        BlocProvider.of<UserInfoCubit>(context, listen: false);
    await userCubit.getUserInfo(widget.userId);
    if (!mounted) return;
    personalInfo = userCubit.myPersonalInfo;
    List usersIds = personalInfo.followedPeople;
    SpecificUsersPostsCubit usersPostsCubit =
        BlocProvider.of<SpecificUsersPostsCubit>(context, listen: false);

    await usersPostsCubit.getSpecificUsersPostsInfo(usersIds: usersIds);

    List usersPostsIds = usersPostsCubit.usersPostsInfo;

    postsIds = personalInfo.posts + usersPostsIds;
    if (!mounted) return;
    PostCubit postCubit = PostCubit.get(context);
    await postCubit
        .getPostsInfo(
            postsIds: postsIds, isThatMyPosts: true, lengthOfCurrentList: index)
        .then((value) {
      reLoadData.value = true;
    });
  }

  @override
  void initState() {
    _getData(0);

    /// It's prefer to the here not in data_sources to avoid bugs when push notification.
    if (isThatMobile) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) async => await notificationPermissions(context));
    }
    super.initState();
  }

  @override
  void dispose() {
    isThatEndOfList.dispose();
    reLoadData.dispose();
    postsInfo.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: isThatMobile ? CustomAppBar.basicAppBar(context) : null,
        body: Center(
          child: blocBuilder(),
        ),
      ),
    );
  }

  ValueListenableBuilder<bool> blocBuilder() {
    return ValueListenableBuilder(
      valueListenable: reLoadData,
      builder: (context, bool value, child) =>
          BlocBuilder<PostCubit, PostState>(
        buildWhen: (previous, current) {
          if (value && current is CubitMyPersonalPostsLoaded) {
            reLoadData.value = false;
            return true;
          }
          if (value) {
            reLoadData.value = false;
            return true;
          }

          if (previous != current && current is CubitMyPersonalPostsLoaded) {
            return true;
          }
          if (previous != current && current is CubitPostFailed) {
            return true;
          }
          return false;
        },
        builder: (BuildContext context, PostState state) {
          if (state is CubitMyPersonalPostsLoaded) {
            postsInfo.value = state.postsInfo;
            return postsInfo.value.isNotEmpty
                ? inViewNotifier()
                : WelcomeCards(onRefreshData: _getData);
          } else if (state is CubitPostFailed) {
            ToastShow.toastStateError(state);
            return Center(
                child: Text(
              StringsManager.somethingWrong.tr,
              style: getNormalStyle(color: Theme.of(context).focusColor),
            ));
          } else {
            return const ThineCircularProgress();
          }
        },
      ),
    );
  }

  Widget inViewNotifier() {
    return ValueListenableBuilder(
      valueListenable: postsInfo,
      builder: (context, List<Post> postsInfoValue, child) =>
          InViewNotifierList(
        onRefreshData: _getData,
        postsIds: postsIds,
        physics: const BouncingScrollPhysics(),
        isThatEndOfList: isThatEndOfList,
        initialInViewIds: const ['0'],
        isInViewPortCondition:
            (double deltaTop, double deltaBottom, double vpHeight) {
          return deltaTop < (0.5 * vpHeight) && deltaBottom > (0.5 * vpHeight);
        },
        itemCount: postsInfoValue.length,
        builder: (BuildContext context, int index) {
          return Center(
            child: Container(
              width: isThatMobile ? double.infinity : 450,
              margin: const EdgeInsetsDirectional.only(bottom: .5, top: .5),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return InViewNotifierWidget(
                    id: '$index',
                    builder: (_, bool isInView, __) {
                      bool checkForPlatform = isThatMobile
                          ? isInView && widget.playVideo
                          : isInView;
                      return columnOfWidgets(index, checkForPlatform, isInView);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget columnOfWidgets(int index, bool playTheVideo, bool isInView) {
    double storiesHeight = isThatMobile ? 672 : 500;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (index == 0) ...[
          storiesOwnersInfo != null
              ? buildUsersStories(context)
              : storiesLines(storiesHeight),
          if (isThatMobile) customDivider(),
        ] else ...[
          if (isThatMobile) divider(),
        ],
        posts(index, playTheVideo),
        if (isThatEndOfList.value && index == postsIds.length - 1) ...[
          if (isThatMobile) divider(),
          const AllCatchUpIcon(),
        ]
      ],
    );
  }

  Divider divider() {
    return const Divider(color: ColorManager.lightGrey, thickness: .15);
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8, top: 5),
      color: ColorManager.grey,
      width: double.infinity,
      height: 0.3);

  Widget posts(int index, bool playTheVideo) {
    Widget buildPost = ValueListenableBuilder(
      valueListenable: postsInfo,
      builder: (context, List<Post> postsInfoValue, child) => PostOfTimeLine(
        postInfo: ValueNotifier(postsInfo.value[index]),
        postsInfo: postsInfo,
        playTheVideo: playTheVideo,
        indexOfPost: index,
        reLoadData: reloadTheData,
        removeThisPost: removeThisPost,
      ),
    );
    return isThatMobile
        ? buildPost
        : _RoundedContainer(
            internalPadding: false,
            verticalPadding: true,
            child: buildPost,
          );
  }

  void removeThisPost(int index) {
    setState(() {
      postsIds.removeAt(index);
      postsInfo.value.removeAt(index);
      reLoadData.value = true;
    });
  }

  reloadTheData() => reLoadData.value = true;

  Widget buildUsersStories(BuildContext context) {
    Widget stories = _BuildStoriesLine(
        personalInfo: personalInfo,
        reLoadData: reLoadData,
        storiesOwnersInfo: storiesOwnersInfo,
        scrollController: ScrollController());
    return isThatMobile
        ? stories
        : _RoundedContainer(isThatStory: true, child: stories);
  }

  Widget storiesLines(double bodyHeight) {
    List<dynamic> usersStoriesIds =
        personalInfo.followedPeople + personalInfo.followerPeople;
    return ValueListenableBuilder(
      valueListenable: reLoadData,
      builder: (context, bool value, child) =>
          BlocBuilder<StoryCubit, StoryState>(
        bloc: StoryCubit.get(context)
          ..getStoriesInfo(
              usersIds: usersStoriesIds, myPersonalInfo: personalInfo),
        buildWhen: (previous, current) {
          if (value && current is CubitStoriesInfoLoaded) {
            reLoadData.value = false;
            return true;
          }
          if (value) {
            reLoadData.value = false;
            return true;
          }
          if (previous != current && current is CubitStoriesInfoLoaded) {
            return true;
          }
          if (previous != current && current is CubitStoryFailed) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is CubitStoriesInfoLoaded) {
            storiesOwnersInfo = state.storiesOwnersInfo;
            return buildUsersStories(context);
          } else if (state is CubitStoryFailed) {
            ToastShow.toastStateError(state);
            return Center(
                child: Text(
              StringsManager.somethingWrong.tr,
              style: getNormalStyle(color: Theme.of(context).focusColor),
            ));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class _RoundedContainer extends StatelessWidget {
  const _RoundedContainer({
    Key? key,
    required this.child,
    this.internalPadding = true,
    this.verticalPadding = false,
    this.isThatStory = false,
  }) : super(key: key);
  final Widget child;
  final bool internalPadding;
  final bool verticalPadding;
  final bool isThatStory;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        padding: internalPadding || verticalPadding
            ? const EdgeInsets.symmetric(vertical: 15)
            : null,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorManager.lowOpacityGrey, width: 1),
        ),
        child: child,
      ),
    );
  }
}

class _BuildStoriesLine extends StatelessWidget {
  const _BuildStoriesLine({
    Key? key,
    required this.personalInfo,
    required this.reLoadData,
    required this.storiesOwnersInfo,
    required this.scrollController,
  }) : super(key: key);

  final UserPersonalInfo personalInfo;
  final ValueNotifier<bool> reLoadData;
  final ScrollController scrollController;
  final List<UserPersonalInfo>? storiesOwnersInfo;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    final storiesLength = storiesOwnersInfo?.length ?? 0;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: SizedBox(
        width: double.infinity,
        height: 600 * 0.153,
        child: Stack(
          children: [
            CustomScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              slivers: [
                if (personalInfo.stories.isEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    sliver: SliverToBoxAdapter(
                        child: _MyOwnStory(
                            reLoadData: reLoadData,
                            personalInfo: personalInfo)),
                  ),
                ],
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  UserPersonalInfo publisherInfo = storiesOwnersInfo![index];
                  String hashTag = isThatMobile
                      ? "${publisherInfo.userId.hashCode} for mobile"
                      : "${publisherInfo.userId.hashCode} for web";
                  return Hero(
                    tag: hashTag,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                          end: index != storiesLength - 1 ? 12 : 0),
                      child: GestureDetector(
                        onTap: () {
                          if (isThatMobile) {
                            Widget page = StoryPageForMobile(
                                user: publisherInfo,
                                hashTag: hashTag,
                                storiesOwnersInfo: storiesOwnersInfo!);
                            Go(context)
                                .push(page: page, withoutPageTransition: true);
                          } else {
                            Widget page = StoryPageForWeb(
                                user: publisherInfo,
                                hashTag: hashTag,
                                storiesOwnersInfo: storiesOwnersInfo!);
                            Get.to(page);
                          }
                        },
                        child: CircleAvatarOfProfileImage(
                          userInfo: publisherInfo,
                          bodyHeight:
                              isThatMobile ? bodyHeight : bodyHeight * 0.69,
                          thisForStoriesLine: true,
                          nameOfCircle: index == 0 &&
                                  publisherInfo.userId == personalInfo.userId
                              ? StringsManager.yourStory.tr
                              : "",
                        ),
                      ),
                    ),
                  );
                }, childCount: storiesLength))
              ],
            ),
            if (!isThatMobile && (storiesOwnersInfo?.length ?? 0) > 5) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                    onTap: () {
                      double pos = scrollController.offset - 500;
                      pos = pos < 0 ? 0 : pos;
                      scrollController.animateTo(pos,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutQuart);
                    },
                    child: const ArrowJump()),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    double pos = scrollController.offset + 500;

                    scrollController.animateTo(pos,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutQuart);
                  },
                  child: const ArrowJump(isThatBack: false),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MyOwnStory extends StatefulWidget {
  const _MyOwnStory({
    Key? key,
    required this.reLoadData,
    required this.personalInfo,
  }) : super(key: key);

  final ValueNotifier<bool> reLoadData;
  final UserPersonalInfo personalInfo;

  @override
  State<_MyOwnStory> createState() => _MyOwnStoryState();
}

class _MyOwnStoryState extends State<_MyOwnStory> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SelectedImagesDetails? details = await CustomImagePickerPlus.pickImage(
          context,
          isThatStory: true,
        );
        if (!context.mounted) return;
        if (details == null) return;

        await Go(context).push(
          page: CreateStoryPage(storiesDetails: details),
        );
        widget.reLoadData.value = true;
      },
      child: _MyOwnStoryChild(personalInfo: widget.personalInfo),
    );
  }
}

class _MyOwnStoryChild extends StatelessWidget {
  const _MyOwnStoryChild({Key? key, required this.personalInfo})
      : super(key: key);

  final UserPersonalInfo personalInfo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatarOfProfileImage(
          userInfo: personalInfo,
          bodyHeight: 700,
          moveTextMore: true,
          thisForStoriesLine: true,
          nameOfCircle: StringsManager.yourStory.tr,
        ),
        Positioned(
          top: 650 * .058,
          left: 650 * .058,
          right: 650 * .012,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle),
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Theme.of(context).primaryColor,
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: ColorManager.blue,
                child: Icon(
                  Icons.add,
                  size: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

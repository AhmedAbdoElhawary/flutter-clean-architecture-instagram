import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/functions/notifications_permissions.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:instagram/presentation/cubit/follow/follow_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_list.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import 'package:instagram/presentation/customPackages/snapping.dart';
import 'package:instagram/presentation/pages/story/story_for_web.dart';
import 'package:instagram/presentation/pages/story/story_page_for_mobile.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/custom_gallery/create_new_story.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/all_catch_up_icon.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/image_of_post_for_time_line.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_smart_refresh.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/common/jump_arrow.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../../../widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';

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
  UserPersonalInfo? personalInfo;
  ValueNotifier<bool> reLoadData = ValueNotifier(false);
  Post? selectedPostInfo;
  bool rebuild = true;
  List postsIds = [];
  ValueNotifier<List<Post>> postsInfo = ValueNotifier([]);
  List<UserPersonalInfo>? storiesOwnersInfo;
  ScrollController scrollController = ScrollController();

  Future<void> getData(int index) async {
    storiesOwnersInfo = null;
    reLoadData.value = false;
    UserInfoCubit userCubit =
        BlocProvider.of<UserInfoCubit>(context, listen: false);
    await userCubit.getUserInfo(widget.userId);
    personalInfo = userCubit.myPersonalInfo;
    if (!mounted) return;
    List usersIds = personalInfo!.followedPeople;

    SpecificUsersPostsCubit usersPostsCubit =
        BlocProvider.of<SpecificUsersPostsCubit>(context, listen: false);

    await usersPostsCubit.getSpecificUsersPostsInfo(usersIds: usersIds);

    List usersPostsIds = usersPostsCubit.usersPostsInfo;

    postsIds = personalInfo!.posts + usersPostsIds;
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
    getData(0);

    /// It's prefer to the here not in data_sources to avoid bugs when push notification.
    if (isThatMobile) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) async => await notificationPermissions(context));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: isThatMobile ? CustomAppBar.basicAppBar(context) : null,
      body: Center(
        child: blocBuilder(bodyHeight),
      ),
    );
  }

  ValueListenableBuilder<bool> blocBuilder(double bodyHeight) {
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
                ? inViewNotifier(bodyHeight)
                : _WelcomeCards(onRefreshData: getData);
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

  Widget inViewNotifier(double bodyHeight) {
    return ValueListenableBuilder(
      valueListenable: postsInfo,
      builder: (context, List<Post> postsInfoValue, child) =>
          InViewNotifierList(
        onRefreshData: getData,
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
                      return columnOfWidgets(
                          bodyHeight, index, checkForPlatform, isInView);
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

  Widget columnOfWidgets(
      double bodyHeight, int index, bool playTheVideo, bool isInView) {
    double storiesHeight = isThatMobile ? 672 : 500;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (index == 0) ...[
          storiesOwnersInfo != null
              ? buildUsersStories(bodyHeight, context)
              : storiesLines(storiesHeight),
          if (isThatMobile) customDivider(),
        ] else ...[
          if (isThatMobile) divider(),
        ],
        posts(index, bodyHeight, playTheVideo),
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
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: ColorManager.grey,
      width: double.infinity,
      height: 0.3);

  Widget posts(int index, double bodyHeight, bool playTheVideo) {
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
        : roundedContainer(
            child: buildPost, internalPadding: false, verticalPadding: true);
  }

  void removeThisPost(int index) {
    setState(() {
      postsIds.removeAt(index);
      postsInfo.value.removeAt(index);
      reLoadData.value = true;
    });
  }

  reloadTheData() => reLoadData.value = true;

  Widget buildUsersStories(double bodyHeight, BuildContext context) {
    Widget stories = buildStories(bodyHeight, context, storiesOwnersInfo!);
    return isThatMobile
        ? stories
        : roundedContainer(child: stories, isThatStory: true);
  }

  Widget storiesLines(double bodyHeight) {
    List<dynamic> usersStoriesIds =
        personalInfo!.followedPeople + personalInfo!.followerPeople;
    return ValueListenableBuilder(
      valueListenable: reLoadData,
      builder: (context, bool value, child) =>
          BlocBuilder<StoryCubit, StoryState>(
        bloc: StoryCubit.get(context)
          ..getStoriesInfo(
              usersIds: usersStoriesIds, myPersonalInfo: personalInfo!),
        buildWhen: (previous, current) {
          if (value && current is CubitStoriesInfoLoaded) {
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
            return buildUsersStories(bodyHeight, context);
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

  Padding roundedContainer({
    required Widget child,
    bool internalPadding = true,
    bool verticalPadding = false,
    bool isThatStory = false,
  }) {
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

  Padding buildStories(double bodyHeight, BuildContext context,
      List<UserPersonalInfo> storiesOwnersInfo) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: SizedBox(
        width: double.infinity,
        height: 600 * 0.155,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (personalInfo!.stories.isEmpty) ...[
                myOwnStory(context, storiesOwnersInfo, bodyHeight),
                const SizedBox(width: 12),
              ],
              ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                controller: scrollController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: storiesOwnersInfo.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 12),
                itemBuilder: (BuildContext context, int index) {
                  UserPersonalInfo publisherInfo = storiesOwnersInfo[index];
                  String hashTag = isThatMobile
                      ? "${publisherInfo.userId.hashCode} for mobile"
                      : "${publisherInfo.userId.hashCode} for web";
                  return Hero(
                    tag: hashTag,
                    child: GestureDetector(
                      onTap: () {
                        Widget page;
                        if (isThatMobile) {
                          page = StoryPageForMobile(
                              user: publisherInfo,
                              hashTag: hashTag,
                              storiesOwnersInfo: storiesOwnersInfo);
                        } else {
                          page = StoryPageForWeb(
                              user: publisherInfo,
                              hashTag: hashTag,
                              storiesOwnersInfo: storiesOwnersInfo);
                        }
                        pushToPage(context,
                            page: page, withoutPageTransition: true);
                      },
                      child: CircleAvatarOfProfileImage(
                        userInfo: publisherInfo,
                        bodyHeight: bodyHeight * 1.1,
                        thisForStoriesLine: true,
                        nameOfCircle: index == 0 &&
                                publisherInfo.userId == personalInfo!.userId
                            ? StringsManager.yourStory.tr
                            : "",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  moveToStoryPage(
          List<UserPersonalInfo> storiesOwnersInfo, UserPersonalInfo user) =>
      pushToPage(context,
          page: StoryPageForMobile(
              user: user, storiesOwnersInfo: storiesOwnersInfo));

  Widget myOwnStory(BuildContext context,
      List<UserPersonalInfo> storiesOwnersInfo, double bodyHeight) {
    return GestureDetector(
      onTap: () async {
        pushToPage(context, page: const CreateNewStory());
        reLoadData.value = true;
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatarOfProfileImage(
            userInfo: personalInfo!,
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
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle),
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
      ),
    );
  }
}

class _WelcomeCards extends StatefulWidget {
  final AsyncValueSetter<int> onRefreshData;

  const _WelcomeCards({Key? key, required this.onRefreshData})
      : super(key: key);

  @override
  State<_WelcomeCards> createState() => _WelcomeCardsState();
}

class _WelcomeCardsState extends State<_WelcomeCards> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);
  PageController pageController = PageController(viewportFraction: 0.7);
  int currentPage = 0;
  late ScrollController _scrollPageController;
  double initialPage = 0;
  @override
  void initState() {
    super.initState();
    initialPage = currentPage.toDouble();
    _scrollPageController = ScrollController();
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return welcomeCards();
  }

  Widget welcomeCards() {
    return SizedBox(
      height: double.maxFinite,
      child:isThatMobile?CustomSmartRefresh(
          onRefreshData: widget.onRefreshData, child: suggestionsFriends()): suggestionsFriends(),
    );
  }

  Widget buildColumn(List<UserPersonalInfo> users) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double halfOfWidth = widthOfScreen / 2;
    double heightOfStory =
        (halfOfWidth < 515 ? widthOfScreen : halfOfWidth) + 100;
    double widthOfStory =
        (halfOfWidth < 515 ? halfOfWidth : halfOfWidth / 2) + 80;

    return ScrollSnapList(
      itemBuilder: (_, index) {
        bool active = currentPage == index;

        return SizedBox(
          width: widthOfStory,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: heightOfStory,
                  width: widthOfStory,
                  child: userCardInfo(active, users[index], index),
                ),
                if (currentPage == index) ...[
                  buildJumpArrow(),
                  buildJumpArrow(isThatBack: false),
                ],
              ],
            ),
          ),
        );
      },
      onItemFocus: (pos) {
        setState(() => currentPage = pos);
        if (kDebugMode) {
          print('Done! $pos');
        }
      },
      itemSize: widthOfStory,
      listController: _scrollPageController,
      initialIndex: initialPage,
      dynamicItemSize: true,
      scrollDirection: Axis.horizontal,
      onReachEnd: () {
        if (kDebugMode) {
          print('Done!');
        }
      },
      itemCount: users.length,
    );
  }

  Widget suggestionsFriends() {
    return Column(
      children: [
        ...welcomeTexts(),
        Flexible(
          child: BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
            bloc: UsersInfoReelTimeBloc.get(context)
              ..add(LoadAllUsersInfoInfo()),
            buildWhen: (previous, current) =>
                previous != current && (current is AllUsersInfoLoaded),
            builder: (context, state) {
              if (state is AllUsersInfoLoaded) {
                List<UserPersonalInfo> users = state.allUsersInfoInReelTime;
                if (users.isEmpty) {
                  return emptyText();
                } else {
                  if(isThatMobile){
                    return ValueListenableBuilder(
                      valueListenable: _selectedIndex,
                      builder: (context, int selectedIndexValue, child) =>
                          PageView.builder(
                            itemCount: users.length,
                            controller: pageController,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (index) {
                              _selectedIndex.value = index;
                            },
                            itemBuilder: (context, index) {
                              bool active = selectedIndexValue == index;
                              return userCardInfo(active, users[index],index);
                            },
                          ),
                    );
                  }else{
                    return buildColumn(users);
                  }
                }
              } else {
                return const Center(child: ThineCircularProgress());
              }
            },
          ),
        ),
      ],
    );
  }

  List<Widget> welcomeTexts() => [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            StringsManager.welcomeToInstagram.tr,
            style: getMediumStyle(
                color: Theme.of(context).focusColor, fontSize: 22),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            StringsManager.followPeopleToSee.tr,
            style: getNormalStyle(
                color: Theme.of(context).textTheme.headlineMedium!.color!,
                fontSize: 14),
          ),
        ),
        Center(
          child: Text(
            StringsManager.videosTheyShare.tr,
            style: getNormalStyle(
                color: Theme.of(context).textTheme.headlineMedium!.color!,
                fontSize: 14),
          ),
        ),
      ];

  Widget userCardInfo(bool active, UserPersonalInfo userInfo, int index) {
    final double margin = active ? 0 : 25;
    double width =
        MediaQuery.of(context).size.width - (isThatMobile ? 120 : 200);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: isThatMobile ? 330 : 400,
          width: width,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            margin: EdgeInsets.only(top: margin, bottom: margin),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).splashColor,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.grey.withOpacity(.15),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ]),
            child: buildUserBrief(userInfo),
          ),
        ),
      ),
    );
  }

  Widget buildJumpArrow({bool isThatBack = true}) {
    return GestureDetector(
      onTap: () async {
        if (isThatBack) {
          _scrollPageController.animateTo(
            _scrollPageController.offset -
                MediaQuery.of(context).size.width / 4,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollPageController.animateTo(
            _scrollPageController.offset +
                MediaQuery.of(context).size.width / 4,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: SizedBox(
          child: ArrowJump(isThatBack: isThatBack)),
    );
  }

  Widget emptyText() {
    return Center(
      child: Text(
        StringsManager.noUsers.tr,
        style: getNormalStyle(color: Theme.of(context).focusColor),
      ),
    );
  }

  Widget buildUserBrief(UserPersonalInfo userInfo) {
    List lastThreePostUrls = userInfo.lastThreePostUrls.length >= 3
        ? userInfo.lastThreePostUrls.sublist(0, 3)
        : userInfo.lastThreePostUrls;
    bool isIFollowHim = userInfo.followerPeople.contains(myPersonalId);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatarOfProfileImage(
                userInfo: userInfo, bodyHeight: 900, showColorfulCircle: false),
            const SizedBox(height: 10),
            Text(
              userInfo.userName,
              style: getNormalStyle(color: Theme.of(context).focusColor),
            ),
            Text(
              userInfo.name,
              style: getNormalStyle(
                  color: Theme.of(context).textTheme.headlineMedium!.color!),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (lastThreePostUrls.isEmpty) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        StringsManager.noPosts.tr,
                        style:
                            getNormalStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                  ),
                ] else ...[
                  ...lastThreePostUrls.map(
                    (imageUrl) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 1),
                        child: SizedBox(
                            height:isThatMobile? 70:100,
                            width: isThatMobile? 70:100,
                            child: NetworkImageDisplay(
                              imageUrl: imageUrl,
                              cachingWidth:isThatMobile? 140:200,
                              cachingHeight: isThatMobile? 140:200,
                            )),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 37),
            GestureDetector(
              onTap: () async {
                FollowCubit followCubit = FollowCubit.get(context);
                if (isIFollowHim) {
                  await followCubit.unFollowThisUser(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);
                  userInfo.followerPeople.remove(myPersonalId);
                } else {
                  await followCubit.followThisUser(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);
                  userInfo.followerPeople.add(myPersonalId);
                }
              },
              child: followButton(isIFollowHim),
            ),
          ],
        ),
      ),
    );
  }

  Container followButton(bool isIFollowHim) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color:
            isIFollowHim ? Theme.of(context).primaryColor : ColorManager.blue,
        border: Border.all(
          color: isIFollowHim
              ? Theme.of(context).bottomAppBarColor
              : ColorManager.transparent,
          width: 0,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.grey.withOpacity(.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: isIFollowHim
          ? Text(StringsManager.following.tr,
              style: getNormalStyle(color: Theme.of(context).focusColor))
          : Text(StringsManager.follow.tr,
              style: getNormalStyle(color: ColorManager.white)),
    );
  }
}

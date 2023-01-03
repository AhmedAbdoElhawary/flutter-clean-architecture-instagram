import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:instagram/presentation/cubit/follow/follow_cubit.dart';
import 'package:instagram/presentation/customPackages/snapping.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_smart_refresh.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/common/jump_arrow.dart';

class WelcomeCards extends StatefulWidget {
  final AsyncValueSetter<int> onRefreshData;

  const WelcomeCards({Key? key, required this.onRefreshData}) : super(key: key);

  @override
  State<WelcomeCards> createState() => WelcomeCardsState();
}

class WelcomeCardsState extends State<WelcomeCards> {
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
      child: isThatMobile
          ? CustomSmartRefresh(
              onRefreshData: widget.onRefreshData, child: suggestionsFriends())
          : suggestionsFriends(),
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
                  child: _UserCardInfo(active: active, userInfo: users[index]),
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
        const _WelcomeTexts(),
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
                  if (isThatMobile) {
                    return _PagesView(
                        selectedIndex: _selectedIndex,
                        users: users,
                        pageController: pageController);
                  } else {
                    return buildColumn(users);
                  }
                }
              } else {
                return const ThineCircularProgress();
              }
            },
          ),
        ),
      ],
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
      child: SizedBox(child: ArrowJump(isThatBack: isThatBack)),
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
}

class _PagesView extends StatelessWidget {
  const _PagesView({
    Key? key,
    required ValueNotifier<int> selectedIndex,
    required this.users,
    required this.pageController,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final ValueNotifier<int> _selectedIndex;
  final List<UserPersonalInfo> users;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, int selectedIndexValue, child) => PageView.builder(
        itemCount: users.length,
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          _selectedIndex.value = index;
        },
        itemBuilder: (context, index) {
          bool active = selectedIndexValue == index;
          return _UserCardInfo(active: active, userInfo: users[index]);
        },
      ),
    );
  }
}

class _WelcomeTexts extends StatelessWidget {
  const _WelcomeTexts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}

class _UserCardInfo extends StatelessWidget {
  const _UserCardInfo({
    Key? key,
    required this.active,
    required this.userInfo,
  }) : super(key: key);
  final UserPersonalInfo userInfo;

  final bool active;

  @override
  Widget build(BuildContext context) {
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
            child: _BuildUserBrief(userInfo: userInfo),
          ),
        ),
      ),
    );
  }
}

class _BuildUserBrief extends StatelessWidget {
  const _BuildUserBrief({
    Key? key,
    required this.userInfo,
  }) : super(key: key);
  final UserPersonalInfo userInfo;

  @override
  Widget build(BuildContext context) {
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
                            height: isThatMobile ? 70 : 100,
                            width: isThatMobile ? 70 : 100,
                            child: NetworkDisplay(
                              url: imageUrl,
                              cachingWidth: isThatMobile ? 140 : 200,
                              cachingHeight: isThatMobile ? 140 : 200,
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
              child: _FollowButton(isIFollowHim),
            ),
          ],
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton(
    this.isIFollowHim, {
    Key? key,
  }) : super(key: key);

  final bool isIFollowHim;

  @override
  Widget build(BuildContext context) {
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

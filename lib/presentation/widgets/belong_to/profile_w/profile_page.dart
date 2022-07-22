import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/profile/followers_info_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/custom_videos_grid_view.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/profile_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../data/models/user_personal_info.dart';
import '../../global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../time_line_w/read_more_text.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  String userId;
  bool isThatMyPersonalId;
  UserPersonalInfo userInfo;
  List<Widget> widgetsAboveTapBars;
  final AsyncCallback getData;

  ProfilePage(
      {required this.widgetsAboveTapBars,
      required this.isThatMyPersonalId,
      required this.userInfo,
      required this.userId,
      required this.getData,
      Key? key})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ValueNotifier<bool> reBuild = ValueNotifier(false);
  ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return defaultTabController(bodyHeight);
  }

  Widget defaultTabController(double bodyHeight) {
    return Center(
      child: SizedBox(
        width: isThatMobile ? null : 920,
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (_, __) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    isThatMobile
                        ? widgetsAboveTapBarsForMobile(
                            widget.userInfo, bodyHeight)
                        : widgetsAboveTapBarsForWeb(
                            widget.userInfo, bodyHeight),
                  ),
                ),
              ];
            },
            body: tapBar(),
          ),
        ),
      ),
    );
  }

  Widget tapBar() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: PostCubit.get(context)
        ..getPostsInfo(
            postsIds: widget.userInfo.posts,
            isThatMyPosts: widget.isThatMyPersonalId),
      buildWhen: (previous, current) {
        if (reBuild.value) {
          reBuild.value = false;
          return true;
        }
        if (previous != current && current is CubitPostFailed) {
          return true;
        }
        return previous != current &&
            ((current is CubitMyPersonalPostsLoaded &&
                    widget.isThatMyPersonalId) ||
                (current is CubitPostsInfoLoaded &&
                    !widget.isThatMyPersonalId));
      },
      builder: (BuildContext context, PostState state) {
        if (state is CubitMyPersonalPostsLoaded && widget.isThatMyPersonalId) {
          return columnOfWidgets(state.postsInfo);
        } else if (state is CubitPostsInfoLoaded &&
            !widget.isThatMyPersonalId) {
          return columnOfWidgets(state.postsInfo);
        } else {
          return loadingWidget();
        }
      },
    );
  }

  Widget loadingWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          tabBarIcons(),
          Shimmer.fromColors(
            baseColor: Theme.of(context).textTheme.headline5!.color!,
            highlightColor: Theme.of(context).textTheme.headline6!.color!,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              padding: const EdgeInsetsDirectional.only(bottom: 1.5, top: 1.5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.5,
                mainAxisSpacing: 1.5,
              ),
              itemBuilder: (_, __) {
                return Container(
                    color: ColorManager.lightDarkGray, width: double.infinity);
              },
              itemCount: 15,
            ),
          ),
        ],
      ),
    );
  }

  Column columnOfWidgets(List<Post> postsInfo) {
    return Column(
      children: [
        tabBarIcons(),
        tapBarView(postsInfo),
      ],
    );
  }

  Expanded tapBarView(List<Post> postsInfo) {
    List<Post> videosPostsInfo =
        postsInfo.where((element) => element.isThatImage == false).toList();

    List<Post> imagesPostsInfo =
        postsInfo.where((element) => element.isThatImage == true).toList();
    return Expanded(
      child: TabBarView(
        children: [
          ProfileGridView(postsInfo: imagesPostsInfo, userId: widget.userId),
          CustomVideosGridView(
              postsInfo: videosPostsInfo, userId: widget.userId),
          ProfileGridView(postsInfo: imagesPostsInfo, userId: widget.userId),
        ],
      ),
    );
  }

  TabBar tabBarIcons() {
    bool isWidthAboveMinimum = MediaQuery.of(context).size.width > 800;
    return TabBar(
      unselectedLabelColor: ColorManager.grey,
      labelColor: isWidthAboveMinimum
          ? ColorManager.black
          : (isThatMobile ? Theme.of(context).focusColor : ColorManager.blue),
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
      indicatorSize: isThatMobile ? null : TabBarIndicatorSize.label,
      isScrollable: isWidthAboveMinimum ? true : false,
      labelPadding: isWidthAboveMinimum
          ? const EdgeInsetsDirectional.only(
              start: 50, end: 50, top: 5, bottom: 3)
          : null,
      indicatorWeight: isWidthAboveMinimum ? 2 : (isThatMobile ? 2 : 0),
      indicator: isThatMobile
          ? null
          : BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: isWidthAboveMinimum
                        ? Theme.of(context).focusColor
                        : ColorManager.transparent,
                    width: 1),
              ),
            ),
      tabs: [
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.grid_on_rounded,
                size: isWidthAboveMinimum ? 14 : null,
              ),
              if (isWidthAboveMinimum) ...[
                const SizedBox(width: 8),
                Text(
                  StringsManager.postsCap.tr(),
                ),
              ],
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                IconsAssets.videoIcon,
                color: Theme.of(context).errorColor,
                height: isWidthAboveMinimum ? 14 : 22.5,
              ),
              if (isWidthAboveMinimum) ...[
                const SizedBox(width: 8),
                Text(StringsManager.reels.tr()),
              ],
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                size: isWidthAboveMinimum ? 22 : 38,
              ),
              if (isWidthAboveMinimum) ...[
                const SizedBox(width: 8),
                Text(StringsManager.videos.tr()),
              ],
            ],
          ),
        ),
      ],
    );
  }

  widgetsAboveTapBarsForWeb(UserPersonalInfo userInfo, double bodyHeight) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    bool isWidthAboveMinimum = widthOfScreen > 800;
    return [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isWidthAboveMinimum ? 60 : 40, vertical: 30),
              child: CircleAvatarOfProfileImage(
                bodyHeight: isWidthAboveMinimum ? 1500 : 900,
                userInfo: userInfo,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userInfo.userName,
                        style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontSize: isWidthAboveMinimum ? 25 : 15,
                            fontWeight: FontWeight.w100),
                      ),
                      const SizedBox(width: 20),
                      customTransparentButton(),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.settings_rounded,
                            color: ColorManager.black),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          personalNumbersInfo(userInfo.posts,
                              StringsManager.posts.tr(), userInfo),
                          const SizedBox(width: 20),
                          personalNumbersInfo(userInfo.followerPeople,
                              StringsManager.followers.tr(), userInfo),
                          const SizedBox(width: 20),
                          personalNumbersInfo(userInfo.followedPeople,
                              StringsManager.following.tr(), userInfo),
                        ],
                      ),
                    ),
                  ),
                  Text(userInfo.name,
                      style: Theme.of(context).textTheme.headline2),
                  const SizedBox(height: 5),
                  Text(userInfo.bio,
                      style: getNormalStyle(
                          color: Theme.of(context).focusColor, fontSize: 15)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget customTransparentButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: ColorManager.transparent,
          border: Border.all(
            color: ColorManager.lowOpacityGrey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          StringsManager.editProfile.tr(),
          style: getMediumStyle(color: ColorManager.black),
        ),
      ),
    );
  }

  List<Widget> widgetsAboveTapBarsForMobile(
      UserPersonalInfo userInfo, double bodyHeight) {
    return [
      GestureDetector(
        onVerticalDragStart: (e) async {
          loading.value = true;
          await widget.getData();
        },
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: loading,
              builder: (context, bool loadingValue, child) => AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  switchInCurve: Curves.easeIn,
                  child: loadingValue
                      ? customDragLoading(bodyHeight)
                      : Container()),
            ),
            personalPhotoAndNumberInfo(userInfo, bodyHeight),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 15.0, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userInfo.name,
                      style: Theme.of(context).textTheme.headline2),
                  ReadMore(userInfo.bio, 4),
                  const SizedBox(height: 10),
                  Row(
                    children: widget.widgetsAboveTapBars,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Container customDragLoading(double bodyHeight) {
    return Container(
      height: bodyHeight * .09,
      width: double.infinity,
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: ColorManager.black38,
          backgroundColor: Theme.of(context).dividerColor,
        ),
      ),
    );
  }

  Row personalPhotoAndNumberInfo(UserPersonalInfo userInfo, double bodyHeight) {
    String hash = "${userInfo.userId.hashCode}personal";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: hash,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 15.0, top: 10),
            child: CircleAvatarOfProfileImage(
                bodyHeight: bodyHeight * 1.45,
                userInfo: userInfo,
                hashTag: hash),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(height: bodyHeight * .055),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  personalNumbersInfo(
                      userInfo.posts, StringsManager.posts.tr(), userInfo),
                  personalNumbersInfo(userInfo.followerPeople,
                      StringsManager.followers.tr(), userInfo),
                  personalNumbersInfo(userInfo.followedPeople,
                      StringsManager.following.tr(), userInfo),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget personalNumbersInfo(
      List usersInfo, String text, UserPersonalInfo userInfo) {
    return Builder(builder: (builderContext) {
      List<Widget> userInfoWidgets = [
        Text(
          "${usersInfo.length}",
          style: getBoldStyle(
              color: Theme.of(context).focusColor,
              fontSize: isThatMobile ? 20 : 15),
        ),
        if (!isThatMobile) const SizedBox(width: 5),
        Text(text,
            style: getNormalStyle(
                color: Theme.of(context).focusColor, fontSize: 15)),
      ];
      return GestureDetector(
        onTap: () async {
          if (text != StringsManager.posts.tr()) {
            await Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => FollowersInfoPage(
                    userInfo: userInfo,
                    initialIndex: usersInfo == userInfo.followerPeople ? 0 : 1),
              ),
            );
            BlocProvider.of<FirestoreUserInfoCubit>(context).getUserInfo(
                userInfo.userId,
                isThatMyPersonalId: widget.isThatMyPersonalId);
            setState(() {
              reBuild.value = true;
            });
          }
        },
        child: isThatMobile
            ? Column(children: userInfoWidgets)
            : Row(children: userInfoWidgets),
      );
    });
  }
}

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
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/profile/followers_info_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/profile_grid_view.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/custom_videos_grid_view.dart';
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
  bool reBuild = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return defaultTabController(bodyHeight);
  }

  Widget defaultTabController(double bodyHeight) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                listOfWidgetsAboveTapBars(widget.userInfo, bodyHeight),
              ),
            ),
          ];
        },
        body: tapBar(),
      ),
    );
  }

  Widget tapBar() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: PostCubit.get(context)
        ..getPostsInfo(
            userId: widget.userInfo.userId,
            postsIds: widget.userInfo.posts,
            isThatForMyPosts: widget.isThatMyPersonalId),
      buildWhen: (previous, current) {
        if (reBuild) {
          reBuild = false;
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
    return TabBar(
      tabs: [
        const Tab(
            icon: Icon(
          Icons.grid_on_rounded,
        )),
        Tab(
            icon: SvgPicture.asset(
          IconsAssets.videoIcon,
          color: Theme.of(context).errorColor,
          height: 22.5,
        )),
        const Tab(
            icon: Icon(
          Icons.play_arrow_rounded,
          size: 38,
        )),
      ],
    );
  }

  List<Widget> listOfWidgetsAboveTapBars(
      UserPersonalInfo userInfo, double bodyHeight) {
    return [
      GestureDetector(
        onVerticalDragStart: (e) async {
          setState(() {
            loading = true;
          });
          await widget.getData();
        },
        child: Column(
          children: [
            AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                switchInCurve: Curves.easeIn,
                child: loading ? customDragLoading(bodyHeight) : Container()),
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
        ]);
  }

  Widget personalNumbersInfo(
      List usersInfo, String text, UserPersonalInfo userInfo) {
    return Builder(builder: (builderContext) {
      return GestureDetector(
        onTap: () async {
          if (text != StringsManager.posts.tr()) {
            await Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => FollowersInfoPage(
                    userInfo: userInfo,
                    initialIndex:
                        usersInfo == userInfo.followerPeople ? 0 : 1)));

            BlocProvider.of<FirestoreUserInfoCubit>(context).getUserInfo(
                userInfo.userId,
                isThatMyPersonalId: widget.isThatMyPersonalId);
            setState(() {
              reBuild = true;
            });
          }
        },
        child: Column(
          children: [
            Text("${usersInfo.length}",
                style: getMediumStyle(
                    color: Theme.of(context).focusColor, fontSize: 20)),
            Text(text,
                style: getNormalStyle(
                    color: Theme.of(context).focusColor, fontSize: 15))
          ],
        ),
      );
    });
  }
}

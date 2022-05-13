import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:instagram/presentation/pages/followers_info_page.dart';
import 'package:instagram/presentation/widgets/custom_grid_view.dart';
import 'package:instagram/presentation/widgets/custom_videos_grid_view.dart';
import '../../data/models/user_personal_info.dart';
import 'circle_avatar_of_profile_image.dart';
import 'read_more_text.dart';

class ProfilePage extends StatefulWidget {
  String userId;
  bool isThatMyPersonalId;
  UserPersonalInfo userInfo;
  List<Widget> widgetsAboveTapBars;
  ProfilePage(
      {required this.widgetsAboveTapBars,
      required this.isThatMyPersonalId,
      required this.userInfo,
      required this.userId,
      Key? key})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool reBuild = false;

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
        // ),
      ),
    );
  }

  Widget tapBar() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: PostCubit.get(context)
        ..getPostsInfo(
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
          return Transform.scale(
              scale: 0.1,
              child: CircularProgressIndicator(
                  strokeWidth: 20, color: Theme.of(context).disabledColor));
        }
      },
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
          CustomGridView(postsInfo: imagesPostsInfo, userId: widget.userId),
          CustomVideosGridView(
              postsInfo: videosPostsInfo, userId: widget.userId),
          CustomGridView(postsInfo: imagesPostsInfo, userId: widget.userId),
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
      personalPhotoAndNumberInfo(userInfo, bodyHeight),
      Padding(
        padding: const EdgeInsetsDirectional.only(start: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userInfo.name, style: Theme.of(context).textTheme.headline2),
            ReadMore(userInfo.bio, 4),
            const SizedBox(height: 10),
            Row(
              children: widget.widgetsAboveTapBars,
            ),
          ],
        ),
      ),
    ];
  }

  Row personalPhotoAndNumberInfo(UserPersonalInfo userInfo, double bodyHeight) {
    String hash = "${userInfo.userId.hashCode}personal";
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Hero(
        tag: hash,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 15.0),
          child: CircleAvatarOfProfileImage(
              bodyHeight: bodyHeight * 1.45, userInfo: userInfo, hashTag: hash),
        ),
      ),
      personalNumbersInfo(userInfo.posts, StringsManager.posts.tr(), userInfo),
      personalNumbersInfo(
          userInfo.followerPeople, StringsManager.followers.tr(), userInfo),
      personalNumbersInfo(
          userInfo.followedPeople, StringsManager.following.tr(), userInfo),
    ]);
  }

  Expanded personalNumbersInfo(
      List usersInfo, String text, UserPersonalInfo userInfo) {
    return Expanded(
      child: Builder(builder: (builderContext) {
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
      }),
    );
  }
}

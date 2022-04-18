import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/pages/followers_and_followings_info_page.dart';
import 'package:instegram/presentation/widgets/custom_grid_view.dart';
import 'package:instegram/presentation/widgets/custom_videos_grid_view.dart';
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

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return defaultTabController();
  }

  DefaultTabController defaultTabController() {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                listOfWidgetsAboveTapBars(widget.userInfo),
              ),
            ),
          ];
        },
        body: tapBar(),
      ),
    );
  }

  bool reBuild = false;
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
        }
        //else if (state is CubitPostFailed) {
        //   // ToastShow.toastStateError(state);
        //   // return const Center(child: Text("there is no posts..."));
        // }
        else {
          return Transform.scale(
              scale: 0.1,
              child: const CircularProgressIndicator(
                  strokeWidth: 20, color: Colors.black54));
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
          CustomGridView(
              postsInfo: imagesPostsInfo,
              userId: widget.userId,
              shrinkWrap: false),
          CustomVideosGridView(
              postsInfo: videosPostsInfo, userId: widget.userId),
          CustomGridView(
              postsInfo: imagesPostsInfo,
              userId: widget.userId,
              shrinkWrap: false),
        ],
      ),
    );
  }

  TabBar tabBarIcons() {
    return TabBar(
      tabs: [
        const Tab(icon: Icon(Icons.grid_on_sharp)),
        Tab(
            icon: SvgPicture.asset(
          "assets/icons/video.svg",
          color: Colors.black,
          height: 22.5,
        )),
        const Tab(
            icon: Icon(
          Icons.play_arrow_outlined,
          size: 38,
        )),
      ],
    );
  }

  List<Widget> listOfWidgetsAboveTapBars(UserPersonalInfo userInfo) {
    return [
      personalPhotoAndNumberInfo(userInfo),
      Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userInfo.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Row personalPhotoAndNumberInfo(UserPersonalInfo userInfo) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CircleAvatarOfProfileImage(
          circleAvatarName: '',
          bodyHeight: 900,
          thisForStoriesLine: false,
          imageUrl: userInfo.profileImageUrl),
      personalNumbersInfo(userInfo.posts, "Posts", userInfo),
      personalNumbersInfo(userInfo.followerPeople, "Followers", userInfo),
      personalNumbersInfo(userInfo.followedPeople, "Following", userInfo),
    ]);
  }

  Expanded personalNumbersInfo(
      List usersInfo, String text, UserPersonalInfo userInfo) {
    return Expanded(
      child: Builder(builder: (builderContext) {
        return InkWell(
          onTap: () async {
            if (text != 'Posts') {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FollowersAndFollowingsInfoPage(
                      userInfo: userInfo,
                      initialIndex:
                          usersInfo == userInfo.followerPeople ? 0 : 1)));

              BlocProvider.of<FirestoreUserInfoCubit>(context)
                  .getUserInfo(userInfo.userId, widget.isThatMyPersonalId);
              setState(() {
                reBuild = true;
              });
            }
          },
          child: Column(
            children: [
              Text("${usersInfo.length}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
              Text(text, style: const TextStyle(fontSize: 15))
            ],
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

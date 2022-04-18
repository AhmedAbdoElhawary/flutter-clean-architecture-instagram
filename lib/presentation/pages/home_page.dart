import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:instegram/presentation/widgets/custom_app_bar.dart';
import 'package:instegram/presentation/widgets/post_list_view.dart';
import 'package:instegram/presentation/widgets/smart_refresher.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/circle_avatar_of_profile_image.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool rebuild = true;
  bool loadingPosts = true;
  bool reLoadData = false;
  UserPersonalInfo? personalInfo;

  Future<void> getData() async {
    reLoadData = false;
    FirestoreUserInfoCubit userCubit =
        BlocProvider.of<FirestoreUserInfoCubit>(context, listen: false);
    await userCubit.getUserInfo(widget.userId, true).then((value) async {

      personalInfo = userCubit.myPersonalInfo;

      List usersIds =
          personalInfo!.followedPeople + personalInfo!.followerPeople;

      SpecificUsersPostsCubit usersPostsCubit =
          BlocProvider.of<SpecificUsersPostsCubit>(context, listen: false);

      await usersPostsCubit
          .getSpecificUsersPostsInfo(usersIds: usersIds)
          .then((value) async {

        List usersPostsIds = usersPostsCubit.usersPostsInfo;

        List postsIds = usersPostsIds + personalInfo!.posts;

        PostCubit postCubit = PostCubit.get(context);
        await postCubit
            .getPostsInfo(postsIds: postsIds, isThatForMyPosts: true)
            .then((value) {

          Future.delayed(Duration.zero, () {
            setState(() {});
          });
          reLoadData = true;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    if (rebuild) {
      getData();
      rebuild = false;
    }
    return Scaffold(
      appBar: customAppBar(),
      body: SmarterRefresh(
        onRefreshData: getData,
        smartRefresherChild: blocBuilder(bodyHeight),
      ),
    );
  }

  BlocBuilder<PostCubit, PostState> blocBuilder(double bodyHeight) {
    return BlocBuilder<PostCubit, PostState>(
      buildWhen: (previous, current) {
        if (reLoadData &&
            current is CubitMyPersonalPostsLoaded) {
          reLoadData = false;
          return true;
        }

        if (
        previous != current &&current is CubitMyPersonalPostsLoaded) {
          return true;
        }
        if (
        previous != current && current is CubitPostFailed) {
          return true;
        }
        return false;
      },
      builder: (BuildContext context, PostState state) {
        if (state is CubitMyPersonalPostsLoaded) {
          return columnOfWidgets(bodyHeight, state.postsInfo);
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return const Center(child: Text("There's no posts..."));
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: Colors.black54),
          );
        }
      },
    );
  }

  Widget columnOfWidgets(
      double bodyHeight, List<Post> postsInfo) {
    return SingleChildScrollView(
      child: Column(
        children: [
          storiesLines(bodyHeight, postsInfo),
          const Divider(thickness: 0.5),
          posts(postsInfo),
        ],
      ),
    );
  }

  Widget posts(List<Post> postsInfo) {
    return ImageList(postsInfo: postsInfo);
  }

  Widget storiesLines(double bodyHeight, List<Post> postsInfo) {
    return SizedBox(
      width: double.infinity,
      height: bodyHeight * 0.155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: postsInfo.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          UserPersonalInfo publisherInfo = postsInfo[index].publisherInfo!;
          return CircleAvatarOfProfileImage(
            circleAvatarName:
                publisherInfo.name.isNotEmpty ? publisherInfo.name : '',
            bodyHeight: bodyHeight,
            thisForStoriesLine: true,
            imageUrl: publisherInfo.profileImageUrl.isNotEmpty
                ? publisherInfo.profileImageUrl
                : '',
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

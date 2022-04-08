import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/widgets/custom_app_bar.dart';
import 'package:instegram/presentation/widgets/post_list_view.dart';
import 'package:instegram/presentation/widgets/smart_refresher.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/circle_avatar_of_profile_image.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  List postsInfo;
  final bool isThatMyPosts;

  HomeScreen(
      {Key? key,
      required this.isThatMyPosts,
      required this.userId,
      required this.postsInfo})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool rebuild = true;
  bool loadingPosts = true;
  bool loadingStories = true;
  UserPersonalInfo? personalInfo;

  Future<void> getData(bool reload) async {
    personalInfo =
        BlocProvider.of<FirestoreUserInfoCubit>(context, listen: false)
            .myPersonalInfo;
    setState(() {
      loadingStories = false;
    });

    if (widget.isThatMyPosts) {
      widget.postsInfo = personalInfo!.posts +
          personalInfo!.followedPeople +
          personalInfo!.followerPeople;
      PostCubit postCubit = PostCubit.get(context);
      await postCubit.getPostsInfo(widget.postsInfo, widget.isThatMyPosts);
    }
    if (!reload) loadingPosts = false;
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    rebuild = true;

    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    if (rebuild) {
      getData(false);
      rebuild = false;
    }
    return Scaffold(
      appBar: customAppBar(),
      body: SmarterRefresh(
        onRefreshData: getData(true),
        smartRefresherChild: blocBuilder(bodyHeight),
      ),
    );
  }

  BlocBuilder<PostCubit, PostState> blocBuilder(double bodyHeight) {
    return BlocBuilder<PostCubit, PostState>(
      buildWhen: (previous, current) => (previous != current &&
          ((current is CubitMyPostsInfoLoaded && widget.isThatMyPosts) ||
              (current is CubitPostsInfoLoaded && !widget.isThatMyPosts))),
      builder: (BuildContext context, PostState state) {
        if (state is CubitMyPostsInfoLoaded && widget.isThatMyPosts) {
          return columnOfWidgets(bodyHeight, state.postsInfo);
        } else if (state is CubitPostsInfoLoaded && !widget.isThatMyPosts) {
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

  SingleChildScrollView columnOfWidgets(
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
    if (loadingPosts) {
      return const Center(
        child:
            CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black54),
      );
    } else {
      return CustomPostListView(postsInfo: postsInfo);
    }
  }

  Widget storiesLines(double bodyHeight, List<Post> postsInfo) {
    return SizedBox(
      width: double.infinity,
      height: bodyHeight * 0.155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
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
  bool get wantKeepAlive => true;
}

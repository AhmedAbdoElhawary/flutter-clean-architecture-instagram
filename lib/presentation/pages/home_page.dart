import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/widgets/read_more_text.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/circle_avatar_name.dart';
import '../widgets/circle_avatar_of_profile_image.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  List postsInfoIds = [];
  bool isThatUserPosts;

  HomeScreen(
      {Key? key,
      this.isThatUserPosts = true,
      required this.userId,
      List? postsInfoIds})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  bool loadingStories = true;
  bool loadingPosts = true;
  bool rebuild=true;

  bool isLiked = false;
  bool isSaved = false;
  bool isItDone = false;
  UserPersonalInfo? personalInfo;
  void getData() async {
    personalInfo =
        BlocProvider.of<FirestoreUserInfoCubit>(context, listen: false)
            .personalInfo;
    setState(() {
      loadingStories = false;
    });

    if (widget.isThatUserPosts) {
      widget.postsInfoIds = personalInfo!.posts +
          personalInfo!.followedPeople +
          personalInfo!.followerPeople;
      PostCubit postCubit = PostCubit.get(context);
      await postCubit.getPostInfo(widget.postsInfoIds);
    }

    setState(() {
      loadingPosts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    if(rebuild) {
      getData();
      rebuild=false;
    }
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            storiesLines(bodyHeight),
            const Divider(thickness: 0.5),
            posts(bodyHeight),
          ],
        ),
      ),
    );
    // }
  }

  Widget posts(double bodyHeight) {
    if (loadingPosts) {
      return const Center(
        child:
            CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black54),
      );
    } else {
      return BlocBuilder<PostCubit, PostState>(
        buildWhen: (previous, current) {
          if (previous is CubitPostLoaded || current is CubitPostLoaded) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is CubitPostsInfoLoaded && personalInfo != null) {
            return ListView.separated(
              itemCount: state.postsInfo.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return thePostsOfHomePage(state.postsInfo[index], bodyHeight);
              },
            );
          } else if (state is CubitPostFailed) {
            ToastShow.toastStateError(state);
            return const Center(child: Text("There's no posts..."));
          } else {
            return const CircularProgressIndicator(
                strokeWidth: 1.5, color: Colors.black54);
          }
        },
      );
    }
  }

  Widget storiesLines(double bodyHeight) {
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
      builder: (context, state) {
        if (state is CubitUserLoaded) {
          return SizedBox(
            width: double.infinity,
            height: bodyHeight * 0.155,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                String circleAvatarName = "Ahmed";
                return CircleAvatarOfProfileImage(
                  circleAvatarName: state.userPersonalInfo.name.isNotEmpty
                      ? personalInfo!.name
                      : circleAvatarName,
                  bodyHeight: bodyHeight,
                  thisForStoriesLine: true,
                  imageUrl: state.userPersonalInfo.profileImageUrl.isNotEmpty
                      ? state.userPersonalInfo.profileImageUrl
                      : '',
                );
              },
            ),
          );
        } else if (state is CubitGetUserInfoFailed) {
          return Container();
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: Colors.black54),
          );
        }
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      title: SvgPicture.asset(
        "assets/icons/ic_instagram.svg",
        height: 32,
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/heart.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/send.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget thePostsOfHomePage(Post postInfo, double bodyHeight) {
    return SizedBox(
      width: double.infinity,
      // height: 200,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: CircleAvatarOfProfileImage(
                circleAvatarName: postInfo.publisherInfo!.name,
                bodyHeight: bodyHeight / 2,
                thisForStoriesLine: false,
                imageUrl: postInfo.publisherInfo!.profileImageUrl,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
                child: NameOfCircleAvatar(postInfo.publisherInfo!.name, false)),
            menuButton()
          ],
        ),
        imageOfPost(postInfo.postImageUrl),
        Row(children: [
          Expanded(
              child: Row(
            children: [
              loveButton(),
              IconButton(
                icon: iconsOfImagePost("assets/icons/comment.svg"),
                onPressed: () {},
              ),
              IconButton(
                icon: iconsOfImagePost("assets/icons/send.svg"),
                onPressed: () {},
              ),
            ],
          )),
          IconButton(
            icon: isSaved
                ? const Icon(
                    Icons.bookmark_border,
                  )
                : const Icon(
                    Icons.bookmark,
                  ),
            onPressed: () {
              setState(() {
                isSaved = isSaved ? false : true;
              });
            },
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(left: 11.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (postInfo.likes.isNotEmpty) numbersOfLikes(postInfo),
              const SizedBox(height: 5),
              ReadMore(
                  "${postInfo.publisherInfo!.name} ${postInfo.caption}", 2),
              const SizedBox(height: 5),
              const SizedBox(height: 8),
              addCommentRow(postInfo, personalInfo!)
            ],
          ),
        )
      ]),
    );
  }

  IconButton loveButton() {
    return IconButton(
      icon: isLiked
          ? const Icon(
              Icons.favorite_border,
            )
          : const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
      onPressed: () {
        setState(() {
          isLiked = isLiked ? false : true;
        });
      },
    );
  }

  Row addCommentRow(Post postInfo, UserPersonalInfo personalInfo) {
    String imageUrl = postInfo.publisherInfo!.profileImageUrl;
    return Row(
      children: [
        CircleAvatar(
            radius: 16,
            backgroundColor: Colors.black12,
            child: imageUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : ClipOval(child: Image.network(imageUrl))),
        const SizedBox(width: 10),
        const Text(
          "Add a comment...",
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget numbersOfLikes(Post postInfo) {
    return InkWell(
      onTap: () {},
      child: Text('${postInfo.likes.length} Likes',
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }

  SvgPicture iconsOfImagePost(String path) {
    return SvgPicture.asset(
      path,
      color: Colors.black,
      height: 28,
    );
  }

  Widget imageOfPost(String imageUrl) {
    return InkWell(
      onDoubleTap: () {
        setState(() {
          isLiked = isLiked ? false : true;
        });
      },
      child: Image(
        width: double.infinity,
        fit: BoxFit.fitWidth,
        image: NetworkImage(imageUrl),
      ),
    );
  }

  IconButton menuButton() {
    return IconButton(
      icon: SvgPicture.asset(
        "assets/icons/menu_horizontal.svg",
        color: Colors.black,
        height: 23,
      ),
      color: Colors.black,
      onPressed: () {},
    );
  }

  @override
  bool get wantKeepAlive => true;
}

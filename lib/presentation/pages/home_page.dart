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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLiked = false;
  bool isSaved = false;
  bool isItDone = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: bodyHeight * 0.155,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  String circleAvatarName = "Ahmed";
                  return Builder(builder: (context) {
                    UserPersonalInfo? userInfo =
                        context.watch<FirestoreUserInfoCubit>().personalInfo;
                    return CircleAvatarOfProfileImage(
                      circleAvatarName:
                          userInfo != null ? userInfo.name : circleAvatarName,
                      bodyHeight: bodyHeight,
                      thisForStoriesLine: true,
                      imageUrl:
                          userInfo != null ? userInfo.profileImageUrl : '',
                    );
                  });
                },
              ),
            ),
            const Divider(thickness: 0.5),

            //TODO for now (it's not for all user, it'll make errors)

            BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                List<Post>? postsInfo;
                if (state is CubitPostsInfoLoaded) {
                  postsInfo = state.postsInfo;
                  //TODO it's so slow
                  // WidgetsBinding.instance!.addPostFrameCallback((_) async {
                  //   setState(() {
                      isItDone = true;
                  //   });
                  // });
                } else if (state is CubitPostFailed) {
                  ToastShow.toastStateError(state);
                }

                return
                  isItDone
                    ?
                  ListView.separated(
                        itemCount: postsInfo!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          return thePostsOfHomePage(
                              postsInfo![index], bodyHeight);
                        },
                      )
                    :
                const CircularProgressIndicator(
                    strokeWidth: 1.5, color: Colors.black54);
              },
            ),
          ],
        ),
      ),
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
                circleAvatarName: postInfo.publisherName,
                bodyHeight: bodyHeight / 2,
                thisForStoriesLine: false,
                imageUrl: postInfo.publisherProfileImageUrl,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(child: NameOfCircleAvatar(postInfo.publisherName, false)),
            menuButton()
          ],
        ),
        imageOfPost(postInfo.postImageUrl),
        Row(children: [
          Expanded(
              child: Row(
            children: [
              IconButton(
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
              ),
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
              numbersOfLikes(postInfo),
              const SizedBox(height: 5),
              ReadMore("${postInfo.publisherName} ${postInfo.caption}", 2),
              const SizedBox(height: 5),
              const Text("View all 171 comment...",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              addCommentRow(postInfo)
            ],
          ),
        )
      ]),
    );
  }

  Row addCommentRow(Post postInfo) {
    return Row(
      children: [
        CircleAvatar(
            radius: 16,
            backgroundColor: Colors.black12,
            child: postInfo.publisherProfileImageUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : ClipOval(child: Image.network(postInfo.publisherProfileImageUrl))),
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
}

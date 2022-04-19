import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instegram/presentation/pages/comments_page.dart';
import 'package:instegram/presentation/pages/play_this_video.dart';
import 'package:instegram/presentation/pages/show_me_who_are_like.dart';
import 'package:instegram/presentation/pages/which_profile_page.dart';
import 'package:instegram/presentation/widgets/circle_avatar_name.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:instegram/presentation/widgets/read_more_text.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class ImageList extends StatefulWidget {
  // final VoidCallback callback;
  final List postsInfo;

  const ImageList({Key? key, required this.postsInfo}) : super(key: key);

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        InViewNotifierList(
          primary: false,
          scrollDirection: Axis.vertical,
          initialInViewIds: const ['0'],
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          isInViewPortCondition:
              (double deltaTop, double deltaBottom, double viewPortDimension) {
            return
              deltaTop < (0.5 * viewPortDimension) &&
                  deltaBottom > (0.5 * viewPortDimension);
          },
          itemCount:widget.postsInfo.length ,
          builder: (BuildContext context, int index) {
            return Container(
              width: double.infinity,
              // color: Colors.black45,
              // height: 100.0,
              // alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 0.5),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return InViewNotifierWidget(

                    id: '$index',
                    builder: (_, bool isInView, __) {
                      if (isInView) {
                        // inViewIndex = index.toString();
                        // widget.callback();
                        print(
                            "iffffffffffffffffffffffffffffffffffffffffffffffffff======== ${index} => $isInView");
                      }
                      print(
                          "============================================================= ${index} => $isInView");
                      // Future.delayed(Duration.zero, () {
                      //   setState(() {
                      //     isInView;
                      //   });
                      // });
                      print("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| ${widget.postsInfo.length}");
                      return thePostsOfHomePage(
                          postInfo: widget.postsInfo[index],
                          bodyHeight: bodyHeight,
                          isInView: isInView);
                    },
                  );
                },
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 3.0,
            color: Colors.redAccent,
          ),
        )
      ],
    );
  }

  pushToProfilePage(Post postInfo) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WhichProfilePage(userId: postInfo.publisherId),
      ));

  Widget thePostsOfHomePage(
      {required Post postInfo,
      required double bodyHeight,
      required bool isInView}) {
    return SizedBox(
      width: double.infinity,
      // height: 200,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: InkWell(
                onTap: () => pushToProfilePage(postInfo),
                child: CircleAvatarOfProfileImage(
                  circleAvatarName: postInfo.publisherInfo!.name,
                  bodyHeight: bodyHeight / 2,
                  thisForStoriesLine: false,
                  imageUrl: postInfo.publisherInfo!.profileImageUrl,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
                child: InkWell(
                    onTap: () => pushToProfilePage(postInfo),
                    child: NameOfCircleAvatar(
                        postInfo.publisherInfo!.name, false))),
            menuButton()
          ],
        ),
        imageOfPost(postInfo, isInView),
        Row(children: [
          Expanded(
              child: Row(
            children: [
              loveButton(postInfo),
              IconButton(
                icon: iconsOfImagePost(IconsAssets.commentIcon),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(CupertinoPageRoute(
                    builder: (context) =>
                        CommentsPage(postId: postInfo.postUid),
                  ));
                },
              ),
              IconButton(
                icon: iconsOfImagePost(IconsAssets.sendIcon),
                onPressed: () {
                  // Navigator.of(context,
                  // ).push(CupertinoPageRoute(
                  //
                  //   builder: (context) =>
                  //       MassagesPage(postInfo.publisherId),
                  // ));
                },
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
              if (postInfo.likes.isNotEmpty) numberOfLikes(postInfo),
              const SizedBox(height: 5),
              ReadMore(
                  "${postInfo.publisherInfo!.name} ${postInfo.caption}", 2),
              const SizedBox(height: 5),
              const SizedBox(height: 8),
              addCommentRow(postInfo)
            ],
          ),
        )
      ]),
    );
  }

  Widget loveButton(Post postInfo) {
    bool isLiked = postInfo.likes.contains(myPersonalId);
    return GestureDetector(
      child: !isLiked
          ? const Icon(
              Icons.favorite_border,
            )
          : const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
      onTap: () {
        setState(() {
          if (isLiked) {
            BlocProvider.of<PostLikesCubit>(context).removeTheLikeOnThisPost(
                postId: postInfo.postUid, userId: myPersonalId);
            postInfo.likes.remove(myPersonalId);
          } else {
            BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                postId: postInfo.postUid, userId: myPersonalId);
            postInfo.likes.add(myPersonalId);
          }
        });
      },
    );
  }

  Row addCommentRow(Post postInfo) {
    String imageUrl = postInfo.publisherInfo!.profileImageUrl;
    return Row(
      children: [
        CircleAvatar(
            radius: 16,
            backgroundColor: Colors.black12,
            child: imageUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : ClipOval(
                    child: Image.network(
                    imageUrl,
                  ))),
        const SizedBox(width: 10),
        const Text(
          "Add a comment...",
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget numberOfLikes(Post postInfo) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UsersWhoLikesOnPostPage(
                  showSearchBar: true,
                  usersIds: postInfo.likes,
                )));
      },
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

  Widget imageOfPost(Post postInfo, bool isInView) {
    print("||||||||||||||||||||||||| $isInView");
    return InkWell(
      onDoubleTap: () {},
      child: postInfo.isThatImage
          ? buildImage(postInfo)
          : PlayThisVideo(videoUrl: postInfo.postUrl, play: isInView),
    );
  }

  Image buildImage(Post postInfo) {
    return Image.network(
      postInfo.postUrl,
      width: double.infinity,
      fit: BoxFit.fitWidth,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const SizedBox(
          width: double.infinity,
          height: 300,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.black87,
              strokeWidth: 1,
            ),
          ),
        );
      },
    );
  }

  IconButton menuButton() {
    return IconButton(
      icon: SvgPicture.asset(
        IconsAssets.menuHorizontalIcon,
        color: Colors.black,
        height: 23,
      ),
      color: Colors.black,
      onPressed: () {},
    );
  }
}

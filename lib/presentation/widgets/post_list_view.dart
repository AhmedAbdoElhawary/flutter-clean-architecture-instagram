import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/globall.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instegram/presentation/pages/comments_page.dart';
import 'package:instegram/presentation/pages/play_this_video.dart';
import 'package:instegram/presentation/pages/show_me_who_are_like.dart';
import 'package:instegram/presentation/pages/which_profile_page.dart';
import 'package:instegram/presentation/widgets/circle_avatar_name.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:instegram/presentation/widgets/fade_animation.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';
import 'package:instegram/presentation/widgets/picture_viewer.dart';
import 'package:instegram/presentation/widgets/read_more_text.dart';

class ImageList extends StatefulWidget {
  final Post postInfo;
  final bool playTheVideo;
  final TextEditingController textController;
  final ValueChanged<Post> selectedPostInfo;
  final double bodyHeight;

  const ImageList({
    Key? key,
    required this.postInfo,
    required this.selectedPostInfo,
    required this.textController,
    required this.playTheVideo,
    required this.bodyHeight,
  }) : super(key: key);

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  bool isSaved = false;
  late Size imageSize = const Size(0.0, 0.0);
  late Widget videoStatusAnimation;

  @override
  void initState() {
    super.initState();
    videoStatusAnimation = Container();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return thePostsOfHomePage(
      postInfo: widget.postInfo,
      bodyHeight: bodyHeight,
    );
  }

  pushToProfilePage(Post postInfo) =>
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => WhichProfilePage(userId: postInfo.publisherId),
      ));

  Widget thePostsOfHomePage({
    required Post postInfo,
    required double bodyHeight,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10.0),
                  child: CircleAvatarOfProfileImage(
                    bodyHeight: bodyHeight * .5,
                    userInfo: postInfo.publisherInfo!,
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
            imageOfPost(postInfo),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 12.0, top: 10, bottom: 8),
              child: Row(children: [
                Expanded(
                    child: Row(
                  children: [
                    loveButton(postInfo),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 15.0),
                      child: GestureDetector(
                        child: iconsOfImagePost(IconsAssets.commentIcon),
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(CupertinoPageRoute(
                            builder: (context) =>
                                CommentsPage(postId: postInfo.postUid),
                          ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 15.0),
                      child: GestureDetector(
                        child: iconsOfImagePost(IconsAssets.send1Icon,
                            lowHeight: true),
                      ),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 12.0),
                  child: GestureDetector(
                    child: isSaved
                        ? const Icon(
                            Icons.bookmark_border,
                          )
                        : const Icon(
                            Icons.bookmark,
                          ),
                    onTap: () {
                      setState(() {
                        isSaved = isSaved ? false : true;
                      });
                    },
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 11.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (postInfo.likes.isNotEmpty) numberOfLikes(postInfo),
                  const SizedBox(height: 5),
                  ReadMore(
                      "${postInfo.publisherInfo!.name} ${postInfo.caption}", 2),
                  const SizedBox(height: 8),
                  if (postInfo.comments.isNotEmpty) numberOfComment(postInfo),
                  buildCommentBox(bodyHeight),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 5.0),
                    child: Text(
                      DateOfNow.chattingDateOfNow(
                          postInfo.datePublished, postInfo.datePublished),
                      style: getNormalStyle(color: Theme.of(context).cardColor),
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }

  Widget buildCommentBox(double bodyHeight) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: widget.textController.text.length < 70
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          children: [
            CircleAvatarOfProfileImage(
              userInfo: widget.postInfo.publisherInfo!,
              bodyHeight: bodyHeight * .5,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                cursorColor: ColorManager.teal,
                maxLines: null,
                readOnly: true,
                decoration: InputDecoration.collapsed(
                    hintText: StringsManager.addComment.tr(),
                    hintStyle: const TextStyle(
                        color: ColorManager.black26, fontSize: 14)),
                autofocus: false,
                controller: TextEditingController(),
                onTap: () {
                  // setState(() {
                  widget.selectedPostInfo(widget.postInfo);
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.textController.text = '❤';
                });
              },
              child: const Text('❤'),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.textController.text = '🙌';
                });
              },
              child: const Text('🙌'),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
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

  Widget numberOfComment(Post postInfo) {
    int commentsLength = postInfo.comments.length;
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(
          builder: (context) => CommentsPage(postId: postInfo.postUid),
        ));
      },
      child: Text(
        "${StringsManager.viewAll.tr()} $commentsLength ${commentsLength > 1 ? StringsManager.comments.tr() : StringsManager.comment.tr()}",
        style:Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Widget numberOfLikes(Post postInfo) {
    int likes = postInfo.likes.length;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => UsersWhoLikesOnPostPage(
                  showSearchBar: true,
                  usersIds: postInfo.likes,
                )));
      },
      child: Text(
          '$likes ${likes > 1 ? StringsManager.likes.tr() : StringsManager.like.tr()}',
          textAlign: TextAlign.left,
          style:Theme.of(context).textTheme.headline2),
    );
  }

  SvgPicture iconsOfImagePost(String path, {bool lowHeight = false}) {
    return SvgPicture.asset(
      path,
      color: Colors.black,
      height: lowHeight ? 22 : 25,
    );
  }

  Icon lovePopAnimation() {
    return  const Icon(
      Icons.favorite,
      size: 100,
      color: ColorManager.white,
    );
  }

  Widget imageOfPost(Post postInfo) {
    bool isLiked = postInfo.likes.contains(myPersonalId);

    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () {
            videoStatusAnimation = FadeAnimation(child: lovePopAnimation());

            setState(() {
              if (!isLiked) {
                BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                    postId: postInfo.postUid, userId: myPersonalId);
                postInfo.likes.add(myPersonalId);
              }
            });
          },
          onTap: () async {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) {
                  return PictureViewer(
                      postInfo: postInfo, imageUrl: postInfo.postUrl);
                },
              ),
            );
          },
          child: postInfo.isThatImage
              ? Hero(
                  tag: postInfo.postUrl,
                  child: CustomFadeInImage(
                    aspectRatio: postInfo.aspectRatio,
                    bodyHeight: widget.bodyHeight,
                    imageUrl: postInfo.postUrl,
                  ),
                )
              : PlayThisVideo(
                  videoUrl: postInfo.postUrl, play: widget.playTheVideo),
        ),
        Center(child: videoStatusAnimation),
      ],
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

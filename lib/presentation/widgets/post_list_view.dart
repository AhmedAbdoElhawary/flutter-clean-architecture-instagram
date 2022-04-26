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
import 'package:instegram/presentation/widgets/add_comment.dart';
import 'package:instegram/presentation/widgets/circle_avatar_name.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';
import 'package:instegram/presentation/widgets/picture_viewer.dart';
import 'package:instegram/presentation/widgets/read_more_text.dart';

class ImageList extends StatefulWidget {
  final Post postInfo;
  // final ValueGetter<bool> isVideoInView;

  const ImageList({
    Key? key,
    required this.postInfo,
    // required this.isVideoInView,
  }) : super(key: key);

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final TextEditingController _textController = TextEditingController();
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    print("--------------------------${ MediaQuery.of(context).viewInsets.bottom}");

    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return thePostsOfHomePage(
      postInfo: widget.postInfo,
      bodyHeight: bodyHeight,
      // isVideoInView: widget.isVideoInView,
    );
  }

  pushToProfilePage(Post postInfo) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WhichProfilePage(userId: postInfo.publisherId),
      ));

  Widget thePostsOfHomePage({
    required Post postInfo,
    required double bodyHeight,
    // required ValueGetter<bool> isVideoInView,
  }) {
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
                  bodyHeight: bodyHeight / 2,
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
        imageOfPost(
          postInfo,
          // isVideoInView,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 10, bottom: 8),
          child: Row(children: [
            Expanded(
                child: Row(
              children: [
                loveButton(postInfo),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
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
                  padding: const EdgeInsets.only(left: 15.0),
                  child: GestureDetector(
                    child: iconsOfImagePost(IconsAssets.send1Icon,
                        lowHeight: true),
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
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
          padding: const EdgeInsets.only(left: 11.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (postInfo.likes.isNotEmpty) numberOfLikes(postInfo),
              const SizedBox(height: 5),
              ReadMore(
                  "${postInfo.publisherInfo!.name} ${postInfo.caption}", 2),
              const SizedBox(height: 8),
              addCommentRow(postInfo),
              Padding(
                padding: const EdgeInsets.only(right:10.0),
                child: AddComment(
                  postId: widget.postInfo.postUid,
                  selectedCommentInfo: null,
                  textController: _textController,
                  userPersonalInfo: widget.postInfo.publisherInfo!,
                  makeSelectedCommentNullable: (){
                    setState(() {
                      _textController.text = '';
                    });
                  },
                ),
              ),
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

  Widget addCommentRow(Post postInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(
          builder: (context) => CommentsPage(postId: postInfo.postUid),
        ));
      },
      child: Text(
        "View all ${postInfo.comments.length} comments",
        style: const TextStyle(color: Colors.grey),
      ),
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

  SvgPicture iconsOfImagePost(String path, {bool lowHeight = false}) {
    return SvgPicture.asset(
      path,
      color: Colors.black,
      height: lowHeight ? 22 : 25,
    );
  }

  Widget imageOfPost(Post postInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return PictureViewer(imageUrl:  postInfo.postUrl);
            },
          ),
        );
      },
      child: postInfo.isThatImage
          ? Hero(
              tag: postInfo.postUrl,
              child: CustomFadeInImage(imageUrl: postInfo.postUrl))
          : PlayThisVideo(
              videoUrl: postInfo.postUrl,
              // isVideoInView: isVideoInView,
            ),
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

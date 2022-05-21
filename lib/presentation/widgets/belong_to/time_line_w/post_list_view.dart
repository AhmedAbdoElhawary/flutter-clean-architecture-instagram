import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/app_prefs.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/cubit/followCubit/follow_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/comments/comments_page.dart';
import 'package:instagram/presentation/pages/profile/update_post_info.dart';
import 'package:instagram/presentation/pages/video/play_this_video.dart';
import 'package:instagram/presentation/pages/profile/show_me_who_are_like.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/bottom_sheet.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/picture_viewer.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/points_scroll_bar.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_name.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/aimation/fade_animation.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_image_display.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/read_more_text.dart';
import 'package:like_button/like_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostImage extends StatefulWidget {
  final Post postInfo;
  final bool playTheVideo;
  final VoidCallback reLoadData;
  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;
  final double bodyHeight;

  const PostImage({
    Key? key,
    required this.postInfo,
    required this.reLoadData,
    required this.indexOfPost,
    required this.playTheVideo,
    required this.postsInfo,
    required this.bodyHeight,
  }) : super(key: key);

  @override
  State<PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> with TickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  ValueChanged<Post>? selectedPostInfo;
  bool isSaved = false;
  late Size imageSize = const Size(0.0, 0.0);
  late Widget videoStatusAnimation;
  String currentLanguage = 'en';
  int initPosition = 0;
  late TabController controller;

  @override
  void initState() {
    controller = TabController(
        vsync: this,
        length: widget.postInfo.imagesUrls.length,
        initialIndex: 0);
    videoStatusAnimation = Container();
    getLanguage();
    super.initState();
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

  getLanguage() async {
    AppPreferences _appPreferences = injector<AppPreferences>();
    currentLanguage = await _appPreferences.getAppLanguage();
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
          // mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatarOfProfileImage(
                    bodyHeight: bodyHeight * .5,
                    userInfo: postInfo.publisherInfo!,
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
            ),
            imageOfPost(postInfo),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 8, top: 10, bottom: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    loveButton(postInfo),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 5),
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
                      padding: const EdgeInsetsDirectional.only(start: 5.0),
                      child: GestureDetector(
                        child: iconsOfImagePost(IconsAssets.send1Icon,
                            lowHeight: true),
                      ),
                    ),
                    const Spacer(),
                    if (postInfo.imagesUrls.isNotEmpty)
                      PointsScrollBar(
                        photoCount: postInfo.imagesUrls.length,
                        activePhotoIndex: initPosition,
                      ),
                    const Spacer(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12.0),
                      child: GestureDetector(
                        child: isSaved
                            ? Icon(
                                Icons.bookmark_border,
                                color: Theme.of(context).focusColor,
                              )
                            : Icon(
                                Icons.bookmark,
                                color: Theme.of(context).focusColor,
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
                  if (currentLanguage == 'en') ...[
                    ReadMore(
                        "${postInfo.publisherInfo!.name} ${postInfo.caption}",
                        2),
                  ] else ...[
                    ReadMore(
                        "${postInfo.caption} ${postInfo.publisherInfo!.name}",
                        2),
                  ],
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
          crossAxisAlignment: textController.text.length < 70
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
                style: Theme.of(context).textTheme.bodyText1,
                cursorColor: ColorManager.teal,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                readOnly: true,
                decoration: InputDecoration.collapsed(
                    hintText: StringsManager.addComment.tr(),
                    hintStyle: TextStyle(
                        color: Theme.of(context).cardColor, fontSize: 14)),
                autofocus: false,
                controller: TextEditingController(),
                onTap: () {
                  // setState(() {
                  if (selectedPostInfo != null) {
                    selectedPostInfo!(widget.postInfo);
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  textController.text = '❤';
                });
              },
              child: const Text('❤'),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  textController.text = '🙌';
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
    return LikeButton(
      isLiked: isLiked,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      likeBuilder: (isLiked) {
        return !isLiked
            ? Icon(
                Icons.favorite_border,
                color: Theme.of(context).focusColor,
              )
            : const Icon(
                Icons.favorite,
                color: Colors.red,
              );
      },
      onTap: (isLiked) async {
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

        return !isLiked;
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
        style: Theme.of(context).textTheme.headline1,
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
          style: Theme.of(context).textTheme.headline2),
    );
  }

  SvgPicture iconsOfImagePost(String path, {bool lowHeight = false}) {
    return SvgPicture.asset(
      path,
      color: Theme.of(context).focusColor,
      height: lowHeight ? 22 : 28,
    );
  }

  Widget lovePopAnimation() {
    return Icon(
      Icons.favorite,
      size: 150,
      color: Theme.of(context).primaryColor,
    );
  }

  Widget imageOfPost(Post postInfo) {
    bool isLiked = postInfo.likes.contains(myPersonalId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
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
                        aspectRatio: postInfo.aspectRatio,
                        isThatImage: postInfo.isThatImage,
                        imageUrl: postInfo.postUrl.isNotEmpty
                            ? postInfo.postUrl
                            : postInfo.imagesUrls[initPosition]);
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 8.0),
              child: postInfo.isThatImage
                  ? (postInfo.imagesUrls.length > 1
                      ? imagesSlider(postInfo.imagesUrls)
                      : Hero(
                          tag: postInfo.postUrl,
                          child: ImageDisplay(
                            aspectRatio: postInfo.aspectRatio,
                            bodyHeight: widget.bodyHeight,
                            imageUrl: postInfo.postUrl,
                          ),
                        ))
                  : PlayThisVideo(
                      videoUrl: postInfo.postUrl, play: widget.playTheVideo),
            )),
        Center(child: videoStatusAnimation),
      ],
    );
  }

  void _updateImageIndex(int index, _) {
    setState(() => initPosition = index);
  }

  Widget imagesSlider(List<dynamic> imagesUrls) {
    return CarouselSlider(
      items: imagesUrls.map((url) {
        return Hero(
          tag: url,
          child: Image.network(
            url,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: _updateImageIndex,
      ),
    );
  }

  Widget menuButton() {
    return GestureDetector(
      child: SvgPicture.asset(
        IconsAssets.menuHorizontalIcon,
        color: Theme.of(context).focusColor,
        height: 23,
      ),
      onTap: () async => bottomSheet(),
    );
  }

  Future<void> bottomSheet() async {
    return CustomBottomSheet.bottomSheet(
      context,
      headIcon: shareThisPost(),
      bodyText: widget.postInfo.publisherId == myPersonalId
          ? ordersOfMyPost()
          : ordersOfOtherUser(),
    );
  }

  GestureDetector shareThisPost() {
    return GestureDetector(
      child: Column(
        children: [
          SvgPicture.asset(
            IconsAssets.shareCircle,
            height: 50,
            color: Theme.of(context).focusColor,
          ),
          const SizedBox(height: 10),
          buildText(StringsManager.share.tr()),
        ],
      ),
      onTap: () {},
    );
  }

  Widget ordersOfMyPost() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {}, child: textOfOrders(StringsManager.archive.tr())),
          deletePost(),
          editPost(),
          GestureDetector(
              onTap: () {},
              child: textOfOrders(StringsManager.hideLikeCount.tr())),
          GestureDetector(
              onTap: () {},
              child: textOfOrders(StringsManager.turnOffCommenting.tr())),
          Container(height: 10)
        ],
      ),
    );
  }

  BlocBuilder<PostCubit, PostState> deletePost() {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return GestureDetector(
          onTap: () async {
            Navigator.maybePop(context);
            await PostCubit.get(context)
                .deletePostInfo(postInfo: widget.postInfo);
            widget.postsInfo.value.removeAt(widget.indexOfPost);
          },
          child: textOfOrders(StringsManager.delete.tr()));
    });
  }

  BlocBuilder<PostCubit, PostState> editPost() {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return GestureDetector(
          onTap: () async {
            Navigator.maybePop(context);
            await Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(
              maintainState: false,
              builder: (context) =>
                  UpdatePostInfo(oldPostInfo: widget.postInfo),
            ));
          },
          child: textOfOrders(StringsManager.edit.tr()));
    });
  }

  Widget ordersOfOtherUser() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {}, child: textOfOrders(StringsManager.hide.tr())),
          Builder(builder: (context) {
            FollowCubit followCubit = BlocProvider.of<FollowCubit>(context);
            return GestureDetector(
                onTap: () async {
                  await followCubit.removeThisFollower(
                      followingUserId: widget.postInfo.publisherId,
                      myPersonalId: myPersonalId);
                  setState(() {
                    widget.reLoadData();
                    widget.postsInfo.value.remove(widget.postInfo);
                  });
                },
                child: textOfOrders(StringsManager.unfollow.tr()));
          }),
          Container(height: 10)
        ],
      ),
    );
  }

  Widget textOfOrders(String text) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          buildText(text),
        ],
      ),
    );
  }

  Widget buildText(String text) {
    return Text(text,
        style:
            getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15));
  }
}

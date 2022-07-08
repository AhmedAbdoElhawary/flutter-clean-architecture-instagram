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
import 'package:instagram/presentation/pages/time_line/my_own_time_line/update_post_info.dart';
import 'package:instagram/presentation/pages/video/play_this_video.dart';
import 'package:instagram/presentation/pages/profile/show_me_who_are_like.dart';
import 'package:instagram/presentation/widgets/belong_to/comments_w/comment_box.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/bottom_sheet.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/image_slider.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/picture_viewer.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/points_scroll_bar.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/send_to_users.dart';
import 'package:instagram/presentation/widgets/global/aimation/like_popup_animation.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_name.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/read_more_text.dart';
import 'package:like_button/like_button.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PostImage extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
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
  final ValueNotifier<TextEditingController> commentTextController =
      ValueNotifier(TextEditingController());
  ValueChanged<Post>? selectedPostInfo;
  final TextEditingController _bottomSheetMessageTextController =
      TextEditingController();
  final TextEditingController _bottomSheetSearchTextController =
      TextEditingController();
  ValueNotifier<bool> isSaved = ValueNotifier(false);
  late Size imageSize = const Size(0.0, 0.0);
  String currentLanguage = 'en';
  ValueNotifier<int> initPosition = ValueNotifier(0);

  bool isLiked = false;
  bool isHeartAnimation = false;
  @override
  void initState() {
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
    required double bodyHeight,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatarOfProfileImage(
                      bodyHeight: bodyHeight * .5,
                      userInfo: postInfoValue.publisherInfo!,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                        child: InkWell(
                            onTap: () => pushToProfilePage(postInfoValue),
                            child: NameOfCircleAvatar(
                                postInfoValue.publisherInfo!.name, false))),
                    menuButton()
                  ],
                ),
              ),
              imageOfPost(postInfoValue),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 8, top: 10, bottom: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      loveButton(postInfoValue),
                      commentButton(context, postInfoValue),
                      shareButton(),
                      const Spacer(),
                      if (postInfoValue.imagesUrls.isNotEmpty)
                        scrollBar(postInfoValue),
                      const Spacer(),
                      const Spacer(),
                      saveButton(),
                    ]),
              ),
              imageCaption(postInfoValue, bodyHeight, context)
            ]),
      ),
    );
  }

  ValueListenableBuilder<int> scrollBar(Post postInfoValue) {
    return ValueListenableBuilder(
      valueListenable: initPosition,
      builder: (context, int positionValue, child) => PointsScrollBar(
        photoCount: postInfoValue.imagesUrls.length,
        activePhotoIndex: positionValue,
      ),
    );
  }

  Padding imageCaption(
      Post postInfoValue, double bodyHeight, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (postInfoValue.likes.isNotEmpty) numberOfLikes(postInfoValue),
          const SizedBox(height: 5),
          if (currentLanguage == 'en') ...[
            ReadMore(
                "${postInfoValue.publisherInfo!.name} ${postInfoValue.caption}",
                2),
          ] else ...[
            ReadMore(
                "${postInfoValue.caption} ${postInfoValue.publisherInfo!.name}",
                2),
          ],
          const SizedBox(height: 8),
          if (postInfoValue.comments.isNotEmpty) numberOfComment(postInfoValue),
          buildCommentBox(bodyHeight),
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 5.0),
            child: Text(
              DateOfNow.chattingDateOfNow(
                  postInfoValue.datePublished, postInfoValue.datePublished),
              style: getNormalStyle(color: Theme.of(context).bottomAppBarColor),
            ),
          ),
        ],
      ),
    );
  }

  ValueListenableBuilder<bool> saveButton() {
    return ValueListenableBuilder(
      valueListenable: isSaved,
      builder: (context, bool isSavedValue, child) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 12.0),
        child: GestureDetector(
          child: isSavedValue
              ? Icon(
                  Icons.bookmark_border,
                  color: Theme.of(context).focusColor,
                )
              : Icon(
                  Icons.bookmark,
                  color: Theme.of(context).focusColor,
                ),
          onTap: () {
            isSaved.value = !isSaved.value;
          },
        ),
      ),
    );
  }

  Padding shareButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15.0),
      child: GestureDetector(
        child: iconsOfImagePost(IconsAssets.send1Icon, lowHeight: true),
        onTap: () async => draggableBottomSheet(),
      ),
    );
  }

  Future<void> draggableBottomSheet() async {
    return showSlidingBottomSheet<void>(
      context,
      builder: (BuildContext context) => SlidingSheetDialog(
        cornerRadius: 16,
        color: Theme.of(context).primaryColor,
        snapSpec: const SnapSpec(
          initialSnap: 1,
          snappings: [.4, 1, .7],
        ),
        builder: buildSheet,
        headerBuilder: (context, state) => Material(
          child: upperWidgets(context),
        ),
      ),
    );
  }

  Column upperWidgets(BuildContext context) {
    String postImageUrl = widget.postInfo.value.imagesUrls.length > 1
        ? widget.postInfo.value.imagesUrls[0]
        : widget.postInfo.value.postUrl;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 10),
          child: Container(
            width: 45,
            height: 4.5,
            decoration: BoxDecoration(
              color: Theme.of(context).textTheme.headline4!.color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: 50,
                height: 45,
                decoration: BoxDecoration(
                  color: ColorManager.grey,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(postImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: TextField(
                controller: _bottomSheetMessageTextController,
                cursorColor: ColorManager.teal,
                decoration: InputDecoration(
                  hintText: StringsManager.writeMessage.tr(),
                  hintStyle: const TextStyle(
                    color: ColorManager.grey,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        Padding(
          padding:
              const EdgeInsetsDirectional.only(top: 30.0, end: 20, start: 20),
          child: Container(
            width: double.infinity,
            height: 35,
            decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              cursorColor: ColorManager.teal,
              style: Theme.of(context).textTheme.bodyText1,
              controller: _bottomSheetSearchTextController,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: ColorManager.lowOpacityGrey,
                  ),
                  contentPadding: const EdgeInsetsDirectional.all(12),
                  hintText: StringsManager.search.tr(),
                  hintStyle: Theme.of(context).textTheme.headline1,
                  border: InputBorder.none),
              onChanged: (_) => setState(() {}),
            ),
          ),
        )
      ],
    );
  }

  clearTextsController() {
    setState(() {
      _bottomSheetMessageTextController.clear();
      _bottomSheetSearchTextController.clear();
    });
  }

  Widget buildSheet(context, state) => Material(
        child: SendToUsers(
          userInfo: widget.postInfo.value.publisherInfo!,
          messageTextController: _bottomSheetMessageTextController,
          postInfo: widget.postInfo.value,
          clearTexts: clearTextsController,
        ),
      );

  Padding commentButton(BuildContext context, Post postInfoValue) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 5),
      child: GestureDetector(
        child: iconsOfImagePost(IconsAssets.commentIcon),
        onTap: () {
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(
            builder: (context) => CommentsPage(postId: postInfoValue.postUid),
          ));
        },
      ),
    );
  }

  void _showAddCommentModal() {
    double media = MediaQuery.of(context).viewInsets.bottom;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.only(bottom: media),
            child: ValueListenableBuilder(
              valueListenable: commentTextController,
              builder: (context, TextEditingController textValue, child) =>
                  CommentBox(

                    isThatCommentScreen: false,
                postId: widget.postInfo.value.postUid,
                textController: textValue,
                focusNode: FocusNode(),
                userPersonalInfo: widget.postInfo.value.publisherInfo!,
                makeSelectedCommentNullable: makeSelectedCommentNullable,

              ),
            ),
          ),
        );
      },
    );
  }

  makeSelectedCommentNullable(bool isThatComment) {
    widget.postInfo.value.comments.add(" ");
    commentTextController.value.text = '';
    Navigator.maybePop(context);
  }

  Widget buildCommentBox(double bodyHeight) {
    return GestureDetector(
      onTap: _showAddCommentModal,
      child: ValueListenableBuilder(
        valueListenable: commentTextController,
        builder: (context, TextEditingController textValue, child) => Row(
          crossAxisAlignment: textValue.text.length < 70
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          children: [
            CircleAvatarOfProfileImage(
              userInfo: widget.postInfo.value.publisherInfo!,
              bodyHeight: bodyHeight * .5,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: GestureDetector(
                child: Text(
                  StringsManager.addComment.tr(),
                  style: TextStyle(
                      color: Theme.of(context).bottomAppBarColor, fontSize: 14),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                commentTextController.value.text = '❤';
                _showAddCommentModal();
              },
              child: const Text('❤'),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                commentTextController.value.text = '🙌';
                _showAddCommentModal();
              },
              child: const Text('🙌'),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              isHeartAnimation = true;
              this.isLiked = true;
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
                  return ValueListenableBuilder(
                    valueListenable: initPosition,
                    builder: (context, int positionValue, child) =>
                        PictureViewer(
                      blurHash: postInfo.blurHash,
                      aspectRatio: postInfo.aspectRatio,
                      isThatImage: postInfo.isThatImage,
                      imageUrl: postInfo.postUrl.isNotEmpty
                          ? postInfo.postUrl
                          : postInfo.imagesUrls[positionValue],
                    ),
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 8.0),
            child: postInfo.isThatImage
                ? (postInfo.imagesUrls.length > 1
                    ? ImagesSlider(
                        blurHash: postInfo.blurHash,
                        aspectRatio: postInfo.aspectRatio,
                        imagesUrls: postInfo.imagesUrls,
                        updateImageIndex: _updateImageIndex,
                      )
                    : Hero(
                        tag: postInfo.postUrl,
                        child: NetworkImageDisplay(
                          blurHash: postInfo.blurHash,
                          aspectRatio: postInfo.aspectRatio,
                          bodyHeight: widget.bodyHeight,
                          imageUrl: postInfo.postUrl,
                        ),
                      ))
                : PlayThisVideo(
                    videoUrl: postInfo.postUrl, play: widget.playTheVideo),
          ),
        ),
        Opacity(
          opacity: isHeartAnimation ? 1 : 0,
          child: LikePopupAnimation(
              isAnimating: isHeartAnimation,
              duration: const Duration(milliseconds: 700),
              child: const Icon(Icons.favorite,
                  color: ColorManager.white, size: 100),
              onEnd: () => setState(() => isHeartAnimation = false)),
        ),
      ],
    );
  }

  void _updateImageIndex(int index, _) {
    initPosition.value = index;
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
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          headIcon: shareThisPost(),
          bodyText: widget.postInfo.value.publisherId == myPersonalId
              ? ordersOfMyPost()
              : ordersOfOtherUser(),
        );
      },
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
    );
  }

  Widget ordersOfMyPost() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(child: textOfOrders(StringsManager.archive.tr())),
            deletePost(postInfoValue),
            editPost(postInfoValue),
            GestureDetector(
                child: textOfOrders(StringsManager.hideLikeCount.tr())),
            GestureDetector(
                child: textOfOrders(StringsManager.turnOffCommenting.tr())),
            Container(height: 10)
          ],
        ),
      ),
    );
  }

  BlocBuilder<PostCubit, PostState> deletePost(Post postInfoValue) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return GestureDetector(
          onTap: () async {
            Navigator.maybePop(context);
            await PostCubit.get(context)
                .deletePostInfo(postInfo: postInfoValue);
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              setState(() {
                widget.postsInfo.value.removeAt(widget.indexOfPost);
              });
            });
          },
          child: textOfOrders(StringsManager.delete.tr()));
    });
  }

  BlocBuilder<PostCubit, PostState> editPost(Post postInfoValue) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return GestureDetector(
          onTap: () async {
            Navigator.maybePop(context);
            await Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(
              maintainState: false,
              builder: (context) => UpdatePostInfo(oldPostInfo: postInfoValue),
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
          GestureDetector(child: textOfOrders(StringsManager.hide.tr())),
          Builder(builder: (context) {
            FollowCubit followCubit = BlocProvider.of<FollowCubit>(context);
            return ValueListenableBuilder(
              valueListenable: widget.postInfo,
              builder: (context, Post postInfoValue, child) => GestureDetector(
                  onTap: () async {
                    await followCubit.removeThisFollower(
                        followingUserId: widget.postInfo.value.publisherId,
                        myPersonalId: myPersonalId);
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      setState(() {
                        widget.reLoadData();
                        widget.postsInfo.value.remove(postInfoValue);
                      });
                    });
                  },
                  child: textOfOrders(StringsManager.unfollow.tr())),
            );
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

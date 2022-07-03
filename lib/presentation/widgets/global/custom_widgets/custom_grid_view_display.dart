import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instagram/presentation/pages/video/play_this_video.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/animated_dialog.dart';
import 'package:instagram/presentation/widgets/global/aimation/like_popup_animation.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_posts_display.dart';

class _PositionDimension {
  final double positionTop;
  final double positionBottom;
  final double positionLeft;
  final double positionRight;
  _PositionDimension(
      {required this.positionTop,
      required this.positionBottom,
      required this.positionLeft,
      required this.positionRight});
}

// ignore: must_be_immutable
class CustomGridViewDisplay extends StatefulWidget {
  Post postClickedInfo;
  final List<Post> postsInfo;
  final bool isThatProfile;
  final int index;
  final bool playThisVideo;

  CustomGridViewDisplay(
      {required this.index,
      required this.postsInfo,
      this.isThatProfile = true,
      this.playThisVideo = false,
      required this.postClickedInfo,
      Key? key})
      : super(key: key);

  @override
  State<CustomGridViewDisplay> createState() => _CustomGridViewDisplayState();
}

class _CustomGridViewDisplayState extends State<CustomGridViewDisplay> {
  OverlayEntry? _popupDialog;
  OverlayEntry? _popupTextDialog;

  GlobalKey loveKey = GlobalKey();
  GlobalKey viewProfileKey = GlobalKey();
  GlobalKey shareKey = GlobalKey();
  GlobalKey menuKey = GlobalKey();

  ValueNotifier<bool> loveVisibility = ValueNotifier(false);
  ValueNotifier<bool> viewProfileVisibility = ValueNotifier(false);
  ValueNotifier<bool> shareVisibility = ValueNotifier(false);
  ValueNotifier<bool> menuVisibility = ValueNotifier(false);
  bool isLiked = false;
  bool isHeartAnimation = false;

  @override
  void initState() {
    isLiked = widget.postClickedInfo.likes.contains(myPersonalId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return createGridTileWidget();
  }

  _PositionDimension _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset position = box?.localToGlobal(Offset.zero) ?? const Offset(0, 0);

    _PositionDimension positionDimension = _PositionDimension(
        positionTop: position.dy,
        positionBottom: position.dy + 50,
        positionLeft: position.dx,
        positionRight: position.dx + 50);

    return positionDimension;
  }

  Widget createGridTileWidget() => Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            List<Post> customPostsInfo = widget.postsInfo;
            customPostsInfo.removeWhere(
                (value) => value.postUid == widget.postClickedInfo.postUid);
            customPostsInfo.insert(0, widget.postClickedInfo);
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => CustomPostsDisplay(
                postsInfo: widget.postsInfo,
                isThatProfile: widget.isThatProfile,
              ),
            ));
          },
          onLongPressMoveUpdate: (details) {
            _PositionDimension lovePosition = _getOffset(loveKey);
            _PositionDimension commentPosition = _getOffset(viewProfileKey);
            _PositionDimension sharePosition = _getOffset(shareKey);
            _PositionDimension menuPosition = _getOffset(menuKey);
            if (details.globalPosition.dy > lovePosition.positionTop &&
                details.globalPosition.dy < lovePosition.positionBottom &&
                details.globalPosition.dx > lovePosition.positionLeft &&
                details.globalPosition.dx < lovePosition.positionRight) {
              loveVisibility.value = true;
            } else if (details.globalPosition.dy >
                    commentPosition.positionTop &&
                details.globalPosition.dy < commentPosition.positionBottom &&
                details.globalPosition.dx > commentPosition.positionLeft &&
                details.globalPosition.dx < commentPosition.positionRight) {
              viewProfileVisibility.value = true;
            } else if (details.globalPosition.dy > sharePosition.positionTop &&
                details.globalPosition.dy < sharePosition.positionBottom &&
                details.globalPosition.dx > sharePosition.positionLeft &&
                details.globalPosition.dx < sharePosition.positionRight) {
              shareVisibility.value = true;
            } else if (details.globalPosition.dy > menuPosition.positionTop &&
                details.globalPosition.dy < menuPosition.positionBottom &&
                details.globalPosition.dx > menuPosition.positionLeft &&
                details.globalPosition.dx < menuPosition.positionRight) {
              menuVisibility.value = true;
            } else {
              viewProfileVisibility.value = false;
              shareVisibility.value = false;
              menuVisibility.value = false;
              loveVisibility.value = false;
            }

            _popupTextDialog = _createPopupTextDialog();
            Overlay.of(context)!.insert(_popupTextDialog!);
          },
          onLongPress: () {
            _popupDialog = _createPopupDialog(widget.postClickedInfo);
            Overlay.of(context)!.insert(_popupDialog!);
            _popupTextDialog = _createPopupTextDialog();
            Overlay.of(context)!.insert(_popupTextDialog!);
          },
          onLongPressEnd: (details) async {
            if (loveVisibility.value) {
              if (isLiked) {
                setState(() {
                  BlocProvider.of<PostLikesCubit>(context)
                      .removeTheLikeOnThisPost(
                          postId: widget.postClickedInfo.postUid,
                          userId: myPersonalId);
                  widget.postClickedInfo.likes.remove(myPersonalId);
                  isLiked = false;
                });
              } else {
                setState(() {
                  BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                      postId: widget.postClickedInfo.postUid,
                      userId: myPersonalId);
                  widget.postClickedInfo.likes.add(myPersonalId);
                  isLiked = true;
                  isHeartAnimation = true;
                });
              }
              await Future.delayed(const Duration(seconds: 1));
            }
            if (viewProfileVisibility.value) {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) {
                    return WhichProfilePage(
                      userId: widget.postClickedInfo.publisherId,
                    );
                  },
                ),
              );
            }
            _popupDialog?.remove();
            _popupTextDialog?.remove();
          },
          child: widget.postClickedInfo.isThatImage
              ? NetworkImageDisplay(
                  blurHash: widget.postClickedInfo.blurHash,
                  imageUrl: widget.postClickedInfo.postUrl.isNotEmpty
                      ? widget.postClickedInfo.postUrl
                      : widget.postClickedInfo.imagesUrls[0],
                  boxFit: BoxFit.cover)
              : PlayThisVideo(
                  videoUrl: widget.postClickedInfo.postUrl,
                  play: widget.playThisVideo,
                  withoutSound: true,
                ),
        ),
      );

  Widget lovePopAnimation() {
    return Icon(
      Icons.favorite,
      size: 150,
      color: Theme.of(context).primaryColor,
    );
  }

  OverlayEntry _createPopupDialog(Post postInfo) {
    return OverlayEntry(
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 20),
        child: AnimatedDialog(
          child: _createPopupContent(postInfo),
        ),
      ),
    );
  }

  OverlayEntry _createPopupTextDialog() {
    return OverlayEntry(
      builder: (context) => const SizedBox(),
    );
  }

  Widget _createPopupContent(Post postInfo) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _createPhotoTitle(postInfo),
            Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    postInfo.isThatImage
                        ? Container(
                            color: Theme.of(context).primaryColor,
                            width: double.infinity,
                            child: NetworkImageDisplay(
                                blurHash: postInfo.blurHash,
                                imageUrl: postInfo.postUrl.isNotEmpty
                                    ? postInfo.postUrl
                                    : postInfo.imagesUrls[0],
                                boxFit: BoxFit.fitWidth),
                          )
                        : Container(
                            color: Theme.of(context).primaryColor,
                            width: double.infinity,
                            height: screenSize.height - 200,
                            child: PlayThisVideo(
                                videoUrl: postInfo.postUrl, play: true),
                          ),
                    popupMessage(),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: isHeartAnimation ? 1 : 0,
                    child: LikePopupAnimation(
                        isAnimating: isHeartAnimation,
                        duration: const Duration(milliseconds: 700),
                        child: const Icon(Icons.favorite,
                            color: ColorManager.white, size: 100),
                        onEnd: () => setState(() => isHeartAnimation = false)),
                  ),
                ),
              ],
            ),
            _createActionBar(),
          ],
        ),
      ),
    );
  }

  Padding popupMessage() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: isLiked ? 5 : 17, end: 0),
      child: Row(
        children: [
          ValueListenableBuilder(
            valueListenable: loveVisibility,
            builder: (context, bool loveVisibilityValue, child) =>
                _PopupMessageDialog(
              message: isLiked
                  ? StringsManager.unLike.tr()
                  : StringsManager.like.tr(),
              paddingCornerStart: 20,
              visible: loveVisibilityValue,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: viewProfileVisibility,
            builder: (context, bool profileVisibilityValue, child) =>
                _PopupMessageDialog(
              message: StringsManager.viewProfile.tr(),
              visible: profileVisibilityValue,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: shareVisibility,
            builder: (context, bool shareVisibilityValue, child) =>
                _PopupMessageDialog(
              message: StringsManager.share.tr(),
              visible: shareVisibilityValue,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: menuVisibility,
            builder: (context, bool menuVisibilityValue, child) =>
                _PopupMessageDialog(
              message: StringsManager.menu.tr(),
              paddingCornerEnd: 20,
              paddingCornerStart: 8,
              visible: menuVisibilityValue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPhotoTitle(Post postInfo) => Container(
        padding: const EdgeInsetsDirectional.only(
            bottom: 5, top: 5, end: 10, start: 10),
        height: 55,
        width: double.infinity,
        color: Theme.of(context).splashColor,
        child: Row(
          children: [
            CircleAvatarOfProfileImage(
              userInfo: postInfo.publisherInfo!,
              bodyHeight: 370,
            ),
            const SizedBox(width: 7),
            Text(postInfo.publisherInfo!.name,
                style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      );

  Widget _createActionBar() {
    isLiked = widget.postClickedInfo.likes.contains(myPersonalId);

    return Container(
      height: 50,
      padding: const EdgeInsetsDirectional.only(bottom: 5, top: 5),
      color: Theme.of(context).splashColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            key: loveKey,
            child: isLiked
                ? const Icon(
                    Icons.favorite,
                    size: 28,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.favorite_border,
                    size: 28,
                    color: Theme.of(context).focusColor,
                  ),
          ),
          SizedBox(
            key: viewProfileKey,
            child: SvgPicture.asset(
              IconsAssets.profileIcon,
              height: 28,
              color: Theme.of(context).focusColor,
            ),
          ),
          SizedBox(
            key: shareKey,
            child: SvgPicture.asset(
              IconsAssets.send1Icon,
              height: 23,
              color: Theme.of(context).focusColor,
            ),
          ),
          SizedBox(
            key: menuKey,
            child: SvgPicture.asset(
              IconsAssets.menuHorizontalIcon,
              color: Theme.of(context).focusColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupMessageDialog extends StatelessWidget {
  final bool visible;
  final String message;
  final double paddingCornerStart;
  final double paddingCornerEnd;
  const _PopupMessageDialog({
    Key? key,
    required this.visible,
    required this.message,
    this.paddingCornerStart = 0,
    this.paddingCornerEnd = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: paddingCornerStart,
          end: paddingCornerEnd,
          top: 20,
          bottom: 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.black87,
            borderRadius: BorderRadius.circular(2),
          ),
          padding: const EdgeInsetsDirectional.only(
              end: 10, start: 10, top: 5, bottom: 5),
          child: Text(
            message,
            style: const TextStyle(
              color: ColorManager.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

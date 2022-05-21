import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/pages/video/play_this_video.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/animated_dialog.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_posts_display.dart';

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

  @override
  Widget build(BuildContext context) {
    return createGridTileWidget();
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
          onLongPress: () {
            _popupDialog = _createPopupDialog(widget.postClickedInfo);
            Overlay.of(context)!.insert(_popupDialog!);
          },
          onLongPressEnd: (details) => _popupDialog?.remove(),
          child: widget.postClickedInfo.isThatImage
              ? ImageDisplay(
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

  Widget _createPopupContent(Post postInfo) {
    double bodyHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _createPhotoTitle(postInfo),
            postInfo.isThatImage
                ? Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    child: ImageDisplay(
                        imageUrl: postInfo.postUrl.isNotEmpty
                            ? postInfo.postUrl
                            : postInfo.imagesUrls[0],
                        boxFit: BoxFit.fitWidth))
                : Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    height: bodyHeight - 200,
                    child:
                        PlayThisVideo(videoUrl: postInfo.postUrl, play: true)),
            _createActionBar(),
          ],
        ),
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

  Widget _createActionBar() => Container(
        height: 50,
        padding: const EdgeInsetsDirectional.only(bottom: 5, top: 5),
        color: Theme.of(context).splashColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onPanStart: (d) {},
              onForcePressStart: (e) {
                e.pressure;
              },
              onLongPressUp: () {},
              child: Icon(
                Icons.favorite_border,
                color: Theme.of(context).focusColor,
              ),
            ),
            GestureDetector(
              onVerticalDragStart: (d) {},
              child: Icon(
                Icons.chat_bubble_outline,
                color: Theme.of(context).focusColor,
              ),
            ),
            GestureDetector(
              onTertiaryLongPress: () {},
              child: Icon(
                Icons.send,
                color: Theme.of(context).focusColor,
              ),
            ),
          ],
        ),
      );
}

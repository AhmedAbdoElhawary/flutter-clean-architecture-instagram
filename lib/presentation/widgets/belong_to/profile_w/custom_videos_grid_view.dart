import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/pages/play_this_video.dart';
import 'package:instagram/presentation/widgets/animated_dialog.dart';
import 'package:instagram/presentation/widgets/circle_avatar_of_profile_image.dart';

// ignore: must_be_immutable
class CustomVideosGridView extends StatefulWidget {
  List<Post> postsInfo;
  final String userId;

  CustomVideosGridView(
      {required this.userId, required this.postsInfo, Key? key})
      : super(key: key);

  @override
  State<CustomVideosGridView> createState() => _CustomVideosGridViewState();
}

class _CustomVideosGridViewState extends State<CustomVideosGridView> {
  @override
  Widget build(BuildContext context) {
    return widget.postsInfo.isNotEmpty
        ? GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              mainAxisExtent: 215,
              crossAxisSpacing: 1.5,
              mainAxisSpacing: 1.5,
              childAspectRatio: 1.0,
            ),
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsetsDirectional.only(bottom: 1.5, top: 1.5),
            children: widget.postsInfo.map((postInfo) {
              return createGridTileWidget(postInfo);
            }).toList())
        : Center(
            child: Text(
            StringsManager.noPosts.tr(),
            style: Theme.of(context).textTheme.bodyText1,
          ));
  }

  OverlayEntry? _popupDialog;

  Widget createGridTileWidget(Post postInfo) => Builder(
        builder: (context) => GestureDetector(
          onTap: () {},
          onLongPress: () {
            _popupDialog = _createPopupDialog(postInfo);
            Overlay.of(context)!.insert(_popupDialog!);
          },
          onLongPressEnd: (details) => _popupDialog?.remove(),
          child: PlayThisVideo(videoUrl: postInfo.postUrl, play: false),
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
            Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              height: bodyHeight - 200,
              child: PlayThisVideo(videoUrl: postInfo.postUrl, play: true),
            ),
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
        color: Theme.of(context).primaryColor,
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
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onPanStart: (d) {},
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

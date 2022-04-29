import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/pages/play_this_video.dart';
import 'package:instegram/presentation/widgets/animated_dialog.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:instegram/presentation/widgets/custom_posts_display.dart';

// ignore: must_be_immutable
class CustomVideosGridView extends StatefulWidget {
  List<Post> postsInfo;
  final String userId;

  CustomVideosGridView(
      {
      required this.userId,
      required this.postsInfo,
      Key? key})
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
        padding: const EdgeInsets.symmetric(vertical: 1.5),
            children: widget.postsInfo.map((postInfo) {
              return createGridTileWidget(postInfo);
            }).toList())
        : const Center(child: Text(StringsManager.noPosts));
  }

  OverlayEntry? _popupDialog;

  Widget createGridTileWidget(Post postInfo) => Builder(
        builder: (context) => GestureDetector(
          onTap: () {
          },
          onLongPress: () {
            _popupDialog = _createPopupDialog(postInfo);
            Overlay.of(context)!.insert(_popupDialog!);
          },
          onLongPressEnd: (details) => _popupDialog?.remove(),
          child: PlayThisVideo(videoUrl:postInfo.postUrl,
              // isVideoInView: (){return false;}
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(postInfo),
              Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: bodyHeight-200,
                  child: PlayThisVideo(videoUrl:postInfo.postUrl,
                      // isVideoInView: (){return true;}
                  ),),
              _createActionBar(),
            ],
          ),
        ),
      );}

  Widget _createPhotoTitle(Post postInfo) => Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        height: 55,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatarOfProfileImage(
              imageUrl: postInfo.publisherInfo!.profileImageUrl,
              bodyHeight: 370,
            ),
            const SizedBox(width: 7),
            Text(postInfo.publisherInfo!.name,
                style: const TextStyle(
                  color: Colors.black,
                )),
          ],
        ),
      );

  Widget _createActionBar() => Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onPanStart: (d) {},
              child: const Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onVerticalDragStart: (d) {},
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTertiaryLongPress: () {},
              child: const Icon(
                Icons.send,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
}

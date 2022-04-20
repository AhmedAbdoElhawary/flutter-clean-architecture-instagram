import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/pages/play_this_video.dart';
import 'package:instegram/presentation/widgets/animated_dialog.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:instegram/presentation/widgets/custom_posts_display.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';

// ignore: must_be_immutable
class CustomGridView extends StatefulWidget {
  List<Post> postsInfo;
  final String userId;

  CustomGridView({required this.userId, required this.postsInfo, Key? key})
      : super(key: key);

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  OverlayEntry? _popupDialog;

  @override
  Widget build(BuildContext context) {
    return widget.postsInfo.isNotEmpty
        ? StaggeredGridView.countBuilder(
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            crossAxisSpacing: 1.5,
            mainAxisSpacing: 1.5,
            crossAxisCount: 3,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.postsInfo.length,
            itemBuilder: (context, index) {
              return createGridTileWidget(widget.postsInfo[index]);
            },
            staggeredTileBuilder: (index) {
              double num = widget.postsInfo[index].isThatImage ? 1 : 2;
              return StaggeredTile.count(1, num);
            },
          )
        : const Center(child: Text(StringsManager.noPosts));
  }

  Widget createGridTileWidget(Post postInfo) => Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CustomPostsDisplay(postInfo),
            ));
          },
          onLongPress: () {
            _popupDialog = _createPopupDialog(postInfo);
            Overlay.of(context)!.insert(_popupDialog!);
          },
          onLongPressEnd: (details) => _popupDialog?.remove(),
          child: postInfo.isThatImage
              ? CustomFadeInImage(
                  imageUrl: postInfo.postUrl, boxFit: BoxFit.cover)
              : PlayThisVideo(videoUrl: postInfo.postUrl,isVideoInView: (){return false;}),
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
            postInfo.isThatImage
                ? Container(
                    color: ColorManager.white,
                    width: double.infinity,
                    child: CustomFadeInImage(
                        imageUrl: postInfo.postUrl, boxFit: BoxFit.fitWidth))
                : Container(
                    color: ColorManager.white,
                    width: double.infinity,
                    height: bodyHeight - 200,
                    child: PlayThisVideo(
                      videoUrl: postInfo.postUrl,
                      isVideoInView: (){return true;},
                    )),
            _createActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _createPhotoTitle(Post postInfo) => Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        height: 55,
        width: double.infinity,
        color: ColorManager.white,
        child: Row(
          children: [
            CircleAvatarOfProfileImage(
              imageUrl: postInfo.publisherInfo!.profileImageUrl,
              thisForStoriesLine: false,
              bodyHeight: 370,
              circleAvatarName: '',
            ),
            const SizedBox(width: 7),
            Text(postInfo.publisherInfo!.name, style: getNormalStyle()),
          ],
        ),
      );

  Widget _createActionBar() => Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        color: ColorManager.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onPanStart: (d) {},
              child: const Icon(
                Icons.favorite_border,
                color: ColorManager.black,
              ),
            ),
            GestureDetector(
              onVerticalDragStart: (d) {},
              child: const Icon(
                Icons.chat_bubble_outline,
                color: ColorManager.black,
              ),
            ),
            GestureDetector(
              onTertiaryLongPress: () {},
              child: const Icon(
                Icons.send,
                color: ColorManager.black,
              ),
            ),
          ],
        ),
      );
}

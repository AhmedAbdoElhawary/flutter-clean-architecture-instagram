import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/pages/video/play_this_video.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/animated_dialog.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_posts_display.dart';

// ignore: must_be_immutable
class CustomGridView extends StatefulWidget {
  List<Post> postsInfo;
  final String userId;
  final bool isThatProfile;

  CustomGridView(
      {required this.userId,
      required this.postsInfo,
      this.isThatProfile = true,
      Key? key})
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
            padding: const EdgeInsetsDirectional.only(bottom: 1.5, top: 1.5),
            crossAxisSpacing: 1.5,
            mainAxisSpacing: 1.5,
            crossAxisCount: 3,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.postsInfo.length,
            itemBuilder: (context, index) {
              return createGridTileWidget(
                  widget.postsInfo[index], widget.postsInfo, index);
            },
            staggeredTileBuilder: (index) {
              double num = widget.postsInfo[index].isThatImage ? 1 : 2;
              return StaggeredTile.count(1, num);
            },
          )
        : Center(
            child: Text(
            StringsManager.noPosts.tr(),
            style: Theme.of(context).textTheme.bodyText1,
          ));
  }

  Widget createGridTileWidget(
          Post postClickedInfo, List<Post> postsInfo, int index) =>
      Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            List<Post> customPostsInfo = postsInfo;
            customPostsInfo.removeWhere(
                (value) => value.postUid == postClickedInfo.postUid);
            customPostsInfo.insert(0, postClickedInfo);
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => CustomPostsDisplay(
                postsInfo: postsInfo,
                isThatProfile: widget.isThatProfile,
              ),
            ));
          },
          onLongPress: () {
            _popupDialog = _createPopupDialog(postClickedInfo);
            Overlay.of(context)!.insert(_popupDialog!);
          },
          onLongPressEnd: (details) => _popupDialog?.remove(),
          child: postClickedInfo.isThatImage
              ? ImageDisplay(
                  imageUrl: postClickedInfo.postUrl, boxFit: BoxFit.cover)
              : PlayThisVideo(videoUrl: postClickedInfo.postUrl, play: false),
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
                        imageUrl: postInfo.postUrl, boxFit: BoxFit.fitWidth))
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
              onForcePressStart: (e){
                e.pressure;
              },
              onLongPressUp: (){
              },

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

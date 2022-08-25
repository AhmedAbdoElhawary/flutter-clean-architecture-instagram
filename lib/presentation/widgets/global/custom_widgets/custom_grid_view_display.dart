import 'package:flutter/material.dart';
import 'package:instagram/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/presentation/pages/video/play_this_video.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/global/others/image_of_post.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/mobile/popup_post.dart';

// ignore: must_be_immutable
class CustomGridViewDisplay extends StatefulWidget {
  Post postClickedInfo;
  final List<Post> postsInfo;
  final bool isThatProfile;
  final int index;
  final bool playThisVideo;
  final ValueChanged<int>? removeThisPost;
  CustomGridViewDisplay(
      {required this.index,
      required this.postsInfo,
      this.isThatProfile = true,
      this.playThisVideo = false,
      required this.postClickedInfo,
      this.removeThisPost,
      Key? key})
      : super(key: key);

  @override
  State<CustomGridViewDisplay> createState() => _CustomGridViewDisplayState();
}

class _CustomGridViewDisplayState extends State<CustomGridViewDisplay> {
  @override
  Widget build(BuildContext context) {
    return createGridTileWidget();
  }

  Widget createGridTileWidget() {
    return SafeArea(
      child: Builder(
        builder: (context) {
          if (isThatMobile) {
            return PopupPostCard(
              postClickedInfo: widget.postClickedInfo,
              postsInfo: widget.postsInfo,
              isThatProfile: widget.isThatProfile,
              postClickedWidget: widget.postClickedInfo.isThatImage
                  ? buildCardImage()
                  : buildCardVideo(),
            );
          } else {
            return GestureDetector(
              onTap: onTapPostForWeb,
              onLongPressEnd: (_) => onTapPostForWeb,
              child: widget.postClickedInfo.isThatImage
                  ? buildCardImage()
                  : buildCardVideo(playVideo: false),
            );
          }
        },
      ),
    );
  }

  onTapPostForWeb() => Navigator.of(context).push(
        HeroDialogRoute(
          builder: (context) => ImageOfPost(
            postInfo: ValueNotifier(widget.postClickedInfo),
            playTheVideo: widget.playThisVideo,
            indexOfPost: widget.index,
            removeThisPost: widget.removeThisPost,
            postsInfo: ValueNotifier(widget.postsInfo),
            popupWebContainer: true,
            showSliderArrow: true,
            selectedCommentInfo: ValueNotifier(null),
            textController: ValueNotifier(TextEditingController()),
          ),
        ),
      );

  Widget buildCardVideo({bool? playVideo}) {
    return PlayThisVideo(
      videoInfo: widget.postClickedInfo,
      play: playVideo ?? widget.playThisVideo,
      withoutSound: true,
    );
  }

  Stack buildCardImage() {
    bool isThatMultiImages = widget.postClickedInfo.imagesUrls.length > 1;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        NetworkImageDisplay(
          cachingHeight: 238,
          cachingWidth: 238,
          blurHash: widget.postClickedInfo.blurHash,
          imageUrl: isThatMultiImages
              ? widget.postClickedInfo.imagesUrls[0]
              : widget.postClickedInfo.postUrl,
        ),
        if (isThatMultiImages)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.collections_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

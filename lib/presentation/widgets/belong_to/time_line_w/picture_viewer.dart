import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/pages/video/play_this_video.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';

class PictureViewer extends StatelessWidget {
  final String imageUrl;
  final String blurHash;
  final bool isThatImage;
  final double aspectRatio;

  const PictureViewer({
    Key? key,
    required this.imageUrl,
    required this.blurHash,
    this.isThatImage = true,
    this.aspectRatio = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar:isThatMobile? buildAppBar(context):null,
      extendBodyBehindAppBar: true,
      body: InteractiveViewer(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: isThatImage
                ? Hero(
                    tag: imageUrl,
                    child: NetworkImageDisplay(
                      blurHash: blurHash,
                      aspectRatio: aspectRatio,
                      imageUrl: imageUrl,
                    ),
                  )
                : PlayThisVideo(videoUrl: imageUrl, play: true, dispose: false),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close_outlined,
                size: 30, color: Theme.of(context).focusColor),
          ),
        )
      ],
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: ColorManager.transparent,
      foregroundColor: Theme.of(context).primaryColor,
    );
  }
}

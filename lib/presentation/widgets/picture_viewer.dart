import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/pages/play_this_video.dart';
import 'package:instagram/presentation/widgets/fade_in_image.dart';

class PictureViewer extends StatelessWidget {
  final Post postInfo;
  final String imageUrl;

  const PictureViewer(
      {Key? key, required this.postInfo, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        backgroundColor: ColorManager.transparent,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      extendBodyBehindAppBar: true,
      body: InteractiveViewer(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: postInfo.isThatImage
                ? Hero(
                    tag: postInfo.postUrl,
                    child: CustomFadeInImage(
                      aspectRatio: postInfo.aspectRatio,
                      imageUrl: postInfo.postUrl,
                    ),
                  )
                : PlayThisVideo(
                    videoUrl: postInfo.postUrl, play: true, dispose: false),
          ),
        ),
      ),
    );
  }
}

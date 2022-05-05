import 'package:flutter/material.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/pages/play_this_video.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';

class PictureViewer extends StatelessWidget {
  final Post postInfo;
  final String imageUrl;

  const PictureViewer(
      {Key? key, required this.postInfo, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
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
                : PlayThisVideo(videoUrl: postInfo.postUrl, play: true,dispose: false),
          ),
        ),
      ),
    );
  }
}

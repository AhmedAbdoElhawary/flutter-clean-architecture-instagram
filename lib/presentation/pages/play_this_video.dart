import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/resources/color_manager.dart';

class PlayThisVideo extends StatefulWidget {
  final String videoUrl;
  final ValueGetter<bool> isVideoInView;
  const PlayThisVideo({Key? key, required this.videoUrl,required this.isVideoInView})
      : super(key: key);

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<PlayThisVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize()
          .then((_) =>widget.isVideoInView() ? _controller.play() : _controller.pause());
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: 1.0,
              child: _controller.value.isInitialized
                  ? videoPlayer()
                  : Container(color: ColorManager.grey),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  Widget videoPlayer() => Stack(
        children: <Widget>[
          video(),
        ],
      );

  Widget video() => GestureDetector(
        child: VideoPlayer(_controller),
      );
}

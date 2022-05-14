import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:video_player/video_player.dart';

class PlayThisVideo extends StatefulWidget {
  final String videoUrl;
  final bool play;
  final bool dispose;

  const PlayThisVideo(
      {Key? key,
      required this.videoUrl,
      required this.play,
      this.dispose = true})
      : super(key: key);
  @override
  _PlayThisVideoState createState() => _PlayThisVideoState();
}

class _PlayThisVideoState extends State<PlayThisVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });

    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);
    }
    super.initState();

  }

  @override
  void didUpdateWidget(PlayThisVideo oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
        _controller.setLooping(true);
      } else {
        _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // if (widget.dispose) {
      _controller.dispose();
      super.dispose();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
              aspectRatio: 0.65, child: VideoPlayer(_controller));
        } else {
          return AspectRatio(
              aspectRatio: 0.65,
              child: Container(color: ColorManager.lowOpacityGrey));
        }
      },
    );
  }
}

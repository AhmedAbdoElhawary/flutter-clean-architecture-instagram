import 'package:flutter/material.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:video_player/video_player.dart';

class PlayThisVideo extends StatefulWidget {
  final String videoUrl;
  final String blurHash;
  final double aspectRatio;
  final bool isThatFromMemory;
  final bool play;
  final bool withoutSound;
  const PlayThisVideo({
    Key? key,
    required this.videoUrl,
    this.blurHash = "",
    this.withoutSound = false,
    this.isThatFromMemory = false,
    this.aspectRatio = 0.65,
    required this.play,
  }) : super(key: key);
  @override
  PlayThisVideoState createState() => PlayThisVideoState();
}

class PlayThisVideoState extends State<PlayThisVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late double aspectRatio;
  @override
  void initState() {
    super.initState();
    aspectRatio = widget.aspectRatio;
    if (!isThatMobile && aspectRatio == 0.65) aspectRatio = 0.56;

    _controller = widget.isThatFromMemory
        ? VideoPlayerController.asset(widget.videoUrl)
        : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });

    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);

      if (widget.withoutSound) {
        _controller.setVolume(0);
      } else {
        _controller.setVolume(1);
      }
    }
  }

  @override
  void didUpdateWidget(PlayThisVideo oldWidget) {
    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);
      if (widget.withoutSound) _controller.setVolume(0);
    } else {
      _controller.pause();
    }
    if (widget.withoutSound) {
      _controller.setVolume(0);
    } else {
      _controller.setVolume(1);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          return AspectRatio(aspectRatio: aspectRatio, child: buildSizedBox());
        }
      },
    );
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).textTheme.bodyMedium!.color,
      child: Center(
          child: CircleAvatar(
        radius: 40,
        backgroundColor: Theme.of(context).textTheme.bodySmall!.color,
        child: Center(
            child: CircleAvatar(
          radius: 39,
          backgroundColor: Theme.of(context).textTheme.bodyMedium!.color,
        )),
      )),
    );
  }
}

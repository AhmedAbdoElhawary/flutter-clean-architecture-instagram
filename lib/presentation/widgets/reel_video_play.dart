import 'package:flutter/material.dart';
import 'package:instegram/presentation/widgets/fade_animation.dart';
import 'package:video_player/video_player.dart';

class ReelVideoPlay extends StatefulWidget {
  final String videoUrl;

  ReelVideoPlay({required this.videoUrl, Key? key});

  @override
  State<ReelVideoPlay> createState() => _ReelVideoPlayState();
}

class _ReelVideoPlayState extends State<ReelVideoPlay> {
  late Widget videoStatusAnimation;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;


  @override
  void initState() {
    super.initState();
    videoStatusAnimation = Container();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller.play());
    _initializeVideoPlayerFuture = _controller.initialize();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        video(),
        Center(child: videoStatusAnimation),
      ],
    );
  }

  Widget video() => GestureDetector(
      child:FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {

            return VideoPlayer(_controller);
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
        },
      ),
      onTap: () {
        if (!_controller.value.isInitialized) {
          return;
        }
        if (_controller.value.volume == 0) {
          videoStatusAnimation =
              FadeAnimation(child: volumeContainer(Icons.volume_up));
          _controller.setVolume(1);
        } else {
          videoStatusAnimation =
              FadeAnimation(child: volumeContainer(Icons.volume_off));
          _controller.setVolume(0);
        }
      },
      onDoubleTap: () {},
      onLongPressStart: (LongPressStartDetails event) {
        if (!_controller.value.isInitialized) {
          return;
        }
        _controller.pause();
      },
      onLongPressEnd: (LongPressEndDetails event) {
        if (!_controller.value.isInitialized) {
          return;
        }
        _controller.play();
      });

  Container volumeContainer(IconData icon) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40), color: Colors.black45),
        padding: const EdgeInsetsDirectional.all(25),
        child: Icon(
          icon,
          size: 23.0,
          color: Colors.white,
        ));
  }
}

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:instagram/presentation/widgets/global/others/play_this_video.dart';
import 'story_controller.dart';

/// Widget to display animated gifs or still images. Shows a loader while image
/// is being loaded. Listens to playback states from [controller] to pause and
/// forward animated media.
class StoryImageForWeb extends StatefulWidget {
  final String imageUrl;
  final BoxFit? fit;
  final StoryController? controller;
  final bool isThatImage;
  StoryImageForWeb(
    this.imageUrl, {
    Key? key,
    this.controller,
    required this.isThatImage,
    this.fit,
  }) : super(key: key ?? UniqueKey());

  /// Use this shorthand to fetch images/gifs from the provided [url]
  factory StoryImageForWeb.url(
    String url, {
    StoryController? controller,
    required bool isThatImage,
    Map<String, dynamic>? requestHeaders,
    BoxFit fit = BoxFit.fitWidth,
    Key? key,
  }) {
    return StoryImageForWeb(url,
        isThatImage: isThatImage, controller: controller, fit: fit, key: key);
  }

  @override
  State<StatefulWidget> createState() => StoryImageForWebState();
}

class StoryImageForWebState extends State<StoryImageForWeb> {
  ui.Image? currentFrame;

  Timer? _timer;

  StreamSubscription<PlaybackState>? _streamSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _streamSubscription =
          widget.controller!.playbackNotifier.listen((playbackState) {
        if (playbackState == PlaybackState.pause) {
          _timer?.cancel();
        } else {
          _timer?.cancel();
          if (widget.controller != null) return;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget getContentView() {
    if (!widget.isThatImage) {
      return PlayThisVideo(
        play: true,
        videoUrl: widget.imageUrl,
      );
    } else {
      return Image.network(
        widget.imageUrl,
        fit: widget.fit,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: getContentView(),
    );
  }
}

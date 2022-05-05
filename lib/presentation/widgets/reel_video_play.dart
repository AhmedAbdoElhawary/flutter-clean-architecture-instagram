import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instegram/presentation/widgets/fade_animation.dart';
import 'package:video_player/video_player.dart';

class ReelVideoPlay extends StatefulWidget {
  final ValueNotifier<Post> videoInfo;
  final ValueNotifier<bool> stopVideo;

  const ReelVideoPlay(
      {Key? key, required this.videoInfo, required this.stopVideo})
      : super(key: key);

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
    _controller = VideoPlayerController.network(widget.videoInfo.value.postUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller.play());
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void didUpdateWidget(covariant ReelVideoPlay oldWidget) {
    if (!oldWidget.stopVideo.value) {
      _initializeVideoPlayerFuture = _controller.pause();
      _controller.pause();
      super.didUpdateWidget(oldWidget);
    }
    // super.dispose();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        video(),
        Center(child: videoStatusAnimation),
      ],
    );
  }

  Widget video() {
    bool isLiked = widget.videoInfo.value.likes.contains(myPersonalId);

    return Builder(
      builder: (context) {
        PostLikesCubit likeCubit=BlocProvider.of<PostLikesCubit>(context);

        return GestureDetector(
            child: FutureBuilder(
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
            onDoubleTap: () {
              // setState(() {
              //   videoStatusAnimation = FadeAnimation(
              //       child: popIcon(Icons.favorite, isThatLoveIcon: true));
              //   if (!isLiked) {
              //     likeCubit.putLikeOnThisPost(
              //         postId: widget.videoInfo.value.postUid, userId: myPersonalId);
              //     widget.videoInfo.value.likes.add(myPersonalId);
              //   }
              // });

            },
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
      }
    );
  }

  Container volumeContainer(IconData icon) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40), color: Colors.black45),
        padding: const EdgeInsetsDirectional.all(25),
        child: popIcon(icon));
  }

  Icon popIcon(IconData icon, {bool isThatLoveIcon = false}) {
    return Icon(
      icon,
      size: isThatLoveIcon ? 100 : 23.0,
      color: Colors.white,
    );
  }
}

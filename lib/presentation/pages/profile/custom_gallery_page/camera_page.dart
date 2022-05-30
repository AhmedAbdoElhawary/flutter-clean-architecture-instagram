import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/presentation/pages/profile/create_post_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/custom_gallery/record_count.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/custom_gallery/record_fade_animation.dart';

enum Flash { off, auto, on }

class CustomCameraDisplay extends StatefulWidget {
  final bool selectedVideo;
  late CameraController controller;
  final VoidCallback moveToVideoScreen;
  final List<CameraDescription> cameras;
  final ValueNotifier<bool> redDeleteText;
  final ValueChanged<bool> replacingTabBar;
  final ValueNotifier<bool> clearVideoRecord;
  late Future<void> initializeControllerFuture;

  CustomCameraDisplay({
    Key? key,
    required this.cameras,
    required this.controller,
    required this.redDeleteText,
    required this.selectedVideo,
    required this.replacingTabBar,
    required this.clearVideoRecord,
    required this.moveToVideoScreen,
    required this.initializeControllerFuture,
  }) : super(key: key);

  @override
  CustomCameraDisplayState createState() => CustomCameraDisplayState();
}

class CustomCameraDisplayState extends State<CustomCameraDisplay> {
  ValueNotifier<bool> startVideoCount = ValueNotifier(false);
  Flash currentFlashMode = Flash.off;
  late Widget videoStatusAnimation;
  File? videoRecordFile;
  int selectedCamera = 0;

  @override
  void initState() {
    videoStatusAnimation = Container();
    super.initState();
  }

  initializeCamera(int cameraIndex) async {
    widget.controller = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: true,
    );

    widget.initializeControllerFuture = widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.clear_rounded,
              color: Theme.of(context).focusColor, size: 30),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        actions: <Widget>[
          if (widget.selectedVideo)
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.blue, size: 30),
                onPressed: () async {
                  if (videoRecordFile != null) {
                    Navigator.of(context).maybePop(videoRecordFile!);
                  }
                },
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<void>(
          future: widget.initializeControllerFuture,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Container(
                      width: double.infinity,
                      color: Colors.blue,
                      child: CameraPreview(widget.controller)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        if (widget.cameras.length > 1) {
                          setState(() {
                            selectedCamera = selectedCamera == 0 ? 1 : 0;
                            initializeCamera(selectedCamera);
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('No secondary camera found'),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      icon: const Icon(Icons.switch_camera_rounded,
                          color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          currentFlashMode = currentFlashMode == Flash.off
                              ? Flash.auto
                              : (currentFlashMode == Flash.auto
                                  ? Flash.on
                                  : Flash.off);
                        });
                        currentFlashMode == Flash.on
                            ? widget.controller.setFlashMode(FlashMode.torch)
                            : (currentFlashMode == Flash.auto
                                ? widget.controller.setFlashMode(FlashMode.auto)
                                : widget.controller
                                    .setFlashMode(FlashMode.off));
                      },
                      icon: Icon(
                          currentFlashMode == Flash.on
                              ? Icons.flash_on_rounded
                              : (currentFlashMode == Flash.auto
                                  ? Icons.flash_auto_rounded
                                  : Icons.flash_off_rounded),
                          color: Colors.white),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 270,
                        color: Theme.of(context).primaryColor,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: RecordCount(
                                  startVideoCount: startVideoCount,
                                  makeProgressRed: widget.redDeleteText,
                                  clearVideoRecord: widget.clearVideoRecord,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(60),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!widget.selectedVideo) {
                                          try {
                                            await widget
                                                .initializeControllerFuture;
                                            final image = await widget
                                                .controller
                                                .takePicture();
                                            File selectedImage =
                                                File(image.path);
                                            var decodedImage =
                                                await decodeImageFromList(
                                                    selectedImage
                                                        .readAsBytesSync());
                                            await Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(CupertinoPageRoute(
                                                    builder: (context) =>
                                                        CreatePostPage(
                                                            selectedFile:
                                                                selectedImage,
                                                            isThatImage: widget
                                                                .selectedVideo,
                                                            aspectRatio:
                                                                decodedImage
                                                                        .width /
                                                                    decodedImage
                                                                        .height),
                                                    maintainState: false));
                                          } catch (e) {
                                            if (kDebugMode) {
                                              print(e);
                                            }
                                          }
                                        } else {
                                          setState(() {
                                            videoStatusAnimation =
                                                buildFadeAnimation();
                                          });
                                        }
                                      },
                                      onLongPress: () {
                                        widget.controller.startVideoRecording();
                                        widget.moveToVideoScreen();
                                        setState(() {
                                          startVideoCount.value = true;
                                        });
                                      },
                                      onLongPressUp: () async {
                                        setState(() {
                                          startVideoCount.value = false;
                                          widget.replacingTabBar(true);
                                        });
                                        XFile w = await widget.controller
                                            .stopVideoRecording();
                                        videoRecordFile = File(w.path);
                                      },
                                      child: CircleAvatar(
                                          backgroundColor: Colors.grey[300],
                                          radius: 40,
                                          child: CircleAvatar(
                                            radius: 24,
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                          )),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 120, child: videoStatusAnimation),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      )),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  RecordFadeAnimation buildFadeAnimation() {
    return RecordFadeAnimation(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 3, color: Colors.black, offset: Offset(1, 2))
              ],
              color: Color.fromARGB(255, 49, 49, 49),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Text(
                    "Press and hold to record",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Center(
              child: Icon(
                Icons.arrow_drop_down_rounded,
                color: Color.fromARGB(255, 49, 49, 49),
                size: 65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

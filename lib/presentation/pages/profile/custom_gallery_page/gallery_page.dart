import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/presentation/customPackages/crop_image/crop_image.dart';
import 'package:instagram/presentation/customPackages/crop_image/crop_options.dart';
import 'package:instagram/presentation/pages/profile/create_post_page.dart';
import 'package:instagram/presentation/pages/profile/custom_gallery_page/camera_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:image_cropper/image_cropper.dart';

enum SelectedPage { left, center, right }

class CustomGalleryDisplay extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CustomGalleryDisplay({Key? key, required this.cameras})
      : super(key: key);

  @override
  CustomGalleryDisplayState createState() => CustomGalleryDisplayState();
}

class CustomGalleryDisplayState extends State<CustomGalleryDisplay>
    with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);
  bool neverScrollPhysics = false;
  ValueNotifier<bool> clearVideoRecord = ValueNotifier(false);
  ValueNotifier<bool> redDeleteText = ValueNotifier(false);
  SelectedPage selectedPage = SelectedPage.left;
  late Future<void> initializeControllerFuture;
  final cropKey = GlobalKey<CropState>();
  final List<Widget> _mediaList = [];
  late CameraController controller;
  bool showDeleteText = false;
  bool selectedVideo = false;
  Uint8List? selectedImage;
  bool shrinkWrap = false;
  Uint8List? firstImage;
  int selectedPaged = 0;
  bool? primary;
  bool remove = false;
  bool? stopScrollTab;
  int currentPage = 0;
  bool initial = true;
  late int lastPage;
  File? _lastCropped;

  @override
  void didUpdateWidget(CustomGalleryDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
      enableAudio: true,
    );
    initializeControllerFuture = controller.initialize();
    _fetchNewMedia();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _lastCropped?.delete();
    super.dispose();
  }

  bool _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
        return true;
      }
    }
    return false;
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(page: currentPage, size: 60);
      List<Widget> temp = [];

      for (int i = 0; i < media.length; i++) {
        temp.add(lowQualityImage(media, i));
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  FutureBuilder<Uint8List?> lowQualityImage(List<AssetEntity> media, int i) {
    return FutureBuilder(
      future: media[i].thumbnailDataWithSize(const ThumbnailSize(1000, 1000)),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Uint8List? image = snapshot.data;
          if (image != null) {
            if (i == 0 && firstImage == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  firstImage = image;
                });
              });
            }
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedImage = image;
                });
              },
              child: Container(
                color: Colors.grey,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.memory(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (media[i].type == AssetType.video)
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        return _handleScrollEvent(scroll);
      },
      child: defaultTabController(),
    );
  }

  Widget deleteButton() {
    Color deleteColor = redDeleteText.value ? Colors.red : Colors.black;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (!redDeleteText.value) {
                redDeleteText.value = true;
              } else {
                clearVideoRecord.value = true;
                showDeleteText = false;
                redDeleteText.value = false;
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_rounded, color: deleteColor, size: 15),
              Text("DELETE",
                  style: TextStyle(
                      fontSize: 14,
                      color: deleteColor,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  replacingDeleteWidget(bool showDeleteText) {
    setState(() {
      this.showDeleteText = showDeleteText;
    });
  }

  moveToVideo() {
    selectedPaged = 2;
    setState(() {
      selectedPage = SelectedPage.right;
      tabController.animateTo(1);
      selectedVideo = true;
      stopScrollTab = true;
      remove = true;
    });
  }

  DefaultTabController defaultTabController() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  dragStartBehavior: DragStartBehavior.start,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CustomScrollView(
                      slivers: [
                        sliverAppBar(),
                        sliverSelectedImage(),
                        sliverGridView(),
                      ],
                    ),
                    CustomCameraDisplay(
                      cameras: widget.cameras,
                      controller: controller,
                      initializeControllerFuture: initializeControllerFuture,
                      replacingTabBar: replacingDeleteWidget,
                      clearVideoRecord: clearVideoRecord,
                      redDeleteText: redDeleteText,
                      moveToVideoScreen: moveToVideo,
                      selectedVideo: selectedVideo,
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  switchInCurve: Curves.easeIn,
                  child: showDeleteText ? deleteButton() : tabBar())
            ],
          ),
        ),
      ),
    );
  }

  centerPage(
      {required bool isThatVideo,
      required int numPage,
      required SelectedPage selectedPage}) {
    selectedPaged = numPage;
    setState(() {
      selectedPage = selectedPage;
      tabController.animateTo(numPage);
      selectedVideo = isThatVideo;
      stopScrollTab = isThatVideo;
      remove = isThatVideo;
    });
  }

  Widget tabBar() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                controller: tabController,
                unselectedLabelColor: Colors.grey,
                labelColor: selectedVideo ? Colors.grey : Colors.black,
                indicatorColor:
                    !selectedVideo ? Colors.black : Colors.transparent,
                labelPadding: const EdgeInsets.all(13),
                tabs: [
                  GestureDetector(
                    onTap: () {
                      centerPage(
                          isThatVideo: false,
                          numPage: 0,
                          selectedPage: SelectedPage.left);
                    },
                    child: const Text("GALLERY",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  GestureDetector(
                    onTap: () {
                      centerPage(
                          isThatVideo: false,
                          numPage: 1,
                          selectedPage: SelectedPage.center);
                    },
                    child: const Text("PHOTO",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                selectedPaged = 2;
                setState(() {
                  tabController.animateTo(1);
                  selectedPage = SelectedPage.right;
                  selectedVideo = true;
                  stopScrollTab = true;
                  remove = true;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40),
                child: Text("VIDEO",
                    style: TextStyle(
                        fontSize: 14,
                        color: selectedVideo ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
        Visibility(
          visible: remove,
          child: AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              onEnd: () {
                if (selectedPage != SelectedPage.right) {
                  setState(() {
                    remove = false;
                  });
                }
              },
              left: selectedPage == SelectedPage.left
                  ? 0
                  : (selectedPage == SelectedPage.center ? 120 : 240),
              child: Container(height: 2, width: 120, color: Colors.black)),
        ),
      ],
    );
  }

  SliverAppBar sliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      stretch: true,
      snap: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.clear_rounded, color: Colors.black, size: 30),
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_forward_rounded,
              color: Colors.blue, size: 30),
          onPressed: () async {
            Uint8List? image = selectedImage ?? firstImage;
            if (image != null) {
              final tempDir = await getTemporaryDirectory();
              File selectedImageFile =
                  await File('${tempDir.path}/image.png').create();
              selectedImageFile.writeAsBytesSync(image);
              File? croppedImage = await cropImage(selectedImageFile);
              if (croppedImage != null) {
                var decodedImage =
                    await decodeImageFromList(croppedImage.readAsBytesSync());
                await Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                        builder: (context) => CreatePostPage(
                            selectedFile: croppedImage,
                            isThatImage: true,
                            aspectRatio:
                            decodedImage.width / decodedImage.height),
                        maintainState: false));
              } else {}
            }
          },
        ),
      ],
    );
  }

  Future<File?> cropImage(File imageFile) async {
    await ImageCrop.requestPermissions();
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      return null;
    }
    final sample = await ImageCrop.sampleImage(
      file: imageFile,
      preferredSize: (2000 / scale).round(),
    );

    final File file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    sample.delete();
    return file;
  }

  IOSUiSettings iosUiSettingsLocked() => IOSUiSettings(
        aspectRatioLockEnabled: false,
        resetAspectRatioEnabled: false,
      );

  AndroidUiSettings androidUiSettingsLocked() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      );

  SliverAppBar sliverSelectedImage() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      stretch: true,
      pinned: true,
      snap: true,
      backgroundColor: Colors.white,
      expandedHeight: 360,
      flexibleSpace: firstImage != null
          ? Container(
              color: Colors.black,
              height: 360,
              width: double.infinity,
              child: Crop.memory(
                  selectedImage != null ? selectedImage! : firstImage!,
                  key: cropKey),
            )
          : Container(),
    );
  }

  stopScrolling(bool neverScroll) {
    setState(() {
      if (neverScroll) {
        shrinkWrap = true;
        neverScrollPhysics = true;
        primary = false;
      } else {
        shrinkWrap = false;
        neverScrollPhysics = false;
        primary = null;
      }
    });
  }

  SliverGrid sliverGridView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 1.7,
        mainAxisSpacing: 1.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _mediaList[index];
        },
        childCount: _mediaList.length,
      ),
    );
  }
}

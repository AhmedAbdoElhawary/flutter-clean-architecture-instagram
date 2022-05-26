import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram/presentation/pages/profile/custom_gallery_page/camera_page.dart';
import 'package:photo_manager/photo_manager.dart';

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
  SelectedPage selectedPage = SelectedPage.left;
  late Future<void> initializeControllerFuture;
  final List<Widget> _mediaList = [];
  late CameraController controller;

  bool showDeleteText = false;
  Uint8List? selectedImage;
  Uint8List? firstImage;
  int currentPage = 0;
  late int lastPage;
  bool initial = true;
  int selectedPaged = 0;
  @override
  void didUpdateWidget(CustomGalleryDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  int currentIndex = 0;
  int previousIndex = 0;
  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
      enableAudio: true,
    );
    initializeControllerFuture = controller.initialize();
    tabController.addListener(() {
      currentIndex = tabController.index;
      previousIndex = tabController.previousIndex;
    });
    _fetchNewMedia();
  }

  @override
  void dispose() {
    controller.dispose();
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

  ValueNotifier<bool> redDeleteText = ValueNotifier(false);
  ValueNotifier<bool> clearVideoRecord = ValueNotifier(false);

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

  bool selectedVideo = false;
  SelectedPage nextRightPage = SelectedPage.center;

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

  bool enter = false;

  bool? stopScrollTab;
  DefaultTabController defaultTabController() {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: tabController,
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
        onHorizontalDragEnd: (e) {
          if (e.velocity.pixelsPerSecond.dx >= 0) {
            if (selectedPaged == 2) {
              centerPage(
                  isThatVideo: false,
                  numPage: 1,
                  selectedPage: SelectedPage.center);
            } else if (selectedPaged == 1) {
              centerPage(
                  isThatVideo: false,
                  numPage: 0,
                  selectedPage: SelectedPage.left);
            }
          } else {
            if (selectedPaged == 0) {
              centerPage(
                  isThatVideo: false,
                  numPage: 1,
                  selectedPage: SelectedPage.center);
            } else if (selectedPaged == 1) {
              selectedPaged = 2;
              setState(() {
                tabController.animateTo(1);
                selectedPage = SelectedPage.right;
                selectedVideo = true;
                stopScrollTab = true;
                remove = true;
              });
            }
          }
        },
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
                tabs: const [
                  Text("GALLERY",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  Text("PHOTO",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40),
              child: Text("VIDEO",
                  style: TextStyle(
                      fontSize: 14,
                      color: selectedVideo ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w500)),
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

  bool remove = false;
  SliverAppBar sliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      stretch: true,
      snap: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.clear_rounded, color: Colors.black, size: 30),
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_forward_rounded,
              color: Colors.blue, size: 30),
          onPressed: () async {
            Uint8List? image = selectedImage ?? firstImage;
            Navigator.of(context).maybePop(File.fromRawPath(image!));
          },
        ),
      ],
    );
  }

  SliverAppBar sliverSelectedImage() {
    return SliverAppBar(
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
              child: Image.memory(
                selectedImage != null ? selectedImage! : firstImage!,
                fit: BoxFit.cover,
              ),
            )
          : Container(),
    );
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

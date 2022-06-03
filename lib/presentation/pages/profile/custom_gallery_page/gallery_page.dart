import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/customPackages/crop_image/crop_image.dart';
import 'package:instagram/presentation/customPackages/crop_image/crop_options.dart';
import 'package:instagram/presentation/pages/profile/create_post_page.dart';
import 'package:instagram/presentation/pages/profile/custom_gallery_page/camera_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:math' as math;

import 'package:shimmer/shimmer.dart';

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
  late ValueNotifier<TabController> tabController =
      ValueNotifier(TabController(length: 2, vsync: this));
  ValueNotifier<bool> clearVideoRecord = ValueNotifier(false);
  ValueNotifier<bool> redDeleteText = ValueNotifier(false);
  ValueNotifier<SelectedPage> selectedPage = ValueNotifier(SelectedPage.left);
  late Future<void> initializeControllerFuture;
  final ValueNotifier<List<Uint8List>> multiSelectedImage = ValueNotifier([]);
  final cropKey = GlobalKey<CropState>();
  late CameraController controller;
  final ValueNotifier<List<FutureBuilder<Uint8List?>>> _mediaList =
      ValueNotifier([]);
  final ValueNotifier<List<Uint8List?>> allImages = ValueNotifier([]);
  final neverScrollPhysics = ValueNotifier(false);
  final multiSelectionMode = ValueNotifier(false);
  final showDeleteText = ValueNotifier(false);
  final selectedVideo = ValueNotifier(false);
  final isImagesReady = ValueNotifier(true);
  final ValueNotifier<Uint8List?> selectedImage = ValueNotifier(null);
  final expandImage = ValueNotifier(false);
  final shrinkWrap = ValueNotifier(false);
  final selectedPaged = ValueNotifier(0);
  final remove = ValueNotifier(false);
  final ValueNotifier<bool?> stopScrollTab = ValueNotifier(null);
  final currentPage = ValueNotifier(0);
  bool initial = true;
  late int lastPage;
  bool? primary;

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
    isImagesReady.value = false;
    _fetchNewMedia();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _handleScrollEvent(ScrollNotification scroll, int currentPage) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
        return true;
      }
    }
    return false;
  }

  _fetchNewMedia() async {
    lastPage = currentPage.value;
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(page: currentPage.value, size: 60);
      List<FutureBuilder<Uint8List?>> temp = [];
      List<Uint8List?> imageTemp = [];
      for (int i = 0; i < media.length; i++) {
        FutureBuilder<Uint8List?> gridViewImage =
            await lowQualityImage(media, i);
        Uint8List? image = await highQualityImage(media, i);

        temp.add(gridViewImage);
        imageTemp.add(image);
      }
      _mediaList.value.addAll(temp);
      allImages.value.addAll(imageTemp);
      currentPage.value++;
      isImagesReady.value = true;
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<Uint8List?> highQualityImage(List<AssetEntity> media, int i) async {
    return media[i].thumbnailDataWithSize(const ThumbnailSize(1200, 1200));
  }

  Future<FutureBuilder<Uint8List?>> lowQualityImage(
      List<AssetEntity> media, int i) async {
    FutureBuilder<Uint8List?> futureBuilder = FutureBuilder(
      future: media[i].thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Uint8List? image = snapshot.data;
          if (image != null) {
            precacheImage(MemoryImage(image), context);
            return Container(
              key: GlobalKey(debugLabel: "exist data"),
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
            );
          }
        }
        return Container(
          key: GlobalKey(debugLabel: "don't exist"),
        );
      },
    );
    return futureBuilder;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPage,
      builder: (context, int currentPageValue, child) =>
          NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          return _handleScrollEvent(scroll, currentPageValue);
        },
        child: defaultTabController(),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.clear_rounded,
            color: Theme.of(context).focusColor, size: 30),
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
    );
  }

  Widget loadingWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          appBar(),
          Shimmer.fromColors(
            baseColor: Theme.of(context).textTheme.headline5!.color!,
            highlightColor: Theme.of(context).textTheme.headline6!.color!,
            child: Column(
              children: [
                Container(
                    color: ColorManager.lightDarkGray,
                    height: 360,
                    width: double.infinity),
                const SizedBox(height: 1),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                        color: ColorManager.lightDarkGray,
                        width: double.infinity);
                  },
                  itemCount: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tapBarMessage(bool isThatDeleteText) {
    Color deleteColor =
        redDeleteText.value ? Colors.red : Theme.of(context).focusColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: GestureDetector(
          onTap: () {
            if (!redDeleteText.value) {
              redDeleteText.value = true;
            } else {
              clearVideoRecord.value = true;
              showDeleteText.value = false;
              redDeleteText.value = false;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isThatDeleteText)
                Icon(Icons.arrow_back_ios_rounded,
                    color: deleteColor, size: 15),
              Text(
                  isThatDeleteText
                      ? StringsManager.delete.tr()
                      : StringsManager.limitOfPhotos.tr(),
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
    this.showDeleteText.value = showDeleteText;
  }

  moveToVideo() {
    selectedPaged.value = 2;
    selectedPage.value = SelectedPage.right;
    tabController.value.animateTo(1);
    selectedVideo.value = true;
    stopScrollTab.value = true;
    remove.value = true;
  }

  DefaultTabController defaultTabController() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: tabController,
                  builder: (context, TabController tabControllerValue, child) =>
                      TabBarView(
                    controller: tabControllerValue,
                    dragStartBehavior: DragStartBehavior.start,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ValueListenableBuilder(
                          valueListenable: isImagesReady,
                          builder: (context, bool isImagesReadyValue, child) {
                            if (isImagesReadyValue) {
                              return ValueListenableBuilder(
                                valueListenable: _mediaList,
                                builder: (context,
                                        List<FutureBuilder<Uint8List?>>
                                            mediaListValue,
                                        child) =>
                                    CustomScrollView(
                                  slivers: [
                                    sliverAppBar(),
                                    sliverSelectedImage(),
                                    sliverGridView(mediaListValue),
                                  ],
                                ),
                              );
                            } else {
                              return loadingWidget();
                            }
                          }),
                      ValueListenableBuilder(
                        valueListenable: selectedVideo,
                        builder: (context, bool selectedVideoValue, child) =>
                            CustomCameraDisplay(
                          cameras: widget.cameras,
                          controller: controller,
                          initializeControllerFuture:
                              initializeControllerFuture,
                          replacingTabBar: replacingDeleteWidget,
                          clearVideoRecord: clearVideoRecord,
                          redDeleteText: redDeleteText,
                          moveToVideoScreen: moveToVideo,
                          selectedVideo: selectedVideoValue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: multiSelectedImage,
                  builder: (context, List<Uint8List> multiSelectedImageValue,
                      child) {
                    if (multiSelectedImageValue.length < 10) {
                      return ValueListenableBuilder(
                        valueListenable: multiSelectionMode,
                        builder:
                            (context, bool multiSelectionModeValue, child) =>
                                Visibility(
                          visible: !multiSelectionModeValue,
                          child: ValueListenableBuilder(
                            valueListenable: showDeleteText,
                            builder:
                                (context, bool showDeleteTextValue, child) =>
                                    AnimatedSwitcher(
                                        duration: const Duration(seconds: 1),
                                        switchInCurve: Curves.easeIn,
                                        child: showDeleteTextValue
                                            ? tapBarMessage(true)
                                            : tabBar()),
                          ),
                        ),
                      );
                    } else {
                      return tapBarMessage(false);
                    }
                  }),
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
    selectedPaged.value = numPage;
    selectedPage = selectedPage;
    tabController.value.animateTo(numPage);
    selectedVideo.value = isThatVideo;
    stopScrollTab.value = isThatVideo;
    remove.value = isThatVideo;
  }

  Widget tabBar() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: tabController,
                builder: (context, TabController tabControllerValue, child) =>
                    ValueListenableBuilder(
                  valueListenable: selectedVideo,
                  builder: (context, bool selectedVideoValue, child) => TabBar(
                    controller: tabControllerValue,
                    unselectedLabelColor: Colors.grey,
                    labelColor: selectedVideoValue
                        ? Colors.grey
                        : Theme.of(context).focusColor,
                    indicatorColor: !selectedVideoValue
                        ? Theme.of(context).focusColor
                        : Colors.transparent,
                    labelPadding: const EdgeInsets.all(13),
                    tabs: [
                      GestureDetector(
                        onTap: () {
                          centerPage(
                              isThatVideo: false,
                              numPage: 0,
                              selectedPage: SelectedPage.left);
                        },
                        child: Text(StringsManager.gallery.tr(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      GestureDetector(
                        onTap: () {
                          centerPage(
                              isThatVideo: false,
                              numPage: 1,
                              selectedPage: SelectedPage.center);
                        },
                        child: Text(StringsManager.photo.tr(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                selectedPaged.value = 2;
                tabController.value.animateTo(1);
                selectedPage.value = SelectedPage.right;
                selectedVideo.value = true;
                stopScrollTab.value = true;
                remove.value = true;
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40),
                child: ValueListenableBuilder(
                  valueListenable: selectedVideo,
                  builder: (context, bool selectedVideoValue, child) => Text(
                      StringsManager.video.tr(),
                      style: TextStyle(
                          fontSize: 14,
                          color: selectedVideoValue
                              ? Theme.of(context).focusColor
                              : Colors.grey,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: remove,
          builder: (context, bool removeValue, child) => Visibility(
            visible: removeValue,
            child: ValueListenableBuilder(
              valueListenable: selectedPage,
              builder: (context, SelectedPage selectedPageValue, child) =>
                  AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      onEnd: () {
                        if (selectedPageValue != SelectedPage.right) {
                          remove.value = false;
                        }
                      },
                      left: selectedPageValue == SelectedPage.left
                          ? 0
                          : (selectedPageValue == SelectedPage.center
                              ? 120
                              : 240),
                      child: Container(
                          height: 2,
                          width: 120,
                          color: Theme.of(context).focusColor)),
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar sliverAppBar() {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      floating: true,
      stretch: true,
      snap: true,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.clear_rounded,
            color: Theme.of(context).focusColor, size: 30),
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_forward_rounded,
              color: Colors.blue, size: 30),
          onPressed: () async {
            double aspect = expandImage.value ? 6 / 8 : 1.0;
            final tempDir = await getTemporaryDirectory();
            File selectedImageFile =
                await File('${tempDir.path}/image.png').create();
            if (multiSelectedImage.value.isEmpty) {
              Uint8List? image = selectedImage.value;
              if (image != null) {
                selectedImageFile.writeAsBytesSync(image);
                File? croppedImage = await cropImage(selectedImageFile);
                File? finalImage = await compressImage(croppedImage!);
                if (finalImage != null) {
                  await Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                          builder: (context) => CreatePostPage(
                              selectedFile: finalImage,
                              isThatImage: true,
                              aspectRatio: aspect),
                          maintainState: false));
                }
              }
            } else {
              List<File> selectedImages = [];
              for (int i = 0; i < multiSelectedImage.value.length; i++) {
                selectedImageFile.writeAsBytesSync(multiSelectedImage.value[i]);
                File? croppedImage = await cropImage(selectedImageFile);
                if (croppedImage != null) {
                  selectedImages.add(croppedImage);
                }
              }
              if (selectedImages.isNotEmpty) {
                await Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                        builder: (context) => CreatePostPage(
                            selectedFile: selectedImages[0],
                            multiSelectedFiles: selectedImages,
                            isThatImage: true,
                            aspectRatio: aspect),
                        maintainState: false));
              }
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

  SliverAppBar sliverSelectedImage() {
    return SliverAppBar(
        automaticallyImplyLeading: false,
        floating: true,
        stretch: true,
        pinned: true,
        snap: true,
        backgroundColor: Theme.of(context).primaryColor,
        expandedHeight: 360,
        flexibleSpace: ValueListenableBuilder(
          valueListenable: selectedImage,
          builder: (context, Uint8List? selectedImageValue, child) {
            if (selectedImageValue != null) {
              return showSelectedImage(context, selectedImageValue);
            } else {
              return Container(
                key: GlobalKey(debugLabel: "do not have"),
              );
            }
          },
        ));
  }

  Container showSelectedImage(
      BuildContext context, Uint8List selectedImageValue) {
    return Container(
      key: GlobalKey(debugLabel: "have image"),
      color: Theme.of(context).primaryColor,
      height: 360,
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: multiSelectionMode,
        builder: (context, bool multiSelectionModeValue, child) => Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: expandImage,
              builder: (context, bool expandImageValue, child) => Crop.memory(
                  selectedImageValue,
                  key: cropKey,
                  aspectRatio: expandImageValue ? 6 / 8 : 1.0),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    multiSelectionMode.value = !multiSelectionMode.value;
                    if (!multiSelectionModeValue) {
                      multiSelectedImage.value.clear();
                    }
                  },
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: multiSelectionModeValue
                            ? Colors.blue
                            : const Color.fromARGB(165, 58, 58, 58),
                        border: Border.all(
                          color: const Color.fromARGB(45, 250, 250, 250),
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.copy,
                        color: Colors.white,
                        size: 17,
                      ))),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    expandImage.value = !expandImage.value;
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(165, 58, 58, 58),
                      border: Border.all(
                        color: const Color.fromARGB(45, 250, 250, 250),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: customArrowsIcon(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack customArrowsIcon() {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Transform.rotate(
            angle: 180 * math.pi / 250,
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Transform.rotate(
            angle: 180 * math.pi / 255,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
      ),
    ]);
  }

  bool selectionImageCheck(Uint8List image, List<Uint8List> multiSelectionValue,
      {bool enableCopy = false}) {
    if (multiSelectionValue.contains(image) && selectedImage.value == image) {
      multiSelectedImage.value.remove(image);
      if (multiSelectionValue.isNotEmpty) {
        selectedImage.value = multiSelectedImage.value.last;
      }
      return true;
    } else {
      if (multiSelectionValue.length < 10) {
        if (!multiSelectionValue.contains(image)) {
          multiSelectedImage.value.add(image);
        }
        if (enableCopy) {
          selectedImage.value = image;
        }
      }
      return false;
    }
  }

  SliverGrid sliverGridView(List<FutureBuilder<Uint8List?>> mediaListValue) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 1.7,
        mainAxisSpacing: 1.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ValueListenableBuilder(
            valueListenable: allImages,
            builder: (context, List<Uint8List?> allImagesValue, child) =>
                ValueListenableBuilder(
              valueListenable: multiSelectedImage,
              builder:
                  (context, List<Uint8List> multiSelectedImageValue, child) =>
                      ValueListenableBuilder(
                valueListenable: selectedImage,
                builder: (context, Uint8List? selectedImageValue, child) {
                  FutureBuilder<Uint8List?> mediaList = mediaListValue[index];
                  Uint8List? image = allImagesValue[index];
                  if (image != null) {
                    bool imageSelected =
                        multiSelectedImageValue.contains(image);
                    if (index == 0 && selectedImageValue == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          selectedImage.value = image;
                        });
                      });
                    }
                    return Stack(
                      children: [
                        gestureDetector(image, index, mediaList),
                        if (selectedImageValue == image)
                          GestureDetector(
                            child:
                                gestureDetector(image, index, blurContainer()),
                          ),
                        ValueListenableBuilder(
                          valueListenable: multiSelectionMode,
                          builder:
                              (context, bool multiSelectionModeValue, child) =>
                                  Visibility(
                            visible: multiSelectionModeValue,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: imageSelected
                                          ? Colors.blue
                                          : const Color.fromARGB(
                                              115, 222, 222, 222),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: imageSelected
                                        ? Center(
                                            child: Text(
                                            "${multiSelectedImageValue.indexOf(image) + 1}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ))
                                        : Container(),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          );
        },
        childCount: mediaListValue.length,
      ),
    );
  }

  Container blurContainer() {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(184, 234, 234, 234),
      height: double.maxFinite,
    );
  }

  Widget gestureDetector(Uint8List image, int index, Widget childWidget) {
    return ValueListenableBuilder(
      valueListenable: multiSelectedImage,
      builder: (context, List<Uint8List> multiSelectionValue, child) =>
          ValueListenableBuilder(
        valueListenable: multiSelectionMode,
        builder: (context, bool multiSelectionModeValue, child) =>
            GestureDetector(
                onTap: () {
                  if (multiSelectionModeValue) {
                    bool close =
                        selectionImageCheck(image, multiSelectionValue);
                    if (close) return;
                  }
                  selectedImage.value = image;
                },
                onLongPress: () {
                  if (!multiSelectionModeValue) {
                    multiSelectionMode.value = true;
                  }
                },
                onLongPressUp: () {
                  selectionImageCheck(image, multiSelectionValue,
                      enableCopy: true);
                },
                child: childWidget),
      ),
    );
  }
}

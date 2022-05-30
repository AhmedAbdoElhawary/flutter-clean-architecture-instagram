import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:photo_manager/photo_manager.dart';

class CustomStoryGalleryDisplay extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CustomStoryGalleryDisplay({Key? key, required this.cameras})
      : super(key: key);

  @override
  CustomStoryGalleryDisplayState createState() =>
      CustomStoryGalleryDisplayState();
}

class CustomStoryGalleryDisplayState extends State<CustomStoryGalleryDisplay>
    with TickerProviderStateMixin {
  List<Uint8List> multiSelectedImage = [];
  final List<FutureBuilder<Uint8List?>> _mediaList = [];
  List<Uint8List?> allImages = [];
  Uint8List? selectedImage;
  int currentPage = 0;
  late int lastPage;

  @override
  void didUpdateWidget(CustomStoryGalleryDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _fetchNewMedia();
    super.initState();
  }

  @override
  void dispose() {
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
      List<FutureBuilder<Uint8List?>> temp = [];
      List<Uint8List?> imageTemp = [];
      for (int i = 0; i < media.length; i++) {
        FutureBuilder<Uint8List?> gridViewImage =
            await lowQualityImage(media, i);
        Uint8List? image = await highQualityImage(media, i);

        temp.add(gridViewImage);
        imageTemp.add(image);
      }

      setState(() {
        _mediaList.addAll(temp);
        allImages.addAll(imageTemp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  bool multiSelectionMode = false;

  Future<Uint8List?> highQualityImage(List<AssetEntity> media, int i) async {
    return media[i].thumbnailDataWithSize(const ThumbnailSize(1000, 1000));
  }

  Future<FutureBuilder<Uint8List?>> lowQualityImage(
      List<AssetEntity> media, int i) async {
    FutureBuilder<Uint8List?> futureBuilder = FutureBuilder(
      future: media[i].thumbnailDataWithSize(const ThumbnailSize(300, 300)),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Uint8List? image = snapshot.data;
          if (image != null) {
            Color color = Colors.blueGrey;
            Future<PaletteGenerator> backgroundColor =
                PaletteGenerator.fromImageProvider(MemoryImage(image),
                    size: const Size(200, 100));
            backgroundColor.then((value) {
              setState((){
                color = value.darkMutedColor!.color;
              });
            });
            return Container(
              color: Colors.grey,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.memory(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(child: Container(color: color)),
                  // Positioned.fill(
                  //     child: ImageFiltered(
                  //   imageFilter: ImageFilter.blur(sigmaY: 100, sigmaX: 100,tileMode: TileMode.clamp),
                  //   child: Container(color: Colors.transparent),
                  // )),
                  Positioned.fill(
                    child: Image.memory(
                      image,
                      fit: BoxFit.fitWidth,
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
        return Container();
      },
    );
    return futureBuilder;
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

  Scaffold defaultTabController() {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appBar(),
      body: gridView(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: ColorManager.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.clear_rounded,
            color: ColorManager.white, size: 30),
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      centerTitle: true,
      title: const Text(
        "Add to story",
        style:
            TextStyle(color: ColorManager.white, fontWeight: FontWeight.w500),
      ),
      actions: const [
        Icon(Icons.settings_suggest_rounded,
            color: ColorManager.white, size: 30),
      ],
    );
  }

  GridView gridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.7,
        mainAxisSpacing: 1.5,
        childAspectRatio: .5,
      ),
      itemBuilder: (context, index) {
        FutureBuilder<Uint8List?> mediaList = _mediaList[index];
        Uint8List? image = allImages[index];
        if (image != null) {
          if (index == 0 && selectedImage == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedImage = image;
              });
            });
          }
          return GestureDetector(onTap: () {}, child: mediaList);
        } else {
          return Container();
        }
      },
      itemCount: _mediaList.length,
    );
  }
}

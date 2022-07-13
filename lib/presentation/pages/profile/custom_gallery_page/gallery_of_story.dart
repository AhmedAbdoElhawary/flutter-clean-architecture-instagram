import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/pages/story/create_story.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/custom_gallery/fetching_media_gallery.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';

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
  final List<FutureBuilder<Uint8List?>> _mediaList = [];
  List<File?> allImages = [];
  bool isImagesReady = true;
  File? selectedImage;
  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    isImagesReady = false;
    _fetchNewMedia();
    super.initState();
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
    lastPage = currentPage;
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(page: currentPage, size: 60);
      List<FutureBuilder<Uint8List?>> temp = [];
      List<File?> imageTemp = [];
      for (int i = 0; i < media.length; i++) {
        FutureBuilder<Uint8List?> gridViewImage =
            await getImageGallery(media, i);
        File? image = await highQualityImage(media, i);
        temp.add(gridViewImage);
        imageTemp.add(image);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        setState(() {
          _mediaList.addAll(temp);
          allImages.addAll(imageTemp);
          currentPage++;
          isImagesReady = true;
        });
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        return _handleScrollEvent(scroll, currentPage);
      },
      child: defaultTabController(),
    );
  }

  Widget loadingWidget() {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[500]!,
        highlightColor: ColorManager.shimmerDarkGrey,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1.7,
            mainAxisSpacing: 1.5,
            childAspectRatio: .5,
          ),
          itemBuilder: (context, index) {
            return Container(
                color: ColorManager.lightDarkGray,
                height: 50,
                width: double.infinity);
          },
          itemCount: 15,
        ),
      ),
    );
  }

  Scaffold defaultTabController() {
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: isThatMobile ? appBar() : null,
      body: isImagesReady ? gridView() : loadingWidget(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: ColorManager.black,
      elevation: 0,
      leading: iconButton(),
      centerTitle: true,
      title: Text(
        StringsManager.addToStory.tr(),
        style: const TextStyle(
            color: ColorManager.white, fontWeight: FontWeight.w500),
      ),
      actions: const [
        Icon(Icons.settings_rounded, color: ColorManager.white, size: 30),
      ],
    );
  }

  IconButton iconButton() {
    return IconButton(
      icon:
          const Icon(Icons.clear_rounded, color: ColorManager.white, size: 30),
      onPressed: () {
        Navigator.of(context).maybePop();
      },
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
        FutureBuilder<Uint8List?> listOfMedia = _mediaList[index];
        File? image = allImages[index];
        if (image != null) {
          if (index == 0 && selectedImage == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedImage = image;
              });
            });
          }
          return gestureDetector(context, image, listOfMedia);
        } else {
          return Container();
        }
      },
      itemCount: _mediaList.length,
    );
  }

  GestureDetector gestureDetector(
      BuildContext context, File image, FutureBuilder<Uint8List?> listOfMedia) {
    return GestureDetector(
        onTap: () async {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) {
                return CreateStoryPage(
                  isThatImage: true,
                  storyImage: image,
                );
              },
              maintainState: false));
        },
        child: listOfMedia);
  }
}

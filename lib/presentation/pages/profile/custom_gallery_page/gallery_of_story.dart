import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
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
  final ValueNotifier<List<FutureBuilder<File?>>> mediaList =
  ValueNotifier([]);
  final ValueNotifier<List<File>> multiSelectedImage = ValueNotifier([]);
  final ValueNotifier<List<File?>> allImages = ValueNotifier([]);
  ValueNotifier<bool> isImagesReady = ValueNotifier(true);
  final ValueNotifier<File?> selectedImage = ValueNotifier(null);
  final currentPage = ValueNotifier(0);
  late int lastPage;

  @override
  void didUpdateWidget(CustomStoryGalleryDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    isImagesReady.value = false;
    _fetchNewMedia();
    super.initState();
  }

  @override
  void dispose() {
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
      List<FutureBuilder<File?>> temp = [];
      List<File?> imageTemp = [];
      for (int i = 0; i < media.length; i++) {
        await getImageGallery(media, i).then((value) async {
          temp.add(value);
          await value.future!.then((File? value) {
            if (value != null) {
              imageTemp.add(value);
            }
          });
        });
      }
      mediaList.value.addAll(temp);
      allImages.value.addAll(imageTemp);
      currentPage.value++;
      isImagesReady.value = true;
    } else {
      PhotoManager.openSetting();
    }
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
  Widget loadingWidget() {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor:  Colors.grey[500]!,
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
      appBar: appBar(),
      body:isImagesReady.value ? gridView():loadingWidget(),
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

  GridView gridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.7,
        mainAxisSpacing: 1.5,
        childAspectRatio: .5,
      ),
      itemBuilder: (context, index) {
        FutureBuilder<File?> listOfMedia = mediaList.value[index];
        File? image = allImages.value[index];
        if (image != null) {
          if (index == 0 && selectedImage.value == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedImage.value = image;
              });
            });
          }
          return GestureDetector(
              onTap: () async {
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(
                    builder: (context) {
                      return CreateStoryPage(
                        isThatImage: true,
                        storyImage: image,
                      );
                    },
                    maintainState: false));
              },
              child: listOfMedia);
        } else {
          return Container();
        }
      },
      itemCount: mediaList.value.length,
    );
  }
}

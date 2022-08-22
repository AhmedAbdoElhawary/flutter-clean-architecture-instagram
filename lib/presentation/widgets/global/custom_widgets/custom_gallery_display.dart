import 'dart:io';
import 'dart:typed_data';

import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/pages/profile/create_post_page.dart';
import 'package:instagram/presentation/pages/story/create_story.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CustomGalleryDisplay extends StatefulWidget {
  const CustomGalleryDisplay({Key? key}) : super(key: key);

  @override
  State<CustomGalleryDisplay> createState() => _CustomGalleryDisplayState();
}

class _CustomGalleryDisplayState extends State<CustomGalleryDisplay> {
  @override
  Widget build(BuildContext context) {
    return CustomGallery.instagramDisplay(
      tabsTexts: tapsNames(),
      appTheme: appTheme(context),
      sendRequestFunction: (SelectedImagesDetails d) =>
          moveToCreationPage(context, d),
    );
  }

  AppTheme appTheme(BuildContext context) {
    return AppTheme(
        focusColor: Theme.of(context).focusColor,
        primaryColor: Theme.of(context).primaryColor,
        shimmerBaseColor: Theme.of(context).textTheme.headline5!.color!,
        shimmerHighlightColor: Theme.of(context).textTheme.headline6!.color!);
  }

  TabsTexts tapsNames() {
    return TabsTexts(
      deletingText: StringsManager.delete.tr,
      galleryText: StringsManager.gallery.tr,
      holdButtonText: StringsManager.pressAndHold.tr,
      limitingText: StringsManager.limitOfPhotos.tr,
      clearImagesText: StringsManager.clearSelectedImages.tr,
      notFoundingCameraText: StringsManager.noSecondaryCameraFound.tr,
      photoText: StringsManager.photo.tr,
      videoText: StringsManager.video.tr,
    );
  }
}

Future<void> moveToCreationPage(
    BuildContext context, SelectedImagesDetails details,
    {bool isThatStory = false}) async {
  List<Uint8List> selectedUint8Lists = [];
  if (details.selectedFiles != null && details.multiSelectionMode) {
    for (final image in details.selectedFiles!) {
      Uint8List bytesSelectedFiles = await image.readAsBytes();
      Uint8List convertedFile =
          (await compressImage(bytesSelectedFiles)) ?? bytesSelectedFiles;
      selectedUint8Lists.add(convertedFile);
    }
  }

  File file = details.multiSelectionMode && details.selectedFiles != null
      ? details.selectedFiles![0]
      : details.selectedFile;
  Uint8List bytesFile = await file.readAsBytes();

  if (isThatStory) {
    // ignore: use_build_context_synchronously
    await pushToPage(context,
        page: CreateStoryPage(
            storyImage: bytesFile, isThatImage: details.isThatImage));
  } else {
    if (!details.isThatImage) {
      final convertImage = await VideoThumbnail.thumbnailData(
        video: details.selectedFile.path,
        imageFormat: ImageFormat.PNG,
      );
      Uint8List convertVideo = await details.selectedFile.readAsBytes();

      // ignore: use_build_context_synchronously
      await pushToPage(context,
          page: CreatePostPage(
            aspectRatio: 1,
            multiSelectedFiles: [convertVideo],
            isThatImage: false,
            coverOfVideoBytes: convertImage,
          ));
    } else {
      // ignore: use_build_context_synchronously
      await pushToPage(
        context,
        page: CreatePostPage(
          multiSelectedFiles:
              selectedUint8Lists.isNotEmpty ? selectedUint8Lists : [bytesFile],
          isThatImage: details.isThatImage,
          aspectRatio: details.aspectRatio,
        ),
      );
    }
  }
}

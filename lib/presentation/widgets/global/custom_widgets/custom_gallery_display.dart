import 'dart:io';
import 'dart:typed_data';

import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/pages/profile/create_post_page.dart';
import 'package:instagram/presentation/pages/story/create_story.dart';

class CustomGalleryDisplay extends StatefulWidget {
  const CustomGalleryDisplay({Key? key}) : super(key: key);

  @override
  State<CustomGalleryDisplay> createState() => _CustomGalleryDisplayState();
}

class _CustomGalleryDisplayState extends State<CustomGalleryDisplay> {
  @override
  Widget build(BuildContext context) {
    return CustomGallery.instagramDisplay(
      tabsNames: tapsNames(),
      appTheme: appTheme(context),
      moveToPage: (SelectedImageDetails d) => moveToCreatePostPage(context, d),
    );
  }

  AppTheme appTheme(BuildContext context) {
    return AppTheme(
        focusColor: Theme.of(context).focusColor,
        primaryColor: Theme.of(context).primaryColor,
        shimmerBaseColor: Theme.of(context).textTheme.headline5!.color!,
        shimmerHighlightColor: Theme.of(context).textTheme.headline6!.color!);
  }

  TabsNames tapsNames() {
    return TabsNames(
      deletingName: StringsManager.delete.tr(),
      galleryName: StringsManager.gallery.tr(),
      holdButtonName: StringsManager.pressAndHold.tr(),
      limitingName: StringsManager.limitOfPhotos.tr(),
      clearImagesName: StringsManager.clearSelectedImages.tr(),
      notFoundingCameraName: StringsManager.noSecondaryCameraFound.tr(),
      photoName: StringsManager.photo.tr(),
      videoName: StringsManager.video.tr(),
    );
  }
}

Future<void> moveToCreatePostPage(
    BuildContext context, SelectedImageDetails details,
    {bool isThatStory = false}) async {
  List<Uint8List> selectedUint8Lists = [];
  if (details.selectedFiles != null && details.multiSelectionMode) {
    for (int i = 0; i < details.selectedFiles!.length; i++) {
      final image = details.selectedFiles![i];
      Uint8List bytesSelectedFiles = image.readAsBytesSync();
      ByteData.view(bytesSelectedFiles.buffer);
      Uint8List convertedFile =
          (await compressImage(bytesSelectedFiles)) ?? bytesSelectedFiles;
      selectedUint8Lists.add(convertedFile);
    }
  }

  File file = details.multiSelectionMode
      ? details.selectedFiles![0]
      : details.selectedFile;
  Uint8List bytesFile = file.readAsBytesSync();
  ByteData.view(bytesFile.buffer);
  if (isThatStory) {
    await pushToPage(context,
        page: CreateStoryPage(
            storyImage: bytesFile, isThatImage: details.isThatImage));
  } else {
    await pushToPage(context,
        page: CreatePostPage(
            selectedFile: bytesFile,
            multiSelectedFiles: selectedUint8Lists,
            isThatImage: details.isThatImage,
            aspectRatio: details.aspectRatio));
  }
}

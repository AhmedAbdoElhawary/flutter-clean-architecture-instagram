import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/pages/profile/create_post_page.dart';

class CustomImagePickerPlus {
  static Future<void> pickFromBoth(BuildContext context) async {
    ImagePickerPlus picker = ImagePickerPlus(context);
    await picker.pickImage(
      source: ImageSource.both,
      multiImages: true,
      galleryDisplaySettings: GalleryDisplaySettings(
        showImagePreview: true,
        cropImage: true,
        tabsTexts: tapsNames(),
        appTheme: appTheme(context),
        callbackFunction: (details) async {
          await moveToCreationPage(context, details);
        },
      ),
    );
  }

  static Future<SelectedImagesDetails?> pickImage(BuildContext context,
      {ImageSource source = ImageSource.gallery,
      bool isThatStory = false}) async {
    ImagePickerPlus picker = ImagePickerPlus(context);
    SelectedImagesDetails? details = await picker.pickImage(
      source: source,
      multiImages: isThatStory,
      galleryDisplaySettings: GalleryDisplaySettings(
        tabsTexts: tapsNames(),
        appTheme: appTheme(context),
        gridDelegate: _sliverGridDelegate(isThatStory),
      ),
    );
    return details;
  }

  static Future<void> pickVideo(BuildContext context,
      {ImageSource source = ImageSource.both}) async {
    ImagePickerPlus picker = ImagePickerPlus(context);

    await picker.pickVideo(
      source: source,
      galleryDisplaySettings: GalleryDisplaySettings(
        showImagePreview: true,
        cropImage: true,
        tabsTexts: tapsNames(),
        appTheme: appTheme(context),
        callbackFunction: (details) async {
          await moveToCreationPage(context, details);
        },
      ),
    );
  }

  static SliverGridDelegateWithFixedCrossAxisCount _sliverGridDelegate(
      bool isThatStory) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: isThatStory ? 3 : 4,
      crossAxisSpacing: 1.7,
      mainAxisSpacing: 1.5,
      childAspectRatio: isThatStory ? .5 : 1,
    );
  }

  static AppTheme appTheme(BuildContext context) {
    return AppTheme(
        focusColor: Theme.of(context).focusColor,
        primaryColor: Theme.of(context).primaryColor,
        shimmerBaseColor: Theme.of(context).textTheme.headlineSmall!.color!,
        shimmerHighlightColor: Theme.of(context).textTheme.titleLarge!.color!);
  }

  static TabsTexts tapsNames() {
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

  static Future<void> moveToCreationPage(
      BuildContext context, SelectedImagesDetails details) async {
    for (final selectedFiles in details.selectedFiles) {
      if (!selectedFiles.isThatImage) continue;
      File file = selectedFiles.selectedFile;
      File? compressByte = await CompressImage.compressFile(file);
      File convertedFile = compressByte ?? file;
      selectedFiles.selectedFile = convertedFile;
    }

    //ignore: use_build_context_synchronously
    await Go(context).push(
      page: CreatePostPage(selectedFilesDetails: details),
    );
  }
}

import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/selected_byte.dart';
import 'package:instagram/presentation/pages/profile/create_post_page.dart';

/// the callers pass these to [CustomImagePickerPlus], so they come with it
export 'package:image_picker_plus/image_picker_plus.dart'
    show PickerSource, MediaType;

class CustomImagePickerPlus {
  /// the limitOfPhotos text already names the number, so it has to stay in step
  static const int _maxSelection = 10;

  static Future<void> pickFromBoth(BuildContext context) async {
    SelectedImagesDetails? details = await pickImage(
      context,
      source: PickerSource.both,
      mediaType: MediaType.all,
      multiImages: true,
    );
    if (details == null || !context.mounted) return;
    await moveToCreationPage(context, details);
  }

  static Future<SelectedImagesDetails?> pickImage(
    BuildContext context, {
    PickerSource source = PickerSource.gallery,
    MediaType mediaType = MediaType.image,
    bool multiImages = false,
    bool isThatStory = false,
    bool showPreview = true,
  }) async {
    final items = await ImagePickerPlus.pick(
      context,
      settings: PickerSettings(
        source: source,
        mediaType: mediaType,
        maxSelection: multiImages || isThatStory ? _maxSelection : 1,
        gridColumns: isThatStory ? 3 : 4,
        gridCellAspectRatio: isThatStory ? .5 : 1,
        texts: tapsNames(),
        showPreview: showPreview,
        useRootNavigator: true,
        alwaysDarkTheme: false,
      ),
    );

    if (items == null || items.isEmpty) return null;
    return SelectedImagesDetails.fromPickedItems(items);
  }

  static Future<void> pickVideo(
    BuildContext context, {
    PickerSource source = PickerSource.both,
  }) async {
    SelectedImagesDetails? details = await pickImage(
      context,
      source: source,
      showPreview: false,
      mediaType: MediaType.video,
    );
    if (details == null || !context.mounted) return;
    await moveToCreationPage(context, details);
  }

  static PickerTheme appTheme(BuildContext context) {
    return PickerTheme(
      background: Theme.of(context).primaryColor,
      surface: Theme.of(context).primaryColor,
      onSurface: Theme.of(context).focusColor,
      onSurfaceMuted: Theme.of(context).textTheme.headlineSmall!.color!,
      accent: ColorManager.blue,
      onAccent: ColorManager.white,
      scrim: ColorManager.black,
    );
  }

  static PickerTexts tapsNames() {
    return PickerTexts(
      gallery: StringsManager.gallery.tr,
      photo: StringsManager.photo.tr,
      video: StringsManager.video.tr,
      noCamera: StringsManager.noSecondaryCameraFound.tr,
      maxReached: StringsManager.limitOfPhotos.tr,
      cancel: StringsManager.cancel.tr,
    );
  }

  static Future<void> moveToCreationPage(
    BuildContext context,
    SelectedImagesDetails details,
  ) async {
    for (final selectedFiles in details.selectedFiles) {
      if (!selectedFiles.isThatImage) continue;
      File file = selectedFiles.selectedFile;
      File? compressByte = await CompressImage.compressFile(file);
      File convertedFile = compressByte ?? file;
      selectedFiles.selectedFile = convertedFile;
    }

    //ignore: use_build_context_synchronously
    await Go(context).push(page: CreatePostPage(selectedFilesDetails: details));
  }
}

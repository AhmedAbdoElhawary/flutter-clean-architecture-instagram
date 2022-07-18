import 'package:universal_io/io.dart';

import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/presentation/pages/story/create_story.dart';

class CreateNewStory extends StatefulWidget {
  const CreateNewStory({Key? key}) : super(key: key);

  @override
  State<CreateNewStory> createState() => _CreateNewStoryState();
}

class _CreateNewStoryState extends State<CreateNewStory> {
  @override
  Widget build(BuildContext context) {
    return CustomGallery.normalDisplay(
      appTheme: appStoryTheme(),
      moveToPage: moveToCreateStoryPage,
    );
  }

  AppTheme appStoryTheme() {
    return AppTheme(
        primaryColor: ColorManager.black, focusColor: ColorManager.white);
  }

  Future<void> moveToCreateStoryPage(SelectedImageDetails details) async {
    final singleImage = details.selectedFile;
    details.selectedFile = await compressImage(singleImage) ?? singleImage;
    if (details.selectedFiles != null && details.multiSelectionMode) {
      final image = details.selectedFiles![0];
      details.selectedFiles![0] = (await compressImage(image)) ?? image;
    }
    File file = details.multiSelectionMode
        ? details.selectedFiles![0]
        : details.selectedFile;
    await Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
        builder: (context) => CreateStoryPage(
              storyImage: file,
              isThatImage: details.isThatImage,
            ),
        maintainState: false));
  }
}

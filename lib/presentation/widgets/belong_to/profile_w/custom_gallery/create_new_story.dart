import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';

class CreateNewStory extends StatefulWidget {
  const CreateNewStory({Key? key}) : super(key: key);

  @override
  State<CreateNewStory> createState() => _CreateNewStoryState();
}

class _CreateNewStoryState extends State<CreateNewStory> {
  @override
  Widget build(BuildContext context) => CustomGallery.normalDisplay(
        appTheme: appStoryTheme(),
        sendRequestFunction: (SelectedImagesDetails details) =>
            moveToCreatePostPage(context, details, isThatStory: true),
      );

  AppTheme appStoryTheme() => AppTheme(
      primaryColor: ColorManager.black, focusColor: ColorManager.white);
}

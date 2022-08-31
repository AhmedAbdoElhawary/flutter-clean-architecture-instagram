import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';

class CreateNewStory extends StatefulWidget {
  final bool isThatStory;
  const CreateNewStory({Key? key, this.isThatStory = true}) : super(key: key);

  @override
  State<CreateNewStory> createState() => _CreateNewStoryState();
}

class _CreateNewStoryState extends State<CreateNewStory> {
  @override
  Widget build(BuildContext context) => CustomGallery.normalDisplay(
        appTheme: appStoryTheme(),
        sendRequestFunction: (SelectedImagesDetails details) =>
            moveToCreationPage(context, details,
                isThatStory: widget.isThatStory),
      );

  AppTheme appStoryTheme() => AppTheme(
      primaryColor: ColorManager.black, focusColor: ColorManager.white);
}

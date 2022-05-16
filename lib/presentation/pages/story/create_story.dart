import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/story.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_elevated_button.dart';

class CreateStoryPage extends StatefulWidget {
  final File storyImage;
  final bool isThatImage;

  const CreateStoryPage(
      {Key? key, required this.storyImage, this.isThatImage = true})
      : super(key: key);

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  bool isItDone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).focusColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.file(widget.storyImage)),
            Container(
              decoration: const BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              child: listOfAddPost(),
            ),
          ],
        ),
      ),
    );
  }

  Widget listOfAddPost() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            IconsAssets.minusIcon,
            color: ColorManager.black87,
            height: 40,
          ),
          Text(StringsManager.create.tr(),
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          const Divider(),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: Builder(builder: (builderContext) {
              FirestoreUserInfoCubit userCubit =
                  BlocProvider.of<FirestoreUserInfoCubit>(builderContext,
                      listen: false);
              UserPersonalInfo? personalInfo = userCubit.myPersonalInfo;

              return Container(
                margin: const EdgeInsetsDirectional.all(3.0),
                child: CustomElevatedButton(
                  onPressed: () =>
                      createPost(personalInfo!, userCubit, builderContext),
                  isItDone: isItDone,
                  nameOfButton: StringsManager.share.tr(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> createPost(UserPersonalInfo personalInfo,
      FirestoreUserInfoCubit userCubit, BuildContext builder2context) async {
    if (isItDone) {
      Story storyInfo = addStoryInfo(personalInfo);
      setState(() {
        isItDone = false;
      });
      StoryCubit storyCubit =
          BlocProvider.of<StoryCubit>(builder2context, listen: false);

      await storyCubit
          .createStory(storyInfo, widget.storyImage)
          .then((_) async {
        if (storyCubit.storyId != '') {
          await userCubit.updateStoriesPostsInfo(
              userId: personalInfo.userId, storyId: storyCubit.storyId);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isItDone = true;
              Navigator.maybePop(context);
            });
          });
        }
      });
    }
  }

  Story addStoryInfo(UserPersonalInfo personalInfo) {
    return Story(
      publisherId: personalInfo.userId,
      datePublished: DateOfNow.dateOfNow(),
      caption: "",
      comments: [],
      likes: [],
      isThatImage: widget.isThatImage,
    );
  }
}

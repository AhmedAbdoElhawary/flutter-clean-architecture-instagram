import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/globall.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/data/models/story.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';

class NewStoryPage extends StatefulWidget {
  final File storyImage;
  final bool isThatImage;

  const NewStoryPage(
      {Key? key, required this.storyImage, this.isThatImage = true})
      : super(key: key);

  @override
  State<NewStoryPage> createState() => _NewStoryPageState();
}

class _NewStoryPageState extends State<NewStoryPage> {
  bool isItDone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            IconsAssets.minusIcon,
            color: ColorManager.black87,
            height: 40,
          ),
          const Text(StringsManager.create,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Builder(builder: (builderContext) {
              FirestoreUserInfoCubit userCubit =
                  BlocProvider.of<FirestoreUserInfoCubit>(builderContext,
                      listen: false);
              UserPersonalInfo? personalInfo = userCubit.myPersonalInfo;

              return Container(
                margin: const EdgeInsets.all(3.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 140.0)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isItDone
                                ? Colors.blue
                                : const Color.fromARGB(255, 127, 193, 255))),
                    onPressed: () =>
                        createPost(personalInfo!, userCubit, builderContext),
                    child: isItDone
                        ? const Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Text(
                              StringsManager.share,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(3.0),
                            child: ClipOval(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          )),
              );
            }),
          ),
        ],
      ),
    );
  }

  createPost(UserPersonalInfo personalInfo, FirestoreUserInfoCubit userCubit,
      BuildContext builder2context) {
    if (isItDone) {
      Story storyInfo = addStoryInfo(personalInfo);
      setState(() {
        isItDone = false;
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        StoryCubit storyCubit =
            BlocProvider.of<StoryCubit>(builder2context, listen: false);

        await storyCubit
            .createStory(storyInfo, widget.storyImage)
            .then((_) async {
          if (storyCubit.storyId != '') {
            await userCubit.updateStoriesPostsInfo(
                userId: personalInfo.userId, storyId: storyCubit.storyId);
            setState(() {
              isItDone = true;
              Navigator.maybePop(context);
            });
          }
        });
      });
    }
  }

  Story addStoryInfo(UserPersonalInfo personalInfo) {
    return Story(
      publisherId: personalInfo.userId,
      datePublished: DateOfNow.dateOfNow(),
      //TODO here
      // caption: captionController.text,
      caption: "",
      comments: [],
      likes: [],
      isThatImage: widget.isThatImage,
    );
  }
}

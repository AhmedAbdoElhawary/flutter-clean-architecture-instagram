import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/functions/blur_hash.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/post/story.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/popup_calling.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateStoryPage extends StatefulWidget {
  final Uint8List storyImage;
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.memory(widget.storyImage)),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25.0)),
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
            color: Theme.of(context).focusColor,
            height: 40,
          ),
          Text(StringsManager.create.tr,
              style: getMediumStyle(
                  color: Theme.of(context).focusColor, fontSize: 20)),
          const Divider(),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: Builder(builder: (builderContext) {
              UserInfoCubit userCubit =
                  BlocProvider.of<UserInfoCubit>(builderContext, listen: false);
              UserPersonalInfo? personalInfo = userCubit.myPersonalInfo;

              return Container(
                margin: const EdgeInsetsDirectional.all(3.0),
                child: CustomElevatedButton(
                  onPressed: () async {
                    return await createStory(
                        personalInfo, userCubit, builderContext);
                  },
                  isItDone: isItDone,
                  nameOfButton: StringsManager.share.tr,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> createStory(UserPersonalInfo personalInfo,
      UserInfoCubit userCubit, BuildContext builder2context) async {
    if (isItDone) {
      setState(() => isItDone = false);
      String blurHash = await blurHashEncode(widget.storyImage);
      Story storyInfo = addStoryInfo(personalInfo, blurHash);
      if (!mounted) return;
      StoryCubit storyCubit = StoryCubit.get(context);
      await storyCubit.createStory(storyInfo, widget.storyImage);
      if (storyCubit.storyId != '') {
        userCubit.updateMyStories(storyId: storyCubit.storyId);
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(() => isItDone = true));
        final SharedPreferences sharePrefs =
            await SharedPreferences.getInstance();
        sharePrefs.remove(myPersonalId);
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (_) => PopupCalling(myPersonalId)),
          (route) => false,
        );
      }
    }
  }

  Story addStoryInfo(UserPersonalInfo personalInfo, String blurHash) {
    return Story(
      publisherId: personalInfo.userId,
      datePublished: DateOfNow.dateOfNow(),
      caption: "",
      comments: [],
      likes: [],
      blurHash: blurHash,
      isThatImage: widget.isThatImage,
    );
  }
}

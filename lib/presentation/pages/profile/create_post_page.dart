import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';

class CreatePostPage extends StatefulWidget {
  final File selectedFile;
  final bool isThatImage;
  final bool isThatStory;
  final double aspectRatio;
  const CreatePostPage(
      {Key? key,
      required this.selectedFile,
      required this.aspectRatio,
      this.isThatImage = true,
      this.isThatStory = false})
      : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isSwitched = false;
  bool isItDone = true;

  TextEditingController captionController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => injector<PostCubit>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: appBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 10.0, end: 10, top: 10),
              child: Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: widget.isThatImage
                        ? Image.file(widget.selectedFile)
                        : const Center(
                            child: Icon(Icons.slow_motion_video_sharp)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: captionController,
                      cursorColor: ColorManager.teal,
                      style: getNormalStyle(
                          color: Theme.of(context).focusColor, fontSize: 15),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManager.writeACaption.tr(),
                        hintStyle:
                            TextStyle(color: Theme.of(context).cardColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            buildText(StringsManager.tagPeople.tr()),
            const Divider(),
            buildText(StringsManager.addLocation.tr()),
            const Divider(),
            buildText(StringsManager.alsoPostTo.tr()),
            Row(
              children: [
                Expanded(child: buildText(StringsManager.facebook.tr())),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    // setState(() {
                    isSwitched = value;
                    // });
                  },
                  activeTrackColor: ColorManager.blue,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding buildText(String text) {
    return Padding(
        padding: const EdgeInsetsDirectional.only(
            start: 7, end: 7, bottom: 10, top: 10),
        child: Text(
          text,
          style: getNormalStyle(
              fontSize: 16.5, color: Theme.of(context).focusColor),
        ));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          StringsManager.newPost.tr(),
          style: getNormalStyle(color: Theme.of(context).focusColor),
        ),
        actions: actionsWidgets(context));
  }

  List<Widget> actionsWidgets(BuildContext context) {
    return [
      Builder(builder: (builderContext) {
        FirestoreUserInfoCubit userCubit =
            BlocProvider.of<FirestoreUserInfoCubit>(builderContext,
                listen: false);
        UserPersonalInfo? personalInfo = userCubit.myPersonalInfo;

        return Builder(
          builder: (builder2context) {
            return !isItDone
                ? const CustomCircularProgress(ColorManager.blue)
                : IconButton(
                    onPressed: () =>
                        createPost(personalInfo!, userCubit, builder2context),
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 30,
                      color: ColorManager.blue,
                    ));
          },
        );
      })
    ];
  }

  createPost(UserPersonalInfo personalInfo, FirestoreUserInfoCubit userCubit,
      BuildContext builder2context) {
    Post postInfo = addPostInfo(personalInfo);
    setState(() {
      isItDone = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PostCubit postCubit =
          BlocProvider.of<PostCubit>(builder2context, listen: false);

      await postCubit.createPost(postInfo, widget.selectedFile).then((_) async {
        if (postCubit.postId != '') {
          await userCubit.updateUserPostsInfo(
              userId: personalInfo.userId, postId: postCubit.postId);
          await postCubit.getPostsInfo(
              userId: personalInfo.userId,
              postsIds: personalInfo.posts,
              isThatForMyPosts: true);
          setState(() {
            isItDone = true;
          });
        }
      });

      Navigator.maybePop(context);
    });
  }

  Post addPostInfo(UserPersonalInfo personalInfo) {
    return Post(
      aspectRatio: widget.aspectRatio,
      publisherId: personalInfo.userId,
      datePublished: DateOfNow.dateOfNow(),
      caption: captionController.text,
      comments: [],
      likes: [],
      isThatImage: widget.isThatImage,
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/globall.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/injector.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/widgets/custom_circular_progress.dart';

class CreatePostPage extends StatefulWidget {
  final File selectedFile;
  final bool isThatImage;
  final bool isThatStory;
  const CreatePostPage(
      {Key? key,
      required this.selectedFile,
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
        backgroundColor: ColorManager.white,
        appBar: appBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
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
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManager.writeACaption,
                        hintStyle: TextStyle(color: ColorManager.black26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            buildText(StringsManager.tagPeople),
            const Divider(),
            buildText(StringsManager.addLocation),
            const Divider(),
            buildText(StringsManager.alsoPostTo),
            Row(
              children: [
                Expanded(child: buildText(StringsManager.facebook)),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    // setState(() {
                    isSwitched = value;
                    // });
                  },
                  activeTrackColor: ColorManager.blue,
                  activeColor: ColorManager.white,
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        child: Text(text, style: const TextStyle(fontSize: 16.5)));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: ColorManager.white,
        title: const Text(StringsManager.newPost),
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
                      Icons.check,
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
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      PostCubit postCubit =
          BlocProvider.of<PostCubit>(builder2context, listen: false);

      await postCubit.createPost(postInfo, widget.selectedFile).then((_) async {
        if (postCubit.postId != '') {
          await userCubit.updateUserPostsInfo(
              userId: personalInfo.userId, postId: postCubit.postId);
          await postCubit.getPostsInfo(
              postsIds: personalInfo.posts, isThatForMyPosts: true);
          setState(() {
            isItDone = true;
          });
          // Navigator.maybePop(context);

        }
      });

      Navigator.maybePop(context);
    });
  }

  Post addPostInfo(UserPersonalInfo personalInfo) {
    return Post(
      publisherId: personalInfo.userId,
      datePublished: DateOfNow.dateOfNow(),
      caption: captionController.text,
      comments: [],
      likes: [],
      isThatImage: widget.isThatImage,
    );
  }
}

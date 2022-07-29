import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/blur_hash.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/screens/mobile_screen_layout.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

class CreatePostPage extends StatefulWidget {
  final Uint8List selectedFile;
  final List<Uint8List>? multiSelectedFiles;
  final bool isThatImage;
  final double aspectRatio;

  const CreatePostPage({
    required this.selectedFile,
    required this.aspectRatio,
    this.isThatImage = true,
    this.multiSelectedFiles,
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isSwitched = false;
  final isItDone = ValueNotifier(true);

  TextEditingController captionController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => injector<PostCubit>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: isThatMobile ? appBar(context) : null,
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
                        ? Stack(
                            children: [
                              Image.memory(widget.selectedFile),
                              if (widget.multiSelectedFiles != null)
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.copy_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                )
                            ],
                          )
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
                        hintStyle: TextStyle(
                            color: Theme.of(context).bottomAppBarColor),
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
                    isSwitched = value;
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

        return ValueListenableBuilder(
            valueListenable: isItDone,
            builder: (context, bool isItDoneValue, child) => !isItDoneValue
                ? const CustomCircularProgress(ColorManager.blue)
                : IconButton(
                    onPressed: () async =>
                        createPost(personalInfo!, userCubit, builderContext),
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 30,
                      color: ColorManager.blue,
                    )));
      })
    ];
  }

  Future<void> createPost(UserPersonalInfo personalInfo,
      FirestoreUserInfoCubit userCubit, BuildContext builder2context) async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => isItDone.value = false));
    String blurHash = await blurHashEncode(widget.selectedFile);
    Post postInfo = addPostInfo(personalInfo, blurHash);
    PostCubit postCubit =
        BlocProvider.of<PostCubit>(builder2context, listen: false);
    List<Uint8List>? selectedFiles =
        widget.multiSelectedFiles ?? [widget.selectedFile];
    await postCubit.createPost(postInfo, selectedFiles);
    if (postCubit.postId != '') {
      await userCubit.updateUserPostsInfo(
          userId: personalInfo.userId, postId: postCubit.postId);
      await postCubit.getPostsInfo(
          postsIds: personalInfo.posts, isThatMyPosts: true);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => isItDone.value = true));
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MobileScreenLayout(myPersonalId),
        ),
        (route) => false);
  }

  Post addPostInfo(UserPersonalInfo personalInfo, String blurHash) {
    return Post(
      aspectRatio: widget.aspectRatio,
      publisherId: personalInfo.userId,
      datePublished: DateOfNow.dateOfNow(),
      caption: captionController.text,
      blurHash: blurHash,
      imagesUrls: [],
      comments: [],
      likes: [],
      isThatImage: widget.isThatImage,
    );
  }
}

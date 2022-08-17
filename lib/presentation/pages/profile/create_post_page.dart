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
import 'package:instagram/presentation/widgets/belong_to/register_w/popup_calling.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

class CreatePostPage extends StatefulWidget {
  final List<Uint8List> multiSelectedFiles;
  final bool isThatImage;
  final double aspectRatio;
  final Uint8List? coverOfVideoBytes;
  const CreatePostPage({
    required this.aspectRatio,
    this.isThatImage = true,
    required this.multiSelectedFiles,
    this.coverOfVideoBytes,
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isSwitched = false;
  final isItDone = ValueNotifier(true);

  TextEditingController captionController = TextEditingController(text: "");
  late UserPersonalInfo myPersonalInfo;
  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List image = widget.coverOfVideoBytes != null
        ? widget.coverOfVideoBytes!
        : widget.multiSelectedFiles[0];
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
                      child: Stack(
                        children: [
                          Image.memory(image),
                          if (widget.multiSelectedFiles.length > 1)
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
                            ),
                          if (!widget.isThatImage)
                            const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Icon(
                                  Icons.slow_motion_video_sharp,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      )),
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
      ValueListenableBuilder(
        valueListenable: isItDone,
        builder: (context, bool isItDoneValue, child) => !isItDoneValue
            ? const CustomCircularProgress(ColorManager.blue)
            : IconButton(
                onPressed: () async => createPost(context),
                icon: const Icon(
                  Icons.check_rounded,
                  size: 30,
                  color: ColorManager.blue,
                ),
              ),
      ),
    ];
  }

  Future<void> createPost(BuildContext context) async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => isItDone.value = false));
    String blurHash;
    Post postInfo;
    if (!widget.isThatImage && widget.coverOfVideoBytes != null) {
      blurHash = await blurHashEncode(widget.coverOfVideoBytes!);
      postInfo = addPostInfo(blurHash);
    } else {
      blurHash = await blurHashEncode(widget.multiSelectedFiles[0]);
      postInfo = addPostInfo(blurHash);
    }
    if (!mounted) return;

    PostCubit postCubit = BlocProvider.of<PostCubit>(context, listen: false);
    await postCubit.createPost(postInfo, widget.multiSelectedFiles,
        coverOfVideo: widget.coverOfVideoBytes);

    if (postCubit.postId != '') {
      if (!mounted) return;

      await UserInfoCubit.get(context)
          .updateUserPostsInfo(userId: myPersonalId, postId: postCubit.postId);
      await postCubit.getPostsInfo(
          postsIds: myPersonalInfo.posts, isThatMyPosts: true);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => isItDone.value = true));
    }
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PopupCalling(myPersonalId),
        ),
        (route) => false);
  }

  Post addPostInfo(String blurHash) {
    return Post(
      aspectRatio: widget.aspectRatio,
      publisherId: myPersonalId,
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/widgets/custom_circular_progress.dart';
import 'package:intl/intl.dart';

class CreatePostPage extends StatefulWidget {
 final File selectedImage;

  const CreatePostPage(this.selectedImage, {Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isSwitched = false;
  bool isItDone = true;

  TextEditingController captionController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  child: Image.file(widget.selectedImage),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: captionController,
                    cursorColor: Colors.teal,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a caption...",
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          buildText("Tag People"),
          const Divider(),
          buildText("Add location"),
          const Divider(),
          buildText("Also post to"),
          Row(
            children: [
              Expanded(child: buildText("Facebook")),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  // setState(() {
                  isSwitched = value;
                  // });
                },
                activeTrackColor: Colors.blue,
                activeColor: Colors.white,
              ),
            ],
          ),
        ],
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
        backgroundColor: Colors.white,
        title: const Text("New Post"),
        actions: actionsWidgets(context));
  }

  List<Widget> actionsWidgets(BuildContext context) {
    return [
      Builder(builder: (builderContext) {
        FirestoreUserInfoCubit userCubit =
            BlocProvider.of<FirestoreUserInfoCubit>(builderContext,
                listen: false);
        UserPersonalInfo? personalInfo = userCubit.personalInfo;

        return Builder(
          builder: (builder2context) {
            return !isItDone
                ? const CustomCircularProgress(Colors.blue)
                : IconButton(
                    onPressed: () =>
                        createPost(personalInfo!, userCubit, builder2context),
                    icon: const Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.blue,
                    ));
          },
        );
      })
    ];
  }

  createPost(UserPersonalInfo personalInfo, FirestoreUserInfoCubit userCubit,
      BuildContext builder2context) {
    Post postInfo = addPostInfo(personalInfo);
    Comment captionInfo = addCommentInfo(personalInfo);
    setState(() {
      isItDone = false;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      PostCubit postCubit =
          BlocProvider.of<PostCubit>(builder2context, listen: false);

      String? postId = await postCubit.createPost(
          postInfo, captionInfo, widget.selectedImage);

      if (postId != null) {
        personalInfo.posts += [postId];
        await userCubit.updateUserInfo(personalInfo);
        await postCubit.getPostInfo(personalInfo.posts);
        setState(() {
          isItDone = true;
        });
      }
      Navigator.pop(context);
    });
  }

  Post addPostInfo(UserPersonalInfo personalInfo) {
    return Post(
        publisherId: personalInfo.userId,
        datePublished: timeOfNow(),
        publisherName: personalInfo.name,
        caption: captionController.text,
        publisherProfileImageUrl: personalInfo.profileImageUrl,
        likes: [],);
  }

  Comment addCommentInfo(UserPersonalInfo personalInfo) {
    return Comment(
        datePublished: timeOfNow(),
        name: personalInfo.name,
        profileImageUrl: personalInfo.profileImageUrl,
        theComment: captionController.text,
        commentatorId: personalInfo.userId);
  }

  String timeOfNow() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(now);
  }
}

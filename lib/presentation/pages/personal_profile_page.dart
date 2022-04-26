import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/presentation/pages/new_post_page.dart';
import 'package:instegram/presentation/pages/story_config.dart';
import 'package:instegram/presentation/widgets/profile_page.dart';
import 'package:instegram/presentation/widgets/recommendation_people.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/toast_show.dart';
import 'edit_profile_page.dart';
import 'dart:io';

import 'login_page.dart';

class PersonalProfilePage extends StatefulWidget {
  final String personalId;
  final String userName;

  const PersonalProfilePage(
      {Key? key, required this.personalId, this.userName = ''})
      : super(key: key);

  @override
  State<PersonalProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<PersonalProfilePage> {
  bool rebuildUserInfo = false;
  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Widget scaffold() {
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
      bloc: widget.userName.isNotEmpty
          ? (BlocProvider.of<FirestoreUserInfoCubit>(context)
            ..getUserFromUserName(widget.userName))
          : (BlocProvider.of<FirestoreUserInfoCubit>(context)
            ..getUserInfo(widget.personalId, true)),
      buildWhen: (previous, current) {
        if (previous != current && current is CubitMyPersonalInfoLoaded) {
          return true;
        }
        if (previous != current && current is CubitGetUserInfoFailed) {
          return true;
        }
        if (rebuildUserInfo) {
          rebuildUserInfo = false;
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CubitMyPersonalInfoLoaded) {
          return Scaffold(
            appBar: appBar(state.userPersonalInfo.userName),
            body: ProfilePage(
              isThatMyPersonalId: true,
              userId: state.userPersonalInfo.userId,
              userInfo: state.userPersonalInfo,
              widgetsAboveTapBars: widgetsAboveTapBars(state.userPersonalInfo),
            ),
          );
        } else if (state is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(state);
          return const Text("there is no posts...");
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 1, color: ColorManager.black54),
          );
        }
      },
    );
  }

  AppBar appBar(String userName) {
    return AppBar(
        elevation: 0,
        backgroundColor: ColorManager.white,
        title: Text(userName),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.addIcon,
              color: ColorManager.black,
              height: 22.5,
            ),
            onPressed: () => bottomSheetOfAdd(),
          ),
          exitButton(),
          const SizedBox(width: 5)
        ]);
  }

  Widget exitButton() {
    return BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState>(
        builder: (context, state) {
      FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
      if (state is CubitAuthSignOut) {
        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false);
        });
      } else if (state is CubitAuthConfirming) {
        ToastShow.toast("Loading...");
      } else if (state is CubitAuthFailed) {
        ToastShow.toastStateError(state);
      }
      return IconButton(
        icon: SvgPicture.asset(
          IconsAssets.menuIcon,
          color: ColorManager.black,
          height: 30,
        ),
        onPressed: () async {
          authCubit.signOut();
        },
      );
    });
  }

  List<Widget> widgetsAboveTapBars(UserPersonalInfo userInfo) {
    return [
      editProfile(userInfo),
      const SizedBox(width: 5),
      const RecommendationPeople(),
      const SizedBox(width: 10),
    ];
  }

  Expanded editProfile(UserPersonalInfo userInfo) {
    return Expanded(
      child: Builder(builder: (buildContext) {
        return InkWell(
          onTap: () async {
            Future.delayed(Duration.zero, () async {
              UserPersonalInfo result =
                  await Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage(userInfo),
                          maintainState: false));
              setState(() {
                rebuildUserInfo = true;

                userInfo = result;
              });
            });
          },
          child: Container(
            height: 35.0,
            decoration: BoxDecoration(
              color: ColorManager.white,
              border: Border.all(color: ColorManager.black26, width: 1.0),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: const Center(
              child: Text(
                'Edit profile',
                style: TextStyle(
                    fontSize: 17.0,
                    color: ColorManager.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> bottomSheetOfAdd() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: listOfAddPost(),
        );
      },
    );
  }

  Widget listOfAddPost() {
    return SingleChildScrollView(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            IconsAssets.minusIcon,
            color: ColorManager.black87,
            height: 40,
          ),
          const Text("Create",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              children: [
                createNewPost(),
                const Divider(indent: 40, endIndent: 15),
                createNewVideo(),
                const Divider(indent: 40, endIndent: 15),
                createStoryButton(),
                const Divider(indent: 40, endIndent: 15),
                createSizedBox("Live", IconsAssets.instagramHighlightStoryIcon),
                const Divider(indent: 40, endIndent: 15),
                Container(
                  height: 50,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector createStoryButton() {
    return GestureDetector(
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? image =
              await _picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            File photo = File(image.path);
            await Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) => NewStoryPage(storyImage: photo),
                    maintainState: false));
            setState(() {
              rebuildUserInfo = true;
            });
          }
        },
        child: createSizedBox("Story", IconsAssets.addInstagramStoryIcon));
  }

  GestureDetector createNewVideo() {
    return GestureDetector(
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? video =
              await _picker.pickVideo(source: ImageSource.camera);
          if (video != null) {
            File videoFile = File(video.path);
            await Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) => CreatePostPage(
                        selectedFile: videoFile, isThatImage: false),
                    maintainState: false));
            setState(() {
              rebuildUserInfo = true;
            });
          }
        },
        child: createSizedBox("Reel", IconsAssets.videoIcon));
  }

  GestureDetector createNewPost() {
    return GestureDetector(
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            File photo = File(image.path);
            await Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) => CreatePostPage(selectedFile: photo),
                    maintainState: false));
            setState(() {
              rebuildUserInfo = true;
            });
          }
        },
        child: createSizedBox("Post", IconsAssets.gridIcon));
  }

  SizedBox createSizedBox(String text, String nameOfPath) {
    return SizedBox(
      height: 40,
      child: Row(children: [
        text != "Post"
            ? SvgPicture.asset(
                nameOfPath,
                color: ColorManager.black87,
                height: 25,
              )
            : const Icon(Icons.grid_on_sharp),
        const SizedBox(width: 15),
        Text(
          text,
          style: const TextStyle(fontSize: 15),
        )
      ]),
    );
  }
}

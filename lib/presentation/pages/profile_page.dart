import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/circle_avatar_of_profile_image.dart';
import '../widgets/read_more_text.dart';
import '../widgets/toast_show.dart';
import 'edit_profile_page.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage(this.userId, {Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Widget scaffold() {
    return Builder(builder: (context) {
      UserPersonalInfo? personalInfo =
          BlocProvider.of<FirestoreUserInfoCubit>(context).personalInfo;

      return Scaffold(
        appBar: appBar(personalInfo!.userName),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                      listOfWidgetsAboveTapBars(personalInfo)),
                ),
              ];
            },
            body: tapBar(),
          ),
        ),
      );
    });
  }

  AppBar appBar(String userInfo) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(userInfo),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/add.svg",
              color: Colors.black,
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
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        });
      } else if (state is CubitAuthConfirming) {
        ToastShow.toast("Loading...");
      } else if (state is CubitAuthFailed) {
        ToastShow.toastStateError(state);
      }
      return IconButton(
        icon: SvgPicture.asset(
          "assets/icons/menu.svg",
          color: Colors.black,
          height: 30,
        ),
        onPressed: () async {
          authCubit.signOut();
        },
      );
    });
  }

  Widget tapBar() {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {

        List<Post>? postsInfo;
        if (state is CubitPostsInfoLoaded) {
          postsInfo = state.postsInfo;
          // WidgetsBinding.instance!.addPostFrameCallback((_) async {
          //   setState(() {
              isDone = true;
          //   });
          // });
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
        }

        return isDone
            ? Column(
                children: [
                  tabBarIcons(),
                  tapBarView(postsInfo ?? []),
                ],
              )
            : Transform.scale(
                scale: 0.1,
                child: const CircularProgressIndicator(
                    strokeWidth: 20, color: Colors.black54));
      },
    );
  }

  Expanded tapBarView(List<Post> postsInfo) {
    return Expanded(
      child: TabBarView(
        children: [
          normalVideoView(postsInfo),
          verticalVideosView(),
          normalVideoView(postsInfo),
        ],
      ),
    );
  }

  Widget normalVideoView(List<Post> postsInfo) {
    return GridView.count(
        padding: const EdgeInsets.symmetric(vertical: 1.5),
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
        crossAxisCount: 3,
        children: postsInfo.map((postsInfo) {
          return SizedBox(
              child: InkWell(
                  onLongPress: () {
                    showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: '',
                      barrierColor: Colors.black38,
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (ctx, anim1, anim2) => AlertDialog(
                        title: const Text('blured background'),
                        content: const Text(
                            'background should be blured and little bit darker '),
                        elevation: 2,
                        actions: [
                          FlatButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      transitionBuilder: (ctx, anim1, anim2, child) =>
                          BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                        child: FadeTransition(
                          child: child,
                          opacity: anim1,
                        ),
                      ),
                      context: context,
                    );
                    // showDialog(
                    //     context: context,
                    //     builder: (_) => AlertDialog(
                    //       backgroundColor:
                    //       const Color.fromRGBO(255, 255, 255, 0.0),
                    //       elevation: 0,
                    //       content: Builder(
                    //         builder: (context) {
                    //           double height =
                    //               MediaQuery.of(context).size.height;
                    //           double width =
                    //               MediaQuery.of(context).size.width;
                    //           double size =
                    //               (height >= width ? width : height) / 2;
                    //           return SizedBox(
                    //             height: 200,
                    //             width: double.maxFinite,
                    //             child: ClipRRect(
                    //               // make sure we apply clip it properly
                    //               child: BackdropFilter(
                    //                 filter: ImageFilter.blur(
                    //                     sigmaX: 10, sigmaY: 10),
                    //                 child: Container(
                    //                   alignment: Alignment.center,
                    //                   color: Colors.grey.withOpacity(0.5),
                    //                   height: size,
                    //                   width: size,
                    //                   child: Image.network(
                    //                       postsInfo.postImageUrl,
                    //                       fit: BoxFit.fill),
                    //                 ),
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ));
                  },
                  child: Image.network(
                    postsInfo.postImageUrl,
                    fit: BoxFit.cover,
                  )),
              height: 150.0);
        }).toList());
  }

  GridView verticalVideosView() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisExtent: 215,
      ),
      padding: EdgeInsets.zero,
      children: Colors.primaries.map((color) {
        return Container(color: color, height: 150.0);
      }).toList(),
    );
  }

  TabBar tabBarIcons() {
    return TabBar(
      tabs: [
        const Tab(icon: Icon(Icons.grid_on_sharp)),
        Tab(
            icon: SvgPicture.asset(
          "assets/icons/video.svg",
          color: Colors.black,
          height: 22.5,
        )),
        const Tab(
            icon: Icon(
          Icons.play_arrow_outlined,
          size: 38,
        )),
      ],
    );
  }

  List<Widget> listOfWidgetsAboveTapBars(UserPersonalInfo userInfo) {
    return [
      personalPhotoAndNumberInfo(userInfo),
      Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userInfo.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            ReadMore(userInfo.bio, 4),
            Row(
              children: [
                editProfile(userInfo),
                const SizedBox(width: 5),
                recommendationPeople(),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  InkWell recommendationPeople() {
    return InkWell(
      onTap: () {},
      child: Container(
        //width: 100.0,
        height: 35.0,
        width: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 1.0),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: const Center(
          child: Icon(Icons.person_add_outlined),
        ),
      ),
    );
  }

  Expanded editProfile(UserPersonalInfo userInfo) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          Future.delayed(Duration.zero, () async {
            // Navigator.pushNamed(context, '/edit_profile',arguments: userInfo);
            UserPersonalInfo result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfilePage(userInfo)));
            setState(() {
              userInfo = result;
            });
          });
        },
        child: Container(
          height: 35.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black26, width: 1.0),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Center(
            child: Text(
              'Edit profile',
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Row personalPhotoAndNumberInfo(UserPersonalInfo userInfo) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CircleAvatarOfProfileImage(
          circleAvatarName: '',
          bodyHeight: 900,
          thisForStoriesLine: false,
          imageUrl: userInfo.profileImageUrl),
      personalNumbersInfo(userInfo.posts.length, "Posts"),
      personalNumbersInfo(userInfo.followerPeople.length, "Followers"),
      personalNumbersInfo(userInfo.followedPeople.length, "Following"),
    ]);
  }

  Expanded personalNumbersInfo(int number, String text) {
    return Expanded(
      child: Column(
        children: [
          Text("$number",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          Text(text, style: const TextStyle(fontSize: 15))
        ],
      ),
    );
  }

  Future<void> bottomSheetOfAdd() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: listOfAddPost(),
        );
      },
    );
  }

  Column listOfAddPost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SvgPicture.asset(
          "assets/icons/minus.svg",
          color: Colors.black87,
          height: 40,
        ),
        const Text("Create",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            children: [
              InkWell(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      File photo = File(image.path);
                      Navigator.pushNamed(context, '/create_post',
                          arguments: photo);
                    }
                    // // Capture a photo
                    // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                    // // // Pick a video
                    // final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
                    // // Capture a video
                    // final XFile? videoInCamera = await _picker.pickVideo(source: ImageSource.camera);
                    // // // Pick multiple images
                    // final List<XFile>? images = await _picker.pickMultiImage();
                  },
                  child: createSizedBox("Post", "grid")),
              const Divider(indent: 40, endIndent: 15),
              createSizedBox("Reel", "video"),
              const Divider(indent: 40, endIndent: 15),
              createSizedBox("Story", "add-instagram-story"),
              const Divider(indent: 40, endIndent: 15),
              createSizedBox("Live", "instagram-highlight-story"),
              const Divider(indent: 40, endIndent: 15),
              Container(
                height: 50,
              )
            ],
          ),
        ),
      ],
    );
  }

  SizedBox createSizedBox(String text, String nameOfPath) {
    return SizedBox(
      height: 40,
      child: Row(children: [
        text != "Post"
            ? SvgPicture.asset(
                "assets/icons/$nameOfPath.svg",
                color: Colors.black87,
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

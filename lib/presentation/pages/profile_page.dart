import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/pages/new_post_page.dart';
import 'package:instegram/presentation/widgets/animated_dialog.dart';
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

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  bool rebuild = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            body: tapBar(personalInfo),
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

  getPostsData(UserPersonalInfo personalInfo) async {
    PostCubit postCubit = PostCubit.get(context);
    await postCubit.getPostInfo(personalInfo.posts);
  }

  Widget tapBar(UserPersonalInfo personalInfo) {
    if (rebuild) {
      getPostsData(personalInfo);
      rebuild = false;
    }

    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is CubitPostsInfoLoaded) {
          return Column(
            children: [
              tabBarIcons(),
              tapBarView(state.postsInfo),
            ],
          );
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return const Text("there is no posts...");
        } else {
          return Transform.scale(
              scale: 0.1,
              child: const CircularProgressIndicator(
                  strokeWidth: 20, color: Colors.black54));
        }
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
    return postsInfo.isNotEmpty
        ? GridView.count(
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            crossAxisSpacing: 1.5,
            mainAxisSpacing: 1.5,
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            children: postsInfo.map((postInfo) {
              return createGridTileWidget(postInfo);
            }).toList())
        : const Center(child: Text("There's no posts..."));
  }

  OverlayEntry? _popupDialog;

  Widget createGridTileWidget(Post postInfo) => Builder(
        builder: (context) => GestureDetector(
          onLongPress: () {
            _popupDialog = _createPopupDialog(postInfo);
            Overlay.of(context)!.insert(_popupDialog!);
          },
          onLongPressEnd: (details) => _popupDialog?.remove(),
          child: Image.network(postInfo.postImageUrl, fit: BoxFit.cover),
        ),
      );
  OverlayEntry _createPopupDialog(Post postInfo) {
    return OverlayEntry(
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 20),
        child: AnimatedDialog(
          child: _createPopupContent(postInfo),
        ),
      ),
    );
  }

  Widget _createPopupContent(Post postInfo) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(postInfo),
              Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Image.network(postInfo.postImageUrl,
                      fit: BoxFit.fitWidth)),
              _createActionBar(),
            ],
          ),
        ),
      );
  Widget _createPhotoTitle(Post postInfo) => Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        height: 55,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatarOfProfileImage(
              imageUrl: postInfo.publisherInfo!.profileImageUrl,
              thisForStoriesLine: false,
              bodyHeight: 370,
              circleAvatarName: '',
            ),
            const SizedBox(width: 7),
            Text(postInfo.publisherInfo!.name,
                style: const TextStyle(
                  color: Colors.black,
                )),
          ],
        ),
      );

  Widget _createActionBar() => Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            Icon(
              Icons.chat_bubble_outline,
              color: Colors.black,
            ),
            Icon(
              Icons.send,
              color: Colors.black,
            ),
          ],
        ),
      );
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
            UserPersonalInfo result =
                await Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => EditProfilePage(userInfo),
                        maintainState: false));
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
                      await Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => CreatePostPage(photo),
                              maintainState: false));
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

  @override
  bool get wantKeepAlive => true;
}

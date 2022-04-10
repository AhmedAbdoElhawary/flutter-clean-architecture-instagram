import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/presentation/pages/new_post_page.dart';
import 'package:instegram/presentation/widgets/profile_page.dart';
import 'package:instegram/presentation/widgets/recommendation_people.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/toast_show.dart';
import 'edit_profile_page.dart';
import 'dart:io';

class PersonalProfilePage extends StatefulWidget {
  final String personalId;
  const PersonalProfilePage(this.personalId, {Key? key}) : super(key: key);

  @override
  State<PersonalProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<PersonalProfilePage>
    with AutomaticKeepAliveClientMixin {
  // UserPersonalInfo? personalInfo;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // getPersonalData();
    return scaffold();
  }

  Widget scaffold() {
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
      bloc: BlocProvider.of<FirestoreUserInfoCubit>(context)..getUserInfo(widget.personalId, true),
      buildWhen: (context, state) => state is CubitMyPersonalInfoLoaded,
      builder: (context, state) {
        if (state is CubitMyPersonalInfoLoaded) {
          return Scaffold(
            appBar: appBar(state.userPersonalInfo.userName),
            body: ProfilePage(
              isThatMyPersonalId: true,
              userId: widget.personalId,
              userInfo:state.userPersonalInfo,
              widgetsAboveTapBars: widgetsAboveTapBars(state.userPersonalInfo),
            ),
          );
        } else if (state is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(state);
          return const Text("there is no posts...");
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth:1, color: Colors.black54),
          );
        }
      },
    );
  }

  AppBar appBar(String userName) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(userName),
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

  List<Widget> widgetsAboveTapBars(UserPersonalInfo userInfo) {
    print("widgetsAboveTapBars =============================== ");

    return [
      editProfile(userInfo),
      const SizedBox(width: 5),
      const RecommendationPeople(),
      const SizedBox(width: 10),
    ];
  }

  Expanded editProfile(UserPersonalInfo userInfo) {
    return Expanded(
      child: Builder(
        builder: (buildContext) {
          return InkWell(
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
          );
        }
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
  bool get wantKeepAlive => false;
}

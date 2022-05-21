import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/app_prefs.dart';
import 'package:instagram/core/functions/image_picker.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/pages/profile/create_post_page.dart';
import 'package:instagram/presentation/pages/story/create_story.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/bottom_sheet.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/recommendation_people.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/user_personal_info.dart';
import '../../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../../../core/functions/toast_show.dart';
import 'edit_profile_page.dart';
import 'dart:io';
import '../register/login_page.dart';

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
  Size imageSize = const Size(0.00, 0.00);
  List<Size> imagesSize = [];

  final SharedPreferences sharePrefs = injector<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Future<void> getData() async {
    widget.userName.isNotEmpty
        ? (await BlocProvider.of<FirestoreUserInfoCubit>(context)
            .getUserFromUserName(widget.userName))
        : (await BlocProvider.of<FirestoreUserInfoCubit>(context)
            .getUserInfo(widget.personalId));
    setState(() {
      rebuildUserInfo = true;
    });
  }

  Widget scaffold() {
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
      bloc: widget.userName.isNotEmpty
          ? (BlocProvider.of<FirestoreUserInfoCubit>(context)
            ..getUserFromUserName(widget.userName))
          : (BlocProvider.of<FirestoreUserInfoCubit>(context)
            ..getUserInfo(widget.personalId)),
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
              getData: getData,
              userId: state.userPersonalInfo.userId,
              userInfo: state.userPersonalInfo,
              widgetsAboveTapBars: widgetsAboveTapBars(state.userPersonalInfo),
            ),
          );
        } else if (state is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(state);
          return Text(StringsManager.noPosts.tr(),
              style: Theme.of(context).textTheme.bodyText1);
        } else {
          return const ThineCircularProgress();
        }
      },
    );
  }

  AppBar appBar(String userName) {
    return AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(userName,
            style: getMediumStyle(
                color: Theme.of(context).focusColor, fontSize: 20)),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.addIcon,
              color: Theme.of(context).focusColor,
              height: 22.5,
            ),
            onPressed: () => bottomSheet(),
          ),
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.menuIcon,
              color: Theme.of(context).focusColor,
              height: 30,
            ),
            onPressed: () async => bottomSheet(createNewData: false),
          ),
          const SizedBox(width: 5)
        ]);
  }

  Future<void> bottomSheet({bool createNewData = true}) {
    return CustomBottomSheet.bottomSheet(
      context,
      headIcon: Text(StringsManager.create.tr(),
          style:
              getBoldStyle(color: Theme.of(context).focusColor, fontSize: 17)),
      bodyText: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0),
        child: createNewData ? columnOfCreateData() : columnOfThemeData(),
      ),
    );
  }

  Column columnOfCreateData() {
    return Column(
      children: [
        createPost(),
        customDivider(),
        createVideo(),
        customDivider(),
        createStory(),
        customDivider(),
        createNewLive(),
        customDivider(),
        Container(
          height: 50,
        )
      ],
    );
  }

  Divider customDivider() =>
      const Divider(indent: 40, endIndent: 15, color: ColorManager.grey);

  Column columnOfThemeData() {
    return Column(
      children: [
        changeLanguage(),
        customDivider(),
        changeMode(),
        customDivider(),
        logOut(),
        customDivider(),
        Container(
          height: 50,
        )
      ],
    );
  }

  GestureDetector changeLanguage() {
    final AppPreferences _appPreferences = injector<AppPreferences>();

    return GestureDetector(
      onTap: () {
        _appPreferences.changeAppLanguage();
        Phoenix.rebirth(context);
      },
      child: createSizedBox(StringsManager.changeLanguage.tr(),
          icon: Icons.language_rounded),
    );
  }

  GestureDetector changeMode() {
    final AppPrefMode _appPreferencesMode = injector<AppPrefMode>();

    return GestureDetector(
      onTap: () {
        _appPreferencesMode.changeAppMode();
        Phoenix.rebirth(context);
      },
      child: createSizedBox(StringsManager.changeMode.tr(),
          icon: Icons.brightness_4_outlined),
    );
  }

  Widget logOut() {
    return BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState>(
        builder: (context, state) {
      FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
      if (state is CubitAuthSignOut) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          sharePrefs.clear();
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (_) => LoginPage(sharePrefs: sharePrefs),
                maintainState: false),
            (route) => false,
          );
        });
      } else if (state is CubitAuthConfirming) {
        ToastShow.toast(StringsManager.loading.tr());
      } else if (state is CubitAuthFailed) {
        ToastShow.toastStateError(state);
      }
      return GestureDetector(
        child: createSizedBox(StringsManager.logOut.tr(),
            icon: Icons.logout_rounded),
        onTap: () async {
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
            Navigator.maybePop(context);
            Future.delayed(Duration.zero, () async {
              UserPersonalInfo result =
                  await Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
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
              color: Theme.of(context).primaryColor,
              border:
                  Border.all(color: Theme.of(context).cardColor, width: 1.0),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Center(
              child: Text(
                StringsManager.editProfile.tr(),
                style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).focusColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      }),
    );
  }

  GestureDetector createNewLive() {
    return GestureDetector(
      onTap: () {},
      child: createSizedBox(StringsManager.live.tr(),
          nameOfPath: IconsAssets.instagramHighlightStoryIcon),
    );
  }

  GestureDetector createStory() {
    return GestureDetector(
        onTap: () async => showDialog(createNewStory),
        child: createSizedBox(StringsManager.story.tr(),
            nameOfPath: IconsAssets.addInstagramStoryIcon));
  }

  GestureDetector createVideo() {
    return GestureDetector(
        onTap: () async => showDialog(createNewVideo),
        child: createSizedBox(StringsManager.reel.tr(),
            nameOfPath: IconsAssets.videoIcon));
  }

  showDialog(ValueChanged<bool> method) async {
    showAnimatedDialog(
        context: context,
        curve: Curves.easeIn,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              scrollable: true,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 5,
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        method(true);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {});
                        });
                      },
                      child: Text(StringsManager.fromCamera.tr(),
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        Navigator.maybePop(context);
                        method(false);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {});
                        });
                      },
                      child: Text(StringsManager.fromGallery.tr(),
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ]),
            ));
  }

  createNewStory(bool isThatFromCamera) async {
    Navigator.maybePop(context);
    File? pickImage = isThatFromCamera
        ? await imageCameraPicker()
        : await imageGalleryPicker();
    if (pickImage != null) {
      _getImageDimension(pickImage);
      await Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => CreateStoryPage(storyImage: pickImage),
          maintainState: false));
      setState(() {
        rebuildUserInfo = true;
      });
    }
  }

  createNewVideo(bool isThatFromCamera) async {
    Navigator.maybePop(context);
    File? pickVideo = isThatFromCamera
        ? await videoCameraPicker()
        : await videoGalleryPicker();
    if (pickVideo != null) {
      _getImageDimension(pickVideo);
      await Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => CreatePostPage(
              selectedFile: pickVideo,
              isThatImage: false,
              aspectRatio: imageSize.aspectRatio),
          maintainState: false));
      setState(() {
        rebuildUserInfo = true;
      });
    }
  }

  Future<void> _getImageDimension(File photo) async {
    Image image = Image.file(photo);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          setState(() {
            imageSize =
                Size(myImage.width.toDouble(), myImage.height.toDouble());
          });
        },
      ),
    );
  }

  // TODO ---- handling this function and dimension of image ----
  createNewPost(bool isThatFromCamera) async {
    Navigator.maybePop(context);
    List<File>? pickImages;
    if (isThatFromCamera) {
      File? file = await imageCameraPicker();
      if (file != null) pickImages = [file];
    } else {
      pickImages = await multiImageGalleryPicker();
    }
    if (pickImages != null) {
      await _getImageDimension(pickImages[0]);
      await Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) {
            return CreatePostPage(
                selectedFile: pickImages![0],
                multiSelectedFiles: pickImages,
                aspectRatio: imageSize.aspectRatio);
          },
          maintainState: false));
      setState(() {
        rebuildUserInfo = true;
      });
    }
  }

  GestureDetector createPost() {
    return GestureDetector(
        onTap: () => showDialog(createNewPost),
        child: createSizedBox(StringsManager.post.tr()));
  }

  SizedBox createSizedBox(String text,
      {String nameOfPath = '', IconData icon = Icons.grid_on_rounded}) {
    return SizedBox(
      height: 40,
      child: Row(children: [
        nameOfPath.isNotEmpty
            ? SvgPicture.asset(
                nameOfPath,
                color: Theme.of(context).dialogBackgroundColor,
                height: 25,
              )
            : Icon(icon, color: Theme.of(context).focusColor),
        const SizedBox(width: 15),
        Text(
          text,
          style:
              getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
        )
      ]),
    );
  }
}

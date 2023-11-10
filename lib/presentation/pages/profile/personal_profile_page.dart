import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/config/themes/theme_service.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/translations/app_lang.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:instagram/presentation/pages/profile/widgets/bottom_sheet.dart';
import 'package:instagram/presentation/pages/profile/widgets/profile_page.dart';
import 'package:instagram/presentation/pages/profile/widgets/recommendation_people.dart';
import 'package:instagram/presentation/pages/story/create_story.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/functions/toast_show.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../register/login_page.dart';
import 'edit_profile_page.dart';

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
  final SharedPreferences sharePrefs = injector<SharedPreferences>();
  final rebuildUserInfo = ValueNotifier(false);
  Size imageSize = const Size(0.00, 0.00);
  final darkTheme = ValueNotifier(false);
  List<Size> imagesSize = [];

  @override
  void initState() {
    darkTheme.value = ThemeOfApp.isThemeDark();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Widget scaffold() {
    return WillPopScope(
      onWillPop: () async => true,
      child: ValueListenableBuilder(
        valueListenable: rebuildUserInfo,
        builder: (context, bool rebuildValue, child) =>
            BlocBuilder<UserInfoCubit, UserInfoState>(
              bloc: widget.userName.isNotEmpty
                  ? (BlocProvider.of<UserInfoCubit>(context)
                ..getUserFromUserName(widget.userName))
                  : (BlocProvider.of<UserInfoCubit>(context)
                ..getUserInfo(widget.personalId, getDeviceToken: true)),
              buildWhen: (previous, current) {
                if (previous != current && current is CubitMyPersonalInfoLoaded) {
                  return true;
                }
                if (previous != current && current is CubitGetUserInfoFailed) {
                  return true;
                }
                if (rebuildValue) {
                  rebuildUserInfo.value = false;
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is CubitMyPersonalInfoLoaded) {
                  return Scaffold(
                    appBar: isThatMobile
                        ? appBar(state.userPersonalInfo.userName)
                        : null,
                    body: ProfilePage(
                      isThatMyPersonalId: true,
                      userId: state.userPersonalInfo.userId,
                      userInfo: ValueNotifier(state.userPersonalInfo),
                      widgetsAboveTapBars: isThatMobile
                          ? widgetsAboveTapBarsForMobile(state.userPersonalInfo)
                          : widgetsAboveTapBarsForWeb(state.userPersonalInfo),
                    ),
                  );
                } else if (state is CubitGetUserInfoFailed) {
                  ToastShow.toastStateError(state);
                  return Text(StringsManager.noPosts.tr,
                      style: Theme.of(context).textTheme.bodyLarge);
                } else {
                  return const ThineCircularProgress();
                }
              },
            ),
      ),
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
              colorFilter: ColorFilter.mode(
                  Theme.of(context).focusColor, BlendMode.srcIn),
              height: 22.5,
            ),
            onPressed: () => bottomSheet(),
          ),
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.menuIcon,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).focusColor, BlendMode.srcIn),
              height: 30,
            ),
            onPressed: () async => bottomSheet(createNewData: false),
          ),
          const SizedBox(width: 5)
        ]);
  }

  Future<void> bottomSheet({bool createNewData = true}) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => CustomBottomSheet(
        bodyText: bodyTextOfBottomSheet(createNewData),
        headIcon: bottomSheetHeadIcon(),
      ),
    );
  }

  ValueListenableBuilder<bool> bottomSheetHeadIcon() {
    return ValueListenableBuilder(
        valueListenable: darkTheme,
        builder: (context, bool themeValue, child) {
          Color themeOfApp =
          themeValue ? ColorManager.white : ColorManager.black;
          return Text(StringsManager.create.tr,
              style: getBoldStyle(color: themeOfApp, fontSize: 17));
        });
  }

  Padding bodyTextOfBottomSheet(bool createNewData) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: createNewData ? columnOfCreateData() : columnOfThemeData(),
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

  Widget changeLanguage() {
    return GestureDetector(
      onTap: () {
        AppLanguage.getInstance().changeLanguage();
        Phoenix.rebirth(context);
      },
      child: createSizedBox(StringsManager.changeLanguage.tr,
          icon: Icons.language_rounded),
    );
  }

  GestureDetector changeMode() {
    return GestureDetector(
      onTap: () async {
        await ThemeOfApp.switchTheme();
        darkTheme.value = ThemeOfApp.isThemeDark();
      },
      child: createSizedBox(StringsManager.changeTheme.tr,
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
                    builder: (_) => const LoginPage(), maintainState: false),
                    (route) => false,
              );
            });
          } else if (state is CubitAuthConfirming) {
            ToastShow.toast(StringsManager.loading.tr);
          } else if (state is CubitAuthFailed) {
            ToastShow.toastStateError(state);
          }
          return GestureDetector(
            child: createSizedBox(StringsManager.logOut.tr,
                icon: Icons.logout_rounded),
            onTap: () async {
              await authCubit.signOut(userId: widget.personalId);
            },
          );
        });
  }

  List<Widget> widgetsAboveTapBarsForMobile(UserPersonalInfo userInfo) {
    return [
      editProfileButtonForMobile(userInfo),
      const SizedBox(width: 5),
      const RecommendationPeople(),
      const SizedBox(width: 10),
    ];
  }

  Expanded editProfileButtonForMobile(UserPersonalInfo userInfo) {
    return Expanded(
      child: Builder(builder: (buildContext) {
        UserPersonalInfo myPersonalInfo =
        UserInfoCubit.getMyPersonalInfo(context);
        UserPersonalInfo? info =
        UsersInfoReelTimeBloc.getMyInfoInReelTime(context);
        if (isMyInfoInReelTimeReady && info != null) myPersonalInfo = info;
        return InkWell(
          onTap: () async {
            Navigator.maybePop(context);
            Future.delayed(Duration.zero, () async {
              await Go(context).push(page: EditProfilePage(userInfo));
              rebuildUserInfo.value = true;
              userInfo = myPersonalInfo;
            });
          },
          child: Container(
            height: 35.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                  color: Theme.of(context).bottomAppBarTheme.color!,
                  width: 1.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Text(
                StringsManager.editProfile.tr,
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

  List<Widget> widgetsAboveTapBarsForWeb(UserPersonalInfo userInfo) {
    return [
      const SizedBox(width: 20),
      editProfileButtonForWeb(),
      const SizedBox(width: 10),
      GestureDetector(
        child: const Icon(Icons.settings_rounded, color: ColorManager.black),
      ),
    ];
  }

  Widget editProfileButtonForWeb() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: ColorManager.transparent,
          border: Border.all(
            color: ColorManager.lowOpacityGrey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          StringsManager.editProfile.tr,
          style: getMediumStyle(color: ColorManager.black),
        ),
      ),
    );
  }

  Widget createNewLive() {
    return InkWell(
      onTap: () {},
      child: createSizedBox(StringsManager.live.tr,
          nameOfPath: IconsAssets.instagramHighlightStoryIcon),
    );
  }

  Widget createStory() {
    return InkWell(
        onTap: () async => createNewStory(true),
        child: createSizedBox(StringsManager.story.tr,
            nameOfPath: IconsAssets.addInstagramStoryIcon));
  }

  /// TODO: handle the video selection (aspect ratio especially)
  Widget createVideo() {
    return InkWell(
        onTap: () async {
          Navigator.maybePop(context);

          await CustomImagePickerPlus.pickVideo(context);

          rebuildUserInfo.value = true;
        },
        child: createSizedBox(StringsManager.reel.tr,
            nameOfPath: IconsAssets.videoIcon));
  }

  createNewStory(bool isThatStory) async {
    Navigator.maybePop(context);

    SelectedImagesDetails? details = await CustomImagePickerPlus.pickImage(
      context,
      isThatStory: true,
    );
    if (!mounted ) return;
    if (details == null) return;
    await Go(context).push(page: CreateStoryPage(storiesDetails: details));
    rebuildUserInfo.value = true;
  }

  createNewPost() async {
    Navigator.maybePop(context);

    await CustomImagePickerPlus.pickFromBoth(context);

    rebuildUserInfo.value = true;
  }

  Widget createPost() {
    return InkWell(
        onTap: createNewPost, child: createSizedBox(StringsManager.post.tr));
  }

  Widget createSizedBox(String text,
      {String nameOfPath = '', IconData icon = Icons.grid_on_rounded}) {
    return SizedBox(
      height: 40,
      child: ValueListenableBuilder(
        valueListenable: darkTheme,
        builder: (context, bool themeValue, child) {
          Color themeOfApp =
          themeValue ? ColorManager.white : ColorManager.black;

          return Row(children: [
            nameOfPath.isNotEmpty
                ? SvgPicture.asset(
              nameOfPath,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).dialogBackgroundColor,
                  BlendMode.srcIn),
              height: 25,
            )
                : Icon(icon, color: themeOfApp),
            const SizedBox(width: 15),
            Text(
              text,
              style: getNormalStyle(color: themeOfApp, fontSize: 15),
            )
          ]);
        },
      ),
    );
  }
}

import 'dart:math';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/functions/image_picker.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

import '../../../core/functions/toast_show.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  UserPersonalInfo userInfo;
  Uint8List? _photo;
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController userNameController = TextEditingController(text: "");
  final TextEditingController pronounsController =
      TextEditingController(text: "");
  final TextEditingController websiteController =
      TextEditingController(text: "");
  TextEditingController bioController = TextEditingController(text: "");

  EditProfilePage(this.userInfo, {Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isImageUpload = true;
  bool reBuild = false;
  bool userNameChanging = false;
  bool validateEdits = true;

  @override
  void initState() {
    widget.nameController = TextEditingController(text: widget.userInfo.name);
    widget.userNameController =
        TextEditingController(text: widget.userInfo.userName);
    widget.bioController = TextEditingController(text: widget.userInfo.bio);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      buildWhen: (previous, current) {
        if (previous != current && (current is CubitMyPersonalInfoLoaded)) {
          return true;
        }

        if (previous != current && reBuild) {
          reBuild = false;
          return true;
        }
        return false;
      },
      builder: (context, getUserState) {
        UserInfoCubit updateUserCubit = UserInfoCubit.get(context);

        if (getUserState is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(getUserState);
        }
        if (getUserState is CubitMyPersonalInfoLoaded) {
          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                widget.userInfo = getUserState.userPersonalInfo;
              });
            }
          });
        }

        return buildScaffold(context, getUserState, updateUserCubit);
      },
    );
  }

  Scaffold buildScaffold(BuildContext context, UserInfoState getUserState,
      UserInfoCubit updateUserCubit) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: isThatMobile
          ? buildAppBar(context, getUserState, updateUserCubit)
          : null,
      body: Column(
        children: [
          circleAvatarAndTextFields(context, updateUserCubit),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, UserInfoState getUserState,
      UserInfoCubit updateUserCubit) {
    return AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              IconsAssets.cancelIcon,
              color: Theme.of(context).focusColor,
              height: 27,
            )),
        title: Text(
          StringsManager.editProfile.tr,
          style:
              getMediumStyle(color: Theme.of(context).focusColor, fontSize: 20),
        ),
        actions: actionsWidgets(getUserState, updateUserCubit));
  }

  List<Widget> actionsWidgets(
      dynamic getUserState, UserInfoCubit updateUserCubit) {
    return [
      if (validateEdits) ...[
        getUserState is! CubitMyPersonalInfoLoaded
            ? Transform.scale(
                scaleY: 1,
                scaleX: 1.2,
                child: const CustomCircularProgress(ColorManager.blue))
            : IconButton(
                onPressed: () async {
                  reBuild = true;
                  List<dynamic> charactersOfName = [];
                  String name = widget.nameController.text.toLowerCase();
                  for (int i = 0; i < name.length; i++) {
                    charactersOfName =
                        charactersOfName + [name.substring(0, i + 1)];
                  }
                  UserPersonalInfo updatedUserInfo = UserPersonalInfo(
                    followerPeople: widget.userInfo.followerPeople,
                    followedPeople: widget.userInfo.followedPeople,
                    posts: widget.userInfo.posts,
                    userName: widget.userNameController.text,
                    name: widget.nameController.text,
                    bio: widget.bioController.text,
                    profileImageUrl: widget.userInfo.profileImageUrl,
                    email: widget.userInfo.email,
                    charactersOfName: charactersOfName,
                    stories: widget.userInfo.stories,
                    userId: widget.userInfo.userId,
                    deviceToken: widget.userInfo.deviceToken,
                    lastThreePostUrls: widget.userInfo.lastThreePostUrls,
                    chatsOfGroups: widget.userInfo.chatsOfGroups,
                  );
                  await updateUserCubit
                      .updateUserInfo(updatedUserInfo)
                      .whenComplete(() {
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).maybePop(widget.userInfo);
                      reBuild = false;
                    });
                  });
                },
                icon: checkIcon(false),
              )
      ] else ...[
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.5),
          child: checkIcon(true),
        )
      ],
    ];
  }

  Icon checkIcon(bool light) {
    return Icon(Icons.check_rounded,
        size: 30, color: light ? ColorManager.lightBlue : ColorManager.blue);
  }

  Expanded circleAvatarAndTextFields(
      BuildContext context, UserInfoCubit updateUserCubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(10),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: textFieldsColumn(context, updateUserCubit),
        ),
      ),
    );
  }

  Widget textFieldsColumn(BuildContext context, UserInfoCubit updateUserCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        imageCircleAvatar(context),
        const SizedBox(height: 15),
        Center(
            child: InkWell(
          onTap: () async {
            Uint8List? pickImage = await imageGalleryPicker();
            if (pickImage != null) {
              setState(() {
                widget._photo = pickImage;
                isImageUpload = false;
              });

              await updateUserCubit
                  .uploadProfileImage(
                      photo: widget._photo!,
                      userId: widget.userInfo.userId,
                      previousImageUrl: widget.userInfo.profileImageUrl)
                  .whenComplete(() {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).maybePop(widget.userInfo);
                  isImageUpload = true;
                });
              });
            } else {
              ToastShow.toast(StringsManager.noImageSelected.tr);
            }
          },
          child: Text(
            StringsManager.changeProfilePhoto.tr,
            style: getNormalStyle(fontSize: 18, color: ColorManager.blue),
          ),
        )),
        textFormField(widget.nameController, StringsManager.name.tr),
        const SizedBox(height: 10),
        userNameTextField(context),
        const SizedBox(height: 10),
        textFormField(widget.pronounsController, StringsManager.pronouns.tr),
        const SizedBox(height: 10),
        textFormField(widget.websiteController, StringsManager.website.tr),
        const SizedBox(height: 10),
        textFormField(widget.bioController, StringsManager.bio.tr),
        const SizedBox(height: 15),
        const Divider(),
        const SizedBox(height: 8),
        GestureDetector(
          child: Text(
            StringsManager.personalInformationSettings.tr,
            style: getNormalStyle(fontSize: 18, color: ColorManager.blue),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  BlocBuilder<SearchAboutUserBloc, SearchAboutUserState> userNameTextField(
      BuildContext context) {
    return BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
      bloc: BlocProvider.of<SearchAboutUserBloc>(context)
        ..add(FindSpecificUser(widget.userNameController.text,
            searchForSingleLetter: true)),
      buildWhen: (previous, current) =>
          previous != current && (current is SearchAboutUserBlocLoaded),
      builder: (context, state) {
        List<UserPersonalInfo> usersWithSameUserName = [];
        if (state is SearchAboutUserBlocLoaded) {
          usersWithSameUserName = state.users;
        }
        bool isIExist = usersWithSameUserName.contains(widget.userInfo);
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              validateEdits = isIExist || usersWithSameUserName.isEmpty;
              userNameChanging =
                  widget.userNameController.text != widget.userInfo.userName;
            }));
        return userNameTextFormField(
          widget.userNameController,
          StringsManager.username.tr,
          uniqueUserName: validateEdits,
        );
      },
    );
  }

  TextFormField userNameTextFormField(
      TextEditingController controller, String text,
      {required bool uniqueUserName}) {
    return TextFormField(
      cursorColor: ColorManager.teal,
      controller: controller,
      style: getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
      decoration: InputDecoration(
        labelText: text,
        suffixIcon: !userNameChanging
            ? null
            : (uniqueUserName && validateEdits ? rightIcon() : wrongIcon()),
        labelStyle: getNormalStyle(
            color: !uniqueUserName ? ColorManager.red : ColorManager.grey),
        errorText: uniqueUserName && validateEdits
            ? null
            : StringsManager.thisUserNameExist.tr,
        errorStyle: getNormalStyle(color: ColorManager.red),
      ),
      onChanged: (value) {
        if (value.isEmpty) setState(() => validateEdits = false);
      },
    );
  }

  Icon rightIcon() {
    return const Icon(Icons.check_circle, color: ColorManager.green, size: 27);
  }

  Transform wrongIcon() {
    return Transform.rotate(
      angle: pi / 3.6,
      child: const Icon(
        Icons.add_circle_rounded,
        color: ColorManager.red,
        size: 27,
      ),
    );
  }

  Center imageCircleAvatar(BuildContext context) {
    return Center(
        child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        studentCircleAvatarImage(),
      ],
    ));
  }

  Widget studentCircleAvatarImage() {
    bool hasUserPhoto = widget.userInfo.profileImageUrl.isNotEmpty;
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: isImageUpload && hasUserPhoto
            ? NetworkImage(widget.userInfo.profileImageUrl)
            : null,
        radius: 50,
        backgroundColor: Theme.of(context).focusColor,
        child: ClipOval(
            child: !isImageUpload
                ? const ThineCircularProgress()
                : (!hasUserPhoto
                    ? Icon(Icons.person, color: Theme.of(context).primaryColor)
                    : null)),
      ),
    );
  }

  TextFormField textFormField(TextEditingController controller, String text) {
    return TextFormField(
      cursorColor: ColorManager.teal,
      controller: controller,
      style: getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: getNormalStyle(color: ColorManager.grey),
        errorStyle: getNormalStyle(color: ColorManager.red),
      ),
    );
  }
}

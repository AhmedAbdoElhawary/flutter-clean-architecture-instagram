import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/functions/image_picker.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/user_personal_info.dart';
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
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreUserInfoState>(
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
        FirestoreUserInfoCubit updateUserCubit =
            FirestoreUserInfoCubit.get(context);

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

  Scaffold buildScaffold(
      BuildContext context,
      FirestoreUserInfoState getUserState,
      FirestoreUserInfoCubit updateUserCubit) {
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

  AppBar buildAppBar(BuildContext context, FirestoreUserInfoState getUserState,
      FirestoreUserInfoCubit updateUserCubit) {
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
          StringsManager.editProfile.tr(),
          style:
              getMediumStyle(color: Theme.of(context).focusColor, fontSize: 20),
        ),
        actions: actionsWidgets(getUserState, updateUserCubit));
  }

  List<Widget> actionsWidgets(
      dynamic getUserState, FirestoreUserInfoCubit updateUserCubit) {
    return [
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
                    userId: widget.userInfo.userId);
                await updateUserCubit
                    .updateUserInfo(updatedUserInfo)
                    .whenComplete(() {
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context).maybePop(widget.userInfo);
                    reBuild = false;
                  });
                });
              },
              icon: const Icon(
                Icons.check_rounded,
                size: 30,
                color: ColorManager.blue,
              ))
    ];
  }

  Expanded circleAvatarAndTextFields(
      BuildContext context, FirestoreUserInfoCubit updateUserCubit) {
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

  Widget textFieldsColumn(
      BuildContext context, FirestoreUserInfoCubit updateUserCubit) {
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
              ToastShow.toast(StringsManager.noImageSelected.tr());
            }
          },
          child: Text(
            StringsManager.changeProfilePhoto.tr(),
            style: getNormalStyle(fontSize: 18, color: ColorManager.blue),
          ),
        )),
        textFormField(widget.nameController, StringsManager.name.tr()),
        const SizedBox(height: 10),
        textFormField(widget.userNameController, StringsManager.username.tr()),
        const SizedBox(height: 10),
        textFormField(widget.pronounsController, StringsManager.pronouns.tr()),
        const SizedBox(height: 10),
        textFormField(widget.websiteController, StringsManager.website.tr()),
        const SizedBox(height: 10),
        textFormField(widget.bioController, StringsManager.bio.tr()),
        const SizedBox(height: 15),
        const Divider(),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {},
          child: Text(
            StringsManager.personalInformationSettings.tr(),
            style: getNormalStyle(fontSize: 18, color: ColorManager.blue),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
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

  InkWell studentCircleAvatarImage() {
    bool hasUserPhoto = widget.userInfo.profileImageUrl.isNotEmpty;
    return InkWell(
      onTap: () async {},
      child: CircleAvatar(
        backgroundImage: isImageUpload && hasUserPhoto
            ? NetworkImage(widget.userInfo.profileImageUrl)
            : null,
        child: ClipOval(
            child: !isImageUpload
                ? const ThineCircularProgress()
                : (!hasUserPhoto
                    ? Icon(Icons.person, color: Theme.of(context).primaryColor)
                    : null)),
        radius: 50,
        backgroundColor: Theme.of(context).focusColor,
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
      ),
    );
  }
}

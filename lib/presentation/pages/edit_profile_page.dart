import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/widgets/custom_circular_progress.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/toast_show.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  UserPersonalInfo userInfo;
  File? _photo;
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
  bool isImageUpload = false;
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
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
      buildWhen: (previous, current) {
        if (previous != current && (current is CubitMyPersonalInfoLoaded)) {
          return true;
        }
        return false;
      },
      builder: (context, getUserState) {
        print("1111111111111111111111");
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
                if (isImageUpload) {
                  Navigator.of(context).maybePop(widget.userInfo);
                }
              });
            }
          });
        }

        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: ColorManager.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    IconsAssets.cancelIcon,
                    color: ColorManager.black,
                    height: 30,
                  )),
              title: const Text(StringsManager.editProfile),
              actions: actionsWidgets(getUserState, updateUserCubit)),
          body: Column(
            children: [
              circleAvatarAndTextFields(context, updateUserCubit),
            ],
          ),
        );
      },
    );
  }

  List<Widget> actionsWidgets(
      dynamic getUserState, FirestoreUserInfoCubit updateUserCubit) {
    return [
      getUserState is CubitUserLoading
          ? const CustomCircularProgress(ColorManager.blue)
          : IconButton(
              onPressed: () async {
                UserPersonalInfo updatedUserInfo = UserPersonalInfo(
                    followerPeople: widget.userInfo.followerPeople,
                    followedPeople: widget.userInfo.followedPeople,
                    posts: widget.userInfo.posts,
                    userName: widget.userNameController.text,
                    name: widget.nameController.text,
                    bio: widget.bioController.text,
                    profileImageUrl: widget.userInfo.profileImageUrl,
                    email: widget.userInfo.email,
                    stories: widget.userInfo.stories,
                    userId: widget.userInfo.userId);
                await updateUserCubit
                    .updateUserInfo(updatedUserInfo)
                    .whenComplete(() {
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context).maybePop(widget.userInfo);
                  });
                });
              },
              icon: const Icon(
                Icons.check,
                size: 30,
                color: ColorManager.blue,
              ))
    ];
  }

  Expanded circleAvatarAndTextFields(
      BuildContext context, FirestoreUserInfoCubit updateUserCubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
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
            final ImagePicker _picker = ImagePicker();
            final pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              setState(() {
                widget._photo = File(pickedFile.path);
                isImageUpload = false;
              });

              await updateUserCubit.uploadProfileImage(
                  photo: widget._photo!,
                  userId: widget.userInfo.userId,
                  previousImageUrl: widget.userInfo.profileImageUrl);
              setState(() {
                isImageUpload = true;
              });
            } else {
              ToastShow.toast(StringsManager.noImageSelected);
            }
          },
          child: const Text(
            StringsManager.changeProfilePhoto,
            style: TextStyle(fontSize: 18, color: ColorManager.blue),
          ),
        )),
        textFormField(widget.nameController, StringsManager.name),
        const SizedBox(height: 10),
        textFormField(widget.userNameController,StringsManager.username ),
        const SizedBox(height: 10),
        textFormField(widget.pronounsController,StringsManager.pronouns),
        const SizedBox(height: 10),
        textFormField(widget.websiteController, StringsManager.website),
        const SizedBox(height: 10),
        textFormField(widget.bioController, StringsManager.bio),
        const SizedBox(height: 15),
        const Divider(),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {},
          child: const Text(
            StringsManager.personalInformationSettings,
            style: TextStyle(fontSize: 18, color: ColorManager.blue),
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
    return InkWell(
      onTap: () async {},
      child: CircleAvatar(
        child: ClipOval(
          child: isImageUpload
              ? const CircularProgressIndicator()
              : (widget.userInfo.profileImageUrl.isEmpty
                  ? const Icon(Icons.person, color: ColorManager.white)
                  : CustomFadeInImage(
                      imageUrl: widget.userInfo.profileImageUrl)),
        ),
        radius: 50,
        backgroundColor: ColorManager.black,
      ),
    );
  }

  TextFormField textFormField(TextEditingController controller, String text) {
    return TextFormField(
      controller: controller,
      cursorColor: ColorManager.teal,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: text,
      ),
    );
  }
}

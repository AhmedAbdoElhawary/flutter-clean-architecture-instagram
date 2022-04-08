import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/widgets/custom_circular_progress.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/toast_show.dart';


// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  final UserPersonalInfo userInfo;
  File? _photo;
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController userNameController = TextEditingController(text: "");
 final TextEditingController pronounsController = TextEditingController(text: "");
 final TextEditingController websiteController = TextEditingController(text: "");
  TextEditingController bioController = TextEditingController(text: "");
  EditProfilePage(this.userInfo, {Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isImageUpload = true;
  @override
  void initState() {
    widget.nameController = TextEditingController(text: widget.userInfo.name);
    widget.userNameController =
        TextEditingController(text: widget.userInfo.userName);
    widget.bioController = TextEditingController(text: widget.userInfo.bio);
    super.initState();
    // TODO -----------------------------------
    BlocProvider.of<FirestoreUserInfoCubit>(context).emit(CubitInitial());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
      builder: (context, getUserState) {
        FirestoreUserInfoCubit updateUserCubit =
            FirestoreUserInfoCubit.get(context);

        if (getUserState is CubitMyPersonalInfoLoaded) {
          Future.delayed(Duration.zero, () {
            Navigator.of(context).maybePop(widget.userInfo);
          });
        } else if (getUserState is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(getUserState);
        }
        if (getUserState is CubitImageLoaded) {

          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                widget.userInfo.profileImageUrl = getUserState.imageUrl;
                isImageUpload = true;
              });
              Navigator.of(context).maybePop(widget.userInfo);
            }
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/cancel.svg",
                    color: Colors.black,
                    height: 30,
                  )),
              title: const Text("Edit profile"),
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
          ?  const CustomCircularProgress(Colors.blue)
          : IconButton(
              onPressed: () {
                UserPersonalInfo updatedUserInfo = UserPersonalInfo(
                    followerPeople: widget.userInfo.followerPeople,
                    followedPeople: widget.userInfo.followedPeople,
                    posts: widget.userInfo.posts,
                    userName: widget.userNameController.text,
                    name: widget.nameController.text,
                    bio: widget.bioController.text,
                    profileImageUrl: widget.userInfo.profileImageUrl,
                    email: widget.userInfo.email,
                    userId: widget.userInfo.userId);
                updateUserCubit.updateUserInfo(updatedUserInfo);
              },
              icon: const Icon(
                Icons.check,
                size: 30,
                color: Colors.blue,
              ))
    ];
  }

  Expanded circleAvatarAndTextFields(
      BuildContext context, FirestoreUserInfoCubit updateUserCubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
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

            setState(() {
              if (pickedFile != null) {
                widget._photo = File(pickedFile.path);
                isImageUpload = false;
                updateUserCubit.uploadProfileImage(
                    photo: widget._photo!,
                    userId: widget.userInfo.userId,
                    previousImageUrl: widget.userInfo.profileImageUrl);
              } else {
                ToastShow.toast('No image selected.');
              }
            });
          },
          child: const Text(
            "Change profile photo",
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
        )),
        textFormField(widget.nameController, "Name"),
        const SizedBox(height: 10),
        textFormField(widget.userNameController, "Username"),
        const SizedBox(height: 10),
        textFormField(widget.pronounsController, "Pronouns"),
        const SizedBox(height: 10),
        textFormField(widget.websiteController, "Website"),
        const SizedBox(height: 10),
        textFormField(widget.bioController, "Bio"),
        const SizedBox(height: 15),
        const Divider(),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {},
          child: const Text(
            "Personal information settings",
            style: TextStyle(fontSize: 18, color: Colors.blue),
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
          child: !isImageUpload
              ? const CircularProgressIndicator()
              : (widget.userInfo.profileImageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : Image.network(widget.userInfo.profileImageUrl)),
        ),
        radius: 50,
        backgroundColor: Colors.black,
      ),
    );
  }

  TextFormField textFormField(TextEditingController controller, String text) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.teal,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: text,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';

class PersonalImageIcon extends StatefulWidget {
  const PersonalImageIcon({Key? key}) : super(key: key);

  @override
  State<PersonalImageIcon> createState() => _PersonalImageIconState();
}

class _PersonalImageIconState extends State<PersonalImageIcon> {
  late UserPersonalInfo myPersonalInfo;
  @override
  void initState() {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    UserPersonalInfo? info = UsersInfoReelTimeBloc.getMyInfoInReelTime(context);
    if (info != null) myPersonalInfo = info;

    this.myPersonalInfo = myPersonalInfo;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PersonalImageIcon oldWidget) {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    UserPersonalInfo? info = UsersInfoReelTimeBloc.getMyInfoInReelTime(context);
    if (info != null) myPersonalInfo = info;

    this.myPersonalInfo = myPersonalInfo;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    String userImage = myPersonalInfo.profileImageUrl;
    if (userImage.isNotEmpty) {
      return CircleAvatarOfProfileImage(
        disablePressed: true,
        userInfo: myPersonalInfo,
        bodyHeight: 300,
        showColorfulCircle: false,
      );
    } else {
      return CircleAvatar(
          radius: 14,
          backgroundColor: Theme.of(context).hintColor,
          child: const Icon(Icons.person, color: ColorManager.white));
    }
  }
}

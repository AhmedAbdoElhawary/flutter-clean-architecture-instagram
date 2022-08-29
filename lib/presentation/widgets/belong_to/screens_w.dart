import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';

class PersonalImageIcon extends StatelessWidget {
  const PersonalImageIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UserPersonalInfo myPersonalInfo =
          UserInfoCubit.getMyPersonalInfo(context);
      String userImage = myPersonalInfo.profileImageUrl;
      if (userImage.isNotEmpty) {
        return CircleAvatarOfProfileImage(
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
    });
  }
}

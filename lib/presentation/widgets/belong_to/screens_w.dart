import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';

class PersonalImageIcon extends StatefulWidget {
  final UserPersonalInfo myPersonalInfo;

  const PersonalImageIcon({Key? key, required this.myPersonalInfo})
      : super(key: key);

  @override
  State<PersonalImageIcon> createState() => _PersonalImageIconState();
}

class _PersonalImageIconState extends State<PersonalImageIcon> {
  @override
  Widget build(BuildContext context) {
    String userImage = widget.myPersonalInfo.profileImageUrl;
    if (userImage.isNotEmpty) {
      return CircleAvatarOfProfileImage(
        disablePressed: true,
        userInfo: widget.myPersonalInfo,
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

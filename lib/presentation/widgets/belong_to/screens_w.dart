import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';

class PersonalImageIcon extends StatelessWidget {
  const PersonalImageIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UserPersonalInfo userCubit = UserInfoCubit.getMyPersonalInfo(context);
      String userImage = userCubit.profileImageUrl;
      if (userImage.isNotEmpty) {
        return NetworkImageDisplay(
          imageUrl: userImage,
          height: 100,
          cachingWidth: 100,
          cachingHeight: 100,
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

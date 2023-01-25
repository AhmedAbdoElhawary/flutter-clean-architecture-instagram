import 'package:flutter/material.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/pages/profile/personal_profile_page.dart';
import 'package:instagram/presentation/pages/profile/user_profile_page.dart';

class WhichProfilePageParameters {
  final String userId;
  final String userName;
  const WhichProfilePageParameters(
      {Key? key, this.userId = '', this.userName = ''});
}

class WhichProfilePage extends StatelessWidget {
  final WhichProfilePageParameters whichProfilePageParameters;
  const WhichProfilePage( this.whichProfilePageParameters,{Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = whichProfilePageParameters.userId;
    String userName = whichProfilePageParameters.userName;

    if (userId.isNotEmpty) {
      return userId == myPersonalId
          ? PersonalProfilePage(personalId: userId)
          : UserProfilePage(userId: userId);
    } else {
      return Builder(builder: (context) {
        UserPersonalInfo? myPersonalInfo =
            UserInfoCubit.get(context).myPersonalInfo;

        return userName == myPersonalInfo.userName
            ? PersonalProfilePage(userName: userName, personalId: userId)
            : UserProfilePage(userName: userName, userId: userId);
      });
    }
  }
}

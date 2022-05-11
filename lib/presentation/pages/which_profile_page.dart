import 'package:flutter/material.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/pages/personal_profile_page.dart';
import 'package:instagram/presentation/widgets/user_profile_page.dart';

class WhichProfilePage extends StatelessWidget {
  final String userId;
  final String userName;
  const WhichProfilePage({Key? key, this.userId = '', this.userName = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userId.isNotEmpty) {
      return userId == myPersonalId
          ? PersonalProfilePage(personalId: userId)
          : UserProfilePage(userId: userId);
    } else {
      return Builder(builder: (context) {
        UserPersonalInfo? myPersonalInfo =
            FirestoreUserInfoCubit.get(context).myPersonalInfo;

        return userName == myPersonalInfo!.userName
            ? PersonalProfilePage(
                userName: userName,
                personalId: userId,
              )
            : UserProfilePage(
                userName: userName,
                userId: userId,
              );
      });
    }
  }
}

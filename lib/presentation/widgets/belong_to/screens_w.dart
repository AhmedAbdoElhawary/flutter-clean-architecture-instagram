import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';

class PersonalImageIcon extends StatelessWidget {
  const PersonalImageIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, FirestoreUserInfoState>(
        builder: (context, state) {
      UserInfoCubit userCubit = UserInfoCubit.get(context);
      String userImage = userCubit.myPersonalInfo!.profileImageUrl;

      return CircleAvatar(
          radius: 14,
          backgroundImage:
              userImage.isNotEmpty ? NetworkImage(userImage) : null,
          backgroundColor: Theme.of(context).hintColor,
          child: userImage.isEmpty
              ? const Icon(Icons.person, color: ColorManager.white)
              : null);
    });
  }
}

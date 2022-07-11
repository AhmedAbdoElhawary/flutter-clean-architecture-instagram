import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/show_me_the_users.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';

class ActivityPage extends StatelessWidget {
  final ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);
  final UserPersonalInfo myPersonalInfo;
  ActivityPage({Key? key, required this.myPersonalInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: ValueListenableBuilder(
        valueListenable: rebuildUsersInfo,
        builder: (context, bool rebuildValue, child) =>
            BlocBuilder<FirestoreUserInfoCubit, FirestoreUserInfoState>(
          bloc: FirestoreUserInfoCubit.get(context)
            ..getAllUnFollowersUsers(myPersonalInfo),
          buildWhen: (previous, current) {
            if (previous != current &&
                (current is CubitAllUnFollowersUserLoaded)) {
              return true;
            }

            if (previous != current && rebuildValue) {
              rebuildUsersInfo.value = false;
              return true;
            }
            return false;
          },
          builder: (context, getUserState) {

            if (getUserState is CubitGetUserInfoFailed) {
              ToastShow.toast(getUserState.error);
            } else if (getUserState is CubitAllUnFollowersUserLoaded) {
              return ShowMeTheUsers(
                usersInfo: getUserState.usersInfo,
                userInfo: ValueNotifier(myPersonalInfo),
                showColorfulCircle: false,
              );
            }
            return const ThineCircularProgress();
          },
        ),
      ),
    );
  }
}

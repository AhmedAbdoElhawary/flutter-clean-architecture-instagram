import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/show_me_the_users.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

import '../../cubit/firestoreUserInfoCubit/users_info_cubit.dart';

class UsersWhoLikes extends StatelessWidget {
  final List<dynamic> usersIds;
  final bool showSearchBar;
  final bool showColorfulCircle;

  const UsersWhoLikes(
      {Key? key, required this.showSearchBar, required this.usersIds, this.showColorfulCircle = true,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<UsersInfoCubit>(context)
        ..getSpecificUsersInfo(usersIds: usersIds),
      buildWhen: (previous, current) =>
          previous != current && current is CubitGettingSpecificUsersLoaded,
      builder: (context, state) {
        if (state is CubitGettingSpecificUsersLoaded) {
          return ShowMeTheUsers(
            usersInfo: state.specificUsersInfo,
            showSearchBar: showSearchBar,
            emptyText: StringsManager.noUsers.tr(),
            showColorfulCircle: showColorfulCircle,
          );
        }
        if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Center(
            child: Text(StringsManager.somethingWrong.tr(),
                style: Theme.of(context).textTheme.bodyText1),
          );
        } else {
          return const Center(child: ThineCircularProgress());
        }
      },
    );
  }
}

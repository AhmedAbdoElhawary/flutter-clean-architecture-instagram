import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/show_me_the_users.dart';
import 'package:instagram/core/functions/toast_show.dart';
import '../../cubit/firestoreUserInfoCubit/users_info_cubit.dart';

class UsersWhoLikesOnPostPage extends StatefulWidget {
  final List<dynamic> usersIds;
  final bool showSearchBar;
  const UsersWhoLikesOnPostPage({
    Key? key,
    required this.showSearchBar,
    required this.usersIds,
  }) : super(key: key);

  @override
  State<UsersWhoLikesOnPostPage> createState() =>
      _UsersWhoLikesOnPostPageState();
}

class _UsersWhoLikesOnPostPageState extends State<UsersWhoLikesOnPostPage> {
  bool rebuildUsersInfo = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(StringsManager.likes.tr(),
              style: Theme.of(context).textTheme.bodyText1),
        ),
        body: BlocBuilder(
          bloc: BlocProvider.of<UsersInfoCubit>(context)
            ..getSpecificUsersInfo(usersIds: widget.usersIds),
          buildWhen: (previous, current) {
            if (previous != current &&
                current != CubitGettingSpecificUsersLoaded) {
              return true;
            }
            if (rebuildUsersInfo &&
                current != CubitGettingSpecificUsersLoaded) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is CubitGettingSpecificUsersLoaded) {
              return ShowMeTheUsers(
                usersInfo: state.specificUsersInfo,
                showSearchBar: widget.showSearchBar,
              );
            }
            if (state is CubitGettingSpecificUsersFailed) {
              ToastShow.toastStateError(state);
              return Text(StringsManager.somethingWrong.tr(),
                  style: Theme.of(context).textTheme.bodyText1);
            } else {
              return const ThineCircularProgress();
            }
          },
        ),
      ),
    );
  }
}

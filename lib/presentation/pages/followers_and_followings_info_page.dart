import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/widgets/show_me_the_users.dart';
import 'package:instagram/presentation/widgets/toast_show.dart';
import '../cubit/firestoreUserInfoCubit/users_info_cubit.dart';

class FollowersAndFollowingsInfoPage extends StatefulWidget {
  final UserPersonalInfo userInfo;
  final int initialIndex;

  const FollowersAndFollowingsInfoPage(
      {Key? key, required this.userInfo, this.initialIndex = 0})
      : super(key: key);

  @override
  State<FollowersAndFollowingsInfoPage> createState() =>
      _FollowersAndFollowingsInfoPageState();
}

class _FollowersAndFollowingsInfoPageState
    extends State<FollowersAndFollowingsInfoPage> {
  bool rebuildUsersInfo = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          bottom: TabBar(
            unselectedLabelColor: ColorManager.grey,
            indicatorColor: Theme.of(context).focusColor,
            indicatorWeight: 1,
            tabs: [
              Tab(
                  icon: buildText(context,
                      "${widget.userInfo.followerPeople.length} ${StringsManager.followers.tr()}")),
              Tab(
                  icon: buildText(context,
                      "${widget.userInfo.followedPeople.length} ${StringsManager.following.tr()}")),
            ],
          ),
          title: buildText(context, widget.userInfo.userName),
        ),
        body: BlocBuilder(
          bloc: BlocProvider.of<UsersInfoCubit>(context)
            ..getFollowersAndFollowingsInfo(
                followersIds: widget.userInfo.followerPeople,
                followingsIds: widget.userInfo.followedPeople),
          buildWhen: (previous, current) {
            if (previous != current &&
                (current is CubitFollowersAndFollowingsLoaded)) {
              return true;
            }
            if (rebuildUsersInfo &&
                (current is CubitFollowersAndFollowingsLoaded)) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is CubitFollowersAndFollowingsLoaded) {
              return TabBarView(
                children: [
                  ShowMeTheUsers(
                    usersInfo: state.followersAndFollowingsInfo.followersInfo,
                    isThatFollower: true,
                    userInfo: widget.userInfo,
                    rebuildVariable: rebuild,
                    showSearchBar: true,
                  ),
                  ShowMeTheUsers(
                    usersInfo: state.followersAndFollowingsInfo.followingsInfo,
                    isThatFollower: false,
                    userInfo: widget.userInfo,
                    rebuildVariable: rebuild,
                    showSearchBar: true,
                  ),
                ],
              );
            }
            if (state is CubitGettingSpecificUsersFailed) {
              ToastShow.toastStateError(state);
              return Text(StringsManager.somethingWrong.tr());
            } else {
              return const ThineCircularProgress();
            }
          },
        ),
      ),
    );
  }

  Text buildText(BuildContext context, String text) {
    return Text(text,
        style: getNormalStyle(color: Theme.of(context).focusColor));
  }

  void rebuild(bool rebuild) {
    setState(() {
      rebuildUsersInfo = rebuild;
    });
  }
}

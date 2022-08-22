import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/show_me_the_users.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

import '../../cubit/firestoreUserInfoCubit/users_info_cubit.dart';

class FollowersInfoPage extends StatefulWidget {
  final UserPersonalInfo userInfo;
  final int initialIndex;

  const FollowersInfoPage(
      {Key? key, required this.userInfo, this.initialIndex = 0})
      : super(key: key);

  @override
  State<FollowersInfoPage> createState() => _FollowersInfoPageState();
}

class _FollowersInfoPageState extends State<FollowersInfoPage> {
  ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: isThatMobile ? buildAppBar(context) : null,
        body: ValueListenableBuilder(
          valueListenable: rebuildUsersInfo,
          builder: (context, bool rebuildValue, child) =>
              BlocBuilder<UsersInfoCubit, UsersInfoState>(
            bloc: BlocProvider.of<UsersInfoCubit>(context)
              ..getFollowersAndFollowingsInfo(
                  followersIds: widget.userInfo.followerPeople,
                  followingsIds: widget.userInfo.followedPeople),
            buildWhen: (previous, current) {
              if (previous != current &&
                  (current is CubitFollowersAndFollowingsLoaded)) {
                return true;
              }
              if (rebuildValue &&
                  (current is CubitFollowersAndFollowingsLoaded)) {
                rebuildUsersInfo.value = false;
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is CubitFollowersAndFollowingsLoaded) {
                return _TapBarView(
                  state: state,
                  userInfo: ValueNotifier(widget.userInfo),
                );
              }
              if (state is CubitGettingSpecificUsersFailed) {
                ToastShow.toastStateError(state);
                return Text(StringsManager.somethingWrong.tr);
              } else {
                return const ThineCircularProgress();
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      bottom: TabBar(
        unselectedLabelColor: ColorManager.grey,
        indicatorColor: Theme.of(context).focusColor,
        indicatorWeight: 1,
        tabs: [
          Tab(
              icon: buildText(context,
                  "${widget.userInfo.followerPeople.length} ${StringsManager.followers.tr}")),
          Tab(
              icon: buildText(context,
                  "${widget.userInfo.followedPeople.length} ${StringsManager.following.tr}")),
        ],
      ),
      title: buildText(context, widget.userInfo.userName),
    );
  }

  Text buildText(BuildContext context, String text) {
    return Text(text,
        style: getNormalStyle(color: Theme.of(context).focusColor));
  }
}

class _TapBarView extends StatelessWidget {
  final CubitFollowersAndFollowingsLoaded state;
  final ValueNotifier<UserPersonalInfo> userInfo;

  const _TapBarView({Key? key, required this.userInfo, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isThatMyPersonalId = userInfo.value.userId == myPersonalId;

    return TabBarView(
      children: [
        SingleChildScrollView(
          child: ShowMeTheUsers(
            usersInfo: state.followersAndFollowingsInfo.followersInfo,
            emptyText: StringsManager.noFollowers.tr,
            isThatMyPersonalId: isThatMyPersonalId,
          ),
        ),
        SingleChildScrollView(
          child: ShowMeTheUsers(
            usersInfo: state.followersAndFollowingsInfo.followingsInfo,
            isThatFollower: false,
            emptyText: StringsManager.noFollowings.tr,
            isThatMyPersonalId: isThatMyPersonalId,
          ),
        ),
      ],
    );
  }
}

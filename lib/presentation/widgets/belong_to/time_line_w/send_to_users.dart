import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';

class SendToUsers extends StatelessWidget {
  final ValueNotifier<bool> sendToUsers = ValueNotifier(false);
  final UserPersonalInfo userInfo;
  SendToUsers({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersInfoCubit, UsersInfoState>(
      bloc: BlocProvider.of<UsersInfoCubit>(context)
        ..getFollowersAndFollowingsInfo(
            followersIds: userInfo.followerPeople,
            followingsIds: userInfo.followedPeople),
      buildWhen: (previous, current) {
        if (previous != current &&
            (current is CubitFollowersAndFollowingsLoaded)) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CubitFollowersAndFollowingsLoaded) {
          List<UserPersonalInfo> usersInfo =
              state.followersAndFollowingsInfo.followersInfo +
                  state.followersAndFollowingsInfo.followingsInfo;
          return SafeArea(
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.only(end: 10, start: 10, top: 10),
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                itemBuilder: (context, index) => buildUserInfo(
                  context,
                  usersInfo[index],
                ),
                itemCount: usersInfo.length,
                separatorBuilder: (context, _) => const SizedBox(height: 15),
              ),
            ),
          );
        }
        if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Text(StringsManager.somethingWrong.tr());
        } else {
          return const ThineCircularProgress();
        }
      },
    );
  }

  Row buildUserInfo(BuildContext context, UserPersonalInfo userInfo) {
    return Row(children: [
      CircleAvatar(
        backgroundColor: ColorManager.customGrey,
        backgroundImage: userInfo.profileImageUrl.isNotEmpty
            ? CachedNetworkImageProvider(userInfo.profileImageUrl)
            : null,
        child: userInfo.profileImageUrl.isEmpty
            ? Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 20,
              )
            : null,
        radius: 30,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userInfo.userName,
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 5),
            Text(
              userInfo.name,
              style: Theme.of(context).textTheme.headline1,
            )
          ],
        ),
      ),
      GestureDetector(
        onTap: () async {
          sendToUsers.value = !sendToUsers.value;
        },
        child: whichContainerOfText(context),
      ),
    ]);
  }

  Widget whichContainerOfText(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: sendToUsers,
      builder: (context, bool sendToUsersValue, child) {
        return sendToUsersValue
            ? containerOfFollowText(context, text: StringsManager.send.tr())
            : containerOfFollowText(context, text: StringsManager.undo.tr());
      },
    );
  }

  Widget containerOfFollowText(BuildContext context, {required String text}) {
    return ValueListenableBuilder(
      valueListenable: sendToUsers,
      builder: (context, bool sendToUsersValue, child) => Container(
        height: 35.0,
        decoration: BoxDecoration(
          color: sendToUsersValue
              ? Theme.of(context).primaryColor
              : ColorManager.blue,
          border: Border.all(
              color: Theme.of(context).bottomAppBarColor,
              width: sendToUsersValue ? 1.0 : 0),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 17.0,
                color: sendToUsersValue
                    ? Theme.of(context).focusColor
                    : ColorManager.white,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

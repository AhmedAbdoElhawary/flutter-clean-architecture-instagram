import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/notification.dart';
import 'package:instagram/domain/entities/notification_check.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/follow/follow_cubit.dart';
import 'package:instagram/presentation/cubit/notification/notification_cubit.dart';
import 'package:instagram/presentation/pages/messages/chatting_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/bottom_sheet.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/recommendation_people.dart';
import 'package:instagram/core/functions/toast_show.dart';
import '../../../core/utility/constant.dart';
import '../../../data/models/user_personal_info.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final String userName;

  const UserProfilePage({Key? key, required this.userId, this.userName = ''})
      : super(key: key);

  @override
  State<UserProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage> {
  ValueNotifier<bool> rebuildUserInfo = ValueNotifier(false);
  late UserPersonalInfo myPersonalInfo;

  @override
  initState() {
    myPersonalInfo = FirestoreUserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  dispose() {
    rebuildUserInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Future<void> getData() async {
    widget.userName.isNotEmpty
        ? (await BlocProvider.of<FirestoreUserInfoCubit>(context)
            .getUserFromUserName(widget.userName))
        : (await BlocProvider.of<FirestoreUserInfoCubit>(context)
            .getUserInfo(widget.userId, isThatMyPersonalId: false));
    rebuildUserInfo.value = true;
  }

  Widget scaffold() {
    return ValueListenableBuilder(
      valueListenable: rebuildUserInfo,
      builder: (context, bool rebuildUserInfoValue, child) =>
          BlocBuilder<FirestoreUserInfoCubit, FirestoreUserInfoState>(
        bloc: widget.userName.isNotEmpty
            ? (BlocProvider.of<FirestoreUserInfoCubit>(context)
              ..getUserFromUserName(widget.userName))
            : (BlocProvider.of<FirestoreUserInfoCubit>(context)
              ..getUserInfo(widget.userId, isThatMyPersonalId: false)),
        buildWhen: (previous, current) {
          if (previous != current && current is CubitUserLoaded) {
            return true;
          }
          if (rebuildUserInfoValue && current is CubitUserLoaded) {
            rebuildUserInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is CubitUserLoaded) {
            return Scaffold(
              appBar: CustomAppBar.menuOfUserAppBar(
                  context, state.userPersonalInfo.userName, bottomSheet),
              body: ProfilePage(
                isThatMyPersonalId: false,
                userId: widget.userId,
                getData: getData,
                userInfo: state.userPersonalInfo,
                widgetsAboveTapBars:
                    widgetsAboveTapBars(state.userPersonalInfo, state),
              ),
            );
          } else if (state is CubitGetUserInfoFailed) {
            ToastShow.toastStateError(state);
            return Text(
              StringsManager.somethingWrong.tr(),
              style: Theme.of(context).textTheme.bodyText1,
            );
          } else {
            return const ThineCircularProgress();
          }
        },
      ),
    );
  }

  Future<void> bottomSheet() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          headIcon: Container(),
          bodyText: buildTexts(),
        );
      },
    );
  }

  Padding buildTexts() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          textOfBottomSheet(StringsManager.report.tr()),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.block.tr()),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.aboutThisAccount.tr()),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.restrict.tr()),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.hideYourStory.tr()),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.copyProfileURL.tr()),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.shareThisProfile.tr()),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Text textOfBottomSheet(String text) {
    return Text(text,
        style:
            getNormalStyle(fontSize: 15, color: Theme.of(context).focusColor));
  }

  List<Widget> widgetsAboveTapBars(
      UserPersonalInfo userInfo, FirestoreUserInfoState userInfoState) {
    return [
      followButton(userInfo, userInfoState),
      const SizedBox(width: 5),
      messageButton(userInfo),
      const SizedBox(width: 5),
      const RecommendationPeople(),
      const SizedBox(width: 10),
    ];
  }

  Widget followButton(
      UserPersonalInfo userInfo, FirestoreUserInfoState userInfoState) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, stateOfFollow) {
        return Expanded(
          child: InkWell(
              onTap: () async {
                if (myPersonalInfo.followedPeople.contains(userInfo.userId)) {
                  BlocProvider.of<FollowCubit>(context).removeThisFollower(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);
                  myPersonalInfo.followedPeople.remove(userInfo.userId);
                  //for notification
                  BlocProvider.of<NotificationCubit>(context)
                      .deleteNotification(
                          notificationCheck: createNotificationCheck(userInfo));
                } else {
                  BlocProvider.of<FollowCubit>(context).followThisUser(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);
                  myPersonalInfo.followedPeople.add(userInfo.userId);
                  //for notification
                  BlocProvider.of<NotificationCubit>(context)
                      .createNotification(
                          newNotification: createNotification(userInfo));
                }
              },
              child: whichContainerOfText(stateOfFollow, userInfo)),
        );
      },
    );
  }

  NotificationCheck createNotificationCheck(UserPersonalInfo userInfo) {
    return NotificationCheck(
      senderId: myPersonalId,
      receiverId: userInfo.userId,
      isThatLike: false,
      isThatPost: false,
    );
  }

  CustomNotification createNotification(UserPersonalInfo userInfo) {
    return CustomNotification(
      text: "started following you.",
      time: DateOfNow.dateOfNow(),
      senderId: myPersonalId,
      receiverId: userInfo.userId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      isThatLike: false,
      isThatPost: false,
    );
  }

  Widget whichContainerOfText(
      FollowState stateOfFollow, UserPersonalInfo userInfo) {
    bool isFollowLoading = stateOfFollow is CubitFollowThisUserLoading;
    if (stateOfFollow is CubitFollowThisUserFailed) {
      ToastShow.toastStateError(stateOfFollow);
    }
    bool isThatFollower =
        myPersonalInfo.followerPeople.contains(userInfo.userId);
    return !myPersonalInfo.followedPeople.contains(userInfo.userId)
        ? containerOfFollowText(
            text: isThatFollower
                ? StringsManager.followBack.tr()
                : StringsManager.follow.tr(),
            isThatFollowers: false,
            isItLoading: isFollowLoading)
        : containerOfFollowText(
            text: StringsManager.following.tr(),
            isThatFollowers: true,
            isItLoading: isFollowLoading);
  }

  Expanded messageButton(UserPersonalInfo userInfo) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(CupertinoPageRoute(
            builder: (context) => BlocProvider<MessageBloc>(
              create: (context) => injector<MessageBloc>(),
              child: ChattingPage(
                userInfo: userInfo,
              ),
            ),
            maintainState: false,
          ));
        },
        child: containerOfFollowText(
            text: StringsManager.message.tr(),
            isThatFollowers: true,
            isItLoading: false),
      ),
    );
  }

  Container containerOfFollowText(
      {required String text,
      required bool isThatFollowers,
      required bool isItLoading}) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: isThatFollowers
            ? Theme.of(context).primaryColor
            : ColorManager.blue,
        border: Border.all(
            color: Theme.of(context).bottomAppBarColor,
            width: isThatFollowers ? 1.0 : 0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: isItLoading
            ? CircularProgressIndicator(
                color: isThatFollowers
                    ? Theme.of(context).focusColor
                    : Theme.of(context).primaryColor,
                strokeWidth: 1,
              )
            : Text(
                text,
                style: TextStyle(
                    fontSize: 17.0,
                    color: isThatFollowers
                        ? Theme.of(context).focusColor
                        : ColorManager.white,
                    fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}

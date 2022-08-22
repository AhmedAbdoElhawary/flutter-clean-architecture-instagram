import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/pages/profile/user_profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/messages_w/chat_messages.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';

class ChattingPage extends StatefulWidget {
  final UserPersonalInfo? userInfo;
  final String userId;
  const ChattingPage({Key? key, this.userInfo, this.userId = ""})
      : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with TickerProviderStateMixin {
  final ValueNotifier<Message?> deleteThisMessage = ValueNotifier(null);

  final unSend = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return widget.userInfo != null
        ? scaffold(widget.userInfo!)
        : getUserInfo(context);
  }

  BlocBuilder<UserInfoCubit, UserInfoState> getUserInfo(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      bloc: UserInfoCubit.get(context)
        ..getUserInfo(widget.userId, isThatMyPersonalId: false),
      buildWhen: (previous, current) =>
          previous != current && current is CubitGettingChatUsersInfoLoaded,
      builder: (context, state) {
        if (state is CubitUserLoaded) {
          return scaffold(state.userPersonalInfo);
        } else if (state is CubitGetUserInfoFailed) {
          ToastShow.toast(state.error);
          return Center(child: Text(StringsManager.somethingWrong.tr));
        } else {
          return const ThineCircularProgress();
        }
      },
    );
  }

  Scaffold scaffold(UserPersonalInfo userInfo) {
    return Scaffold(
      appBar:
          isThatMobile ? CustomAppBar.chattingAppBar(userInfo, context) : null,
      body: GestureDetector(
          onTap: () {
            unSend.value = false;
            deleteThisMessage.value = null;
          },
          child: isThatMobile
              ? ChatMessages(userInfo: userInfo)
              : buildBodyForWeb(userInfo)),
    );
  }

  Widget buildBodyForWeb(UserPersonalInfo userInfo) {
    return Column(
      children: [
        buildUserInfo(userInfo),
        ChatMessages(userInfo: userInfo),
      ],
    );
  }

  Column buildUserInfo(UserPersonalInfo userInfo) {
    return Column(
      children: [
        circleAvatarOfImage(userInfo),
        const SizedBox(height: 10),
        nameOfUser(userInfo),
        const SizedBox(height: 5),
        userName(userInfo),
        const SizedBox(height: 5),
        someInfoOfUser(userInfo),
        viewProfileButton(userInfo),
      ],
    );
  }

  CircleAvatar circleAvatarOfImage(UserPersonalInfo userInfo) {
    return CircleAvatar(
      radius: 45,
      child: ClipOval(
        child: NetworkImageDisplay(
          imageUrl: userInfo.profileImageUrl,
          cachingWidth: 238,
          cachingHeight: 238,
        ),
      ),
    );
  }

  Row userName(UserPersonalInfo userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userInfo.userName,
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 14,
              fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "Instagram",
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 14,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Text nameOfUser(UserPersonalInfo userInfo) {
    return Text(
      userInfo.name,
      style: TextStyle(
          color: Theme.of(context).focusColor,
          fontSize: 16,
          fontWeight: FontWeight.w400),
    );
  }

  Row someInfoOfUser(UserPersonalInfo userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${userInfo.followerPeople.length} ${StringsManager.followers.tr}",
          style: TextStyle(
              color: Theme.of(context).textTheme.subtitle2!.color,
              fontSize: 13),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${userInfo.posts.length} ${StringsManager.posts.tr}",
          style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.subtitle2!.color),
        ),
      ],
    );
  }

  TextButton viewProfileButton(UserPersonalInfo userInfo) {
    return TextButton(
      onPressed: () {
        pushToPage(context, page: UserProfilePage(userId: userInfo.userId));
      },
      child: Text(StringsManager.viewProfile.tr,
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontWeight: FontWeight.normal)),
    );
  }
}

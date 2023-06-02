import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/entities/sender_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:instagram/presentation/pages/profile/user_profile_page.dart';
import 'package:instagram/presentation/pages/messages/widgets/chat_messages.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

class ChattingPage extends StatefulWidget {
  final SenderInfo? messageDetails;
  final String chatUid;
  final bool isThatGroup;

  const ChattingPage(
      {Key? key,
      this.messageDetails,
      this.chatUid = "",
      this.isThatGroup = false})
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
    return widget.messageDetails != null
        ? scaffold(widget.messageDetails!)
        : getUserInfo(context);
  }

  Widget getUserInfo(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: MessageCubit.get(context)
        ..getSpecificChatInfo(
            isThatGroup: widget.isThatGroup, chatUid: widget.chatUid),
      buildWhen: (previous, current) =>
          previous != current && current is GetSpecificChatLoaded,
      builder: (context, state) {
        if (state is GetSpecificChatLoaded) {
          return scaffold(state.coverMessageDetails);
        } else if (state is GetMessageFailed) {
          ToastShow.toast(state.error);

          return Scaffold(
              body: Center(child: Text(StringsManager.somethingWrong.tr)));
        } else {
          return const Scaffold(body: ThineCircularProgress());
        }
      },
    );
  }

  Scaffold scaffold(SenderInfo messageDetails) {
    return Scaffold(
      appBar: isThatMobile
          ? CustomAppBar.chattingAppBar(messageDetails.receiversInfo!, context)
          : null,
      body: GestureDetector(
          onTap: () {
            unSend.value = false;
            deleteThisMessage.value = null;
          },
          child: isThatMobile
              ? ChatMessages(messageDetails: messageDetails)
              : buildBodyForWeb(messageDetails)),
    );
  }

  Widget buildBodyForWeb(SenderInfo messageDetails) {
    return Column(
      children: [
        buildUserInfo(messageDetails.receiversInfo![0]),
        ChatMessages(messageDetails: messageDetails)
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

  Widget circleAvatarOfImage(UserPersonalInfo userInfo) {
    return CircleAvatarOfProfileImage(
      bodyHeight: 1000,
      userInfo: userInfo,
      showColorfulCircle: false,
      disablePressed: false,
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
              color: Theme.of(context).textTheme.titleSmall!.color,
              fontSize: 13),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${userInfo.posts.length} ${StringsManager.posts.tr}",
          style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.titleSmall!.color),
        ),
      ],
    );
  }

  TextButton viewProfileButton(UserPersonalInfo userInfo) {
    return TextButton(
      onPressed: () {
        Go(context).push(page: UserProfilePage(userId: userInfo.userId));
      },
      child: Text(StringsManager.viewProfile.tr,
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontWeight: FontWeight.normal)),
    );
  }
}

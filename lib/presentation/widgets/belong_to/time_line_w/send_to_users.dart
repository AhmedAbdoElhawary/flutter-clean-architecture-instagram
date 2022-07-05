import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';

class SendToUsers extends StatelessWidget {
  final ValueNotifier<bool> sendToUsers = ValueNotifier(false);
  UserPersonalInfo? selectedUserInfo;
  final List<UserPersonalInfo> globalUsersInfo = [];
  final TextEditingController messageTextController;
  final UserPersonalInfo userInfo;
  final Post postInfo;
  final VoidCallback clearTexts;
  SendToUsers(
      {Key? key,
      required this.userInfo,
      required this.clearTexts,
      required this.messageTextController,
      required this.postInfo})
      : super(key: key);
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
          return ValueListenableBuilder(
            valueListenable: sendToUsers,
            builder: (context, bool sendToUsersValue, child) => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      end: 20, start: 20, bottom: 60),
                  child: ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    itemBuilder: (context, index) {
                      if (!globalUsersInfo.contains(usersInfo[index])) {
                        globalUsersInfo.add(usersInfo[index]);
                      }
                      return buildUserInfo(
                        context,
                        globalUsersInfo[index],
                      );
                    },
                    itemCount: usersInfo.length,
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 15),
                  ),
                ),
                if (sendToUsersValue)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Builder(builder: (context) {
                      MessageCubit messageCubit = MessageCubit.get(context);

                      return ValueListenableBuilder(
                        valueListenable: sendToUsers,
                        builder: (context, bool sendToUsersValue, child) =>
                            InkWell(
                          onTap: () async {
                            if (sendToUsersValue) {
                              await messageCubit.sendMessage(
                                messageInfo: createSharedMessage(
                                    postInfo.blurHash, selectedUserInfo!),
                              );
                              if (messageTextController.text.isNotEmpty) {
                                messageCubit.sendMessage(
                                    messageInfo: createCaptionMessage(
                                        selectedUserInfo!));
                              }
                            }
                            Navigator.of(context).maybePop();
                            clearTexts();
                          },
                          child: buildDoneButton(),
                        ),
                      );
                    }),
                  ),
              ],
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

  Message createCaptionMessage(UserPersonalInfo userInfoWhoIShared) {
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: messageTextController.text,
      senderId: myPersonalId,
      blurHash: "",
      receiverId: userInfoWhoIShared.userId,
      isThatImage: false,
    );
  }

  Message createSharedMessage(
      String blurHash, UserPersonalInfo userInfoWhoIShared) {
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: postInfo.caption,
      senderId: myPersonalId,
      blurHash: blurHash,
      receiverId: userInfoWhoIShared.userId,
      isThatImage: true,
      postId: postInfo.postUid,
      imageUrl: postInfo.postUrl,
      isThatPost: true,
      profileImageUrl: userInfo.profileImageUrl,
      userNameOfSharedPost: userInfo.userName,
    );
  }

  Container buildDoneButton() {
    return Container(
      height: 50.0,
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
      decoration: const BoxDecoration(
        color: ColorManager.blue,
      ),
      child: const Center(
        child: Text(
          "Done",
          style: TextStyle(
              fontSize: 15.0,
              color: ColorManager.white,
              fontWeight: FontWeight.w500),
        ),
      ),
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
                size: 10,
              )
            : null,
        radius: 23,
      ),
      const SizedBox(width: 15),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userInfo.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              userInfo.userName,
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
      ValueListenableBuilder(
        valueListenable: sendToUsers,
        builder: (context, bool sendToUsersValue, child) => GestureDetector(
          onTap: () async {
            sendToUsers.value = !sendToUsers.value;
            if (!sendToUsersValue) {
              selectedUserInfo = userInfo;
            } else {
              selectedUserInfo = null;
            }
          },
          child: whichContainerOfText(context),
        ),
      ),
    ]);
  }

  Widget whichContainerOfText(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: sendToUsers,
      builder: (context, bool sendToUsersValue, child) {
        return !sendToUsersValue
            ? containerOfFollowText(context, StringsManager.send.tr())
            : containerOfFollowText(context, StringsManager.undo.tr());
      },
    );
  }

  Widget containerOfFollowText(BuildContext context, String text) {
    return ValueListenableBuilder(
      valueListenable: sendToUsers,
      builder: (context, bool sendToUsersValue, child) => Container(
        height: 30.0,
        padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
        decoration: BoxDecoration(
          color: sendToUsersValue
              ? Theme.of(context).primaryColor
              : ColorManager.blue,
          border: Border.all(
              color: sendToUsersValue
                  ? ColorManager.grey
                  : ColorManager.transparent),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 15.0,
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

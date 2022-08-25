import 'package:flutter/material.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';

class CustomShareButton extends StatefulWidget {
  final Post postInfo;
  final String textOfButton;
  final UserPersonalInfo publisherInfo;
  final TextEditingController messageTextController;
  final List<UserPersonalInfo> selectedUsersInfo;
  final ValueChanged<bool> clearTexts;
  const CustomShareButton({
    Key? key,
    required this.publisherInfo,
    required this.clearTexts,
    required this.textOfButton,
    required this.messageTextController,
    required this.selectedUsersInfo,
    required this.postInfo,
  }) : super(key: key);

  @override
  State<CustomShareButton> createState() => _CustomShareButtonState();
}

class _CustomShareButtonState extends State<CustomShareButton> {
  late UserPersonalInfo myPersonalInfo;

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Builder(builder: (context) {
        MessageCubit messageCubit = MessageCubit.get(context);
        return InkWell(
          onTap: () async {
            for (final selectedUser in widget.selectedUsersInfo) {
              await messageCubit.sendMessage(
                messageInfo:
                    createSharedMessage(widget.postInfo.blurHash, selectedUser),
              );
              if (widget.messageTextController.text.isNotEmpty) {
                messageCubit.sendMessage(
                    messageInfo: createCaptionMessage(selectedUser));
              }
            }
            if (!mounted) return;

            Navigator.of(context).maybePop();
            widget.clearTexts(true);
          },
          child: buildDoneButton(),
        );
      }),
    );
  }

  Message createCaptionMessage(UserPersonalInfo userInfoWhoIShared) {
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: widget.messageTextController.text,
      senderId: myPersonalId,
      blurHash: "",
      receiversIds: userInfoWhoIShared.userId,
      isThatImage: false,
    );
  }

  Message createSharedMessage(
      String blurHash, UserPersonalInfo userInfoWhoIShared) {
    String imageUrl = widget.postInfo.isThatImage
        ? widget.postInfo.imagesUrls.length > 1
            ? widget.postInfo.imagesUrls[0]
            : widget.postInfo.postUrl
        : widget.postInfo.coverOfVideoUrl;
    dynamic userId = userInfoWhoIShared.userId;
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: widget.postInfo.caption,
      senderId: myPersonalId,
      blurHash: blurHash,
      receiversIds: [userId],
      isThatImage: true,
      isThatVideo: !widget.postInfo.isThatImage,
      sharedPostId: widget.postInfo.postUid,
      imageUrl: imageUrl,
      isThatPost: true,
      ownerOfSharedPostId:widget.publisherInfo.userId ,
      multiImages: widget.postInfo.imagesUrls.length > 1,
    );
  }

  Container buildDoneButton() {
    return Container(
      height: 50.0,
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
      decoration: BoxDecoration(
        color: widget.selectedUsersInfo.isNotEmpty
            ? ColorManager.blue
            : ColorManager.lightBlue,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: Text(
          widget.textOfButton,
          style: const TextStyle(
              fontSize: 15.0,
              color: ColorManager.white,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

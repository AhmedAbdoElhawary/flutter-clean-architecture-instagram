import 'package:flutter/material.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';

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
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Builder(builder: (context) {
        MessageCubit messageCubit = MessageCubit.get(context);

        return InkWell(
          onTap: () async {
            for (final selectedUser in widget.selectedUsersInfo) {
              if (!widget.postInfo.isThatImage) {
                // q
              }
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
      receiverId: userInfoWhoIShared.userId,
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
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: widget.postInfo.caption,
      senderId: myPersonalId,
      blurHash: blurHash,
      receiverId: userInfoWhoIShared.userId,
      isThatImage: true,
      isThatVideo: !widget.postInfo.isThatImage,
      postId: widget.postInfo.postUid,
      imageUrl: imageUrl,
      isThatPost: true,
      profileImageUrl: widget.publisherInfo.profileImageUrl,
      multiImages: widget.postInfo.imagesUrls.length > 1,
      userNameOfSharedPost: widget.publisherInfo.name,
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

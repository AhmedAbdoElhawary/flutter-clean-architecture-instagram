import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/blur_hash.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/translations/app_lang.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/entities/sender_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/group_chat/message_for_group_chat_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:instagram/presentation/customPackages/audio_recorder/social_media_recoder.dart';
import 'package:instagram/presentation/pages/messages/widgets/chat_page_component/shared_message.dart';
import 'package:instagram/presentation/pages/messages/widgets/record_view.dart';
import 'package:instagram/presentation/pages/profile/user_profile_page.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_linears_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_memory_image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';

/// It's not clean enough
class ChatMessages extends StatefulWidget {
  final SenderInfo messageDetails;
  const ChatMessages({Key? key, required this.messageDetails})
      : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages>
    with TickerProviderStateMixin {
  final ValueNotifier<List<Message>> globalMessagesInfo = ValueNotifier([]);
  final ValueNotifier<int?> indexOfGarbageMessage = ValueNotifier(null);
  final ValueNotifier<Message?> deleteThisMessage = ValueNotifier(null);
  final ValueNotifier<Message?> newMessageInfo = ValueNotifier(null);
  final scrollControl = ScrollController();
  final _textController = ValueNotifier(TextEditingController());
  final isDeleteMessageDone = ValueNotifier(false);
  final isMessageLoaded = ValueNotifier(false);
  final appearIcons = ValueNotifier(true);
  final isSending = ValueNotifier(false);
  final unSend = ValueNotifier(false);
  final reLoad = ValueNotifier(false);
  late List<UserPersonalInfo> receiversInfo;
  final records = ValueNotifier('');
  late AnimationController _colorAnimationController;
  late Animation _colorTween;
  late UserPersonalInfo myPersonalInfo;
  String senderIdForGroup = "";
  String profileImageOfSender = "";
  int itemIndex = 0;
  bool isGroupIdEmpty = true;
  late bool isThatGroupChat;

  bool checkForSenderNameInGroup = false;
  AudioPlayer audioPlayer = AudioPlayer();
  int tempLengthOfRecord = 0;
  late SenderInfo messageDetails;
  Future<void> scrollToLastIndex(BuildContext context) async {
    try {
      await scrollControl.animateTo(scrollControl.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.easeInOutQuart);
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    indexOfGarbageMessage.dispose();
    deleteThisMessage.dispose();
    newMessageInfo.dispose();
    scrollControl.dispose();
    _textController.dispose();
    isDeleteMessageDone.dispose();
    isMessageLoaded.dispose();
    appearIcons.dispose();
    isSending.dispose();
    unSend.dispose();
    reLoad.dispose();
    records.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    resetValues();
    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _colorTween = ColorTween(begin: Colors.purple, end: Colors.blue)
        .animate(_colorAnimationController);
    super.initState();
  }

  resetValues() {
    messageDetails = widget.messageDetails;
    myPersonalInfo = UsersInfoReelTimeBloc.getMyInfoInReelTime(context) ??
        UserInfoCubit.getMyPersonalInfo(context);
    globalMessagesInfo.value = [];
    indexOfGarbageMessage.value = null;
    deleteThisMessage.value = null;
    newMessageInfo.value = null;
    _textController.value = TextEditingController();
    isDeleteMessageDone.value = false;
    isMessageLoaded.value = false;
    appearIcons.value = true;
    unSend.value = false;
    reLoad.value = false;
    records.value = '';
    senderIdForGroup = "";
    profileImageOfSender = "";
    itemIndex = 0;
    receiversInfo = messageDetails.receiversInfo ?? [myPersonalInfo];
    isGroupIdEmpty = messageDetails.lastMessage?.chatOfGroupId.isEmpty ?? true;
    isThatGroupChat = messageDetails.isThatGroupChat;
    audioPlayer = AudioPlayer();
    tempLengthOfRecord = 0;
  }

  @override
  void didUpdateWidget(ChatMessages oldWidget) {
    resetValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    bool check = (messageDetails.lastMessage?.isThatGroup) ?? false;
    return GestureDetector(
      onTap: () {
        deleteThisMessage.value = null;
        indexOfGarbageMessage.value = null;
        unSend.value = false;
      },
      child: messageDetails.isThatGroupChat || check
          ? buildGroupChat(context)
          : buildSingleChat(context),
    );
  }

  Widget buildGroupChat(BuildContext context) {
    if (messageDetails.lastMessage == null || isGroupIdEmpty) {
      return buildMessages(context, []);
    } else {
      return ValueListenableBuilder(
        valueListenable: reLoad,
        builder: (context, bool reLoadValue, child) =>
            BlocBuilder<MessageBloc, MessageBlocState>(
          bloc: BlocProvider.of<MessageBloc>(context)
            ..add(LoadMessagesForGroupChat(
                groupChatUid: messageDetails.lastMessage!.chatOfGroupId)),
          builder: (context, state) {
            if (state is MessageBlocLoaded) {
              return buildMessages(context, state.messages);
            } else {
              return isThatMobile
                  ? buildCircularProgress()
                  : const ThineLinearProgress();
            }
          },
        ),
      );
    }
  }

  Widget buildSingleChat(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: reLoad,
      builder: (context, bool reLoadValue, child) =>
          BlocBuilder<MessageBloc, MessageBlocState>(
        bloc: BlocProvider.of<MessageBloc>(context)
          ..add(LoadMessagesForSingleChat(receiversInfo[0].userId)),
        builder: (context, state) {
          if (state is MessageBlocLoaded) {
            return buildMessages(context, state.messages);
          } else {
            return isThatMobile
                ? buildCircularProgress()
                : const ThineLinearProgress();
          }
        },
      ),
    );
  }

  Widget buildMessages(BuildContext context, List<Message> messages) {
    return ValueListenableBuilder(
      valueListenable: newMessageInfo,
      builder: (context, Message? newMessageValue, child) =>
          ValueListenableBuilder(
        valueListenable: globalMessagesInfo,
        builder: (context, List<Message> globalMessagesValue, child) =>
            ValueListenableBuilder(
          valueListenable: isMessageLoaded,
          builder: (context, bool isMessageLoadedValue, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (messages.length >= globalMessagesValue.length) {
                globalMessagesInfo.value = messages;
                if (itemIndex < globalMessagesValue.length - 1 &&
                    isThatMobile) {
                  itemIndex = globalMessagesValue.length - 1;
                  scrollToLastIndex(context);
                }
              }
              if (newMessageValue != null && isMessageLoadedValue) {
                isMessageLoaded.value = false;
                globalMessagesInfo.value.add(newMessageValue);
                newMessageInfo.value = null;
              }
            });
            return whichListOfMessages(globalMessagesValue, context);
          },
        ),
      ),
    );
  }

  whichListOfMessages(List<Message> globalMessagesValue, BuildContext context) {
    return isThatMobile
        ? buildMassagesForMobile(globalMessagesValue, context)
        : buildMassagesForWeb(globalMessagesValue, context);
  }

  Widget buildMassagesForMobile(
      List<Message> globalMessagesValue, BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsetsDirectional.only(
                end: 10, start: 10, top: 10, bottom: 10),
            child: globalMessagesValue.isNotEmpty
                ? notificationListenerForMobile(globalMessagesValue)
                : buildUserInfo(context)),
        Align(
            alignment: Alignment.bottomCenter,
            child: fieldOfMessageForMobile()),
      ],
    );
  }

  Stack buildMassagesForWeb(
      List<Message> globalMessagesValue, BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsetsDirectional.only(
                end: 10, start: 10, top: 10, bottom: isThatMobile ? 10 : 25),
            child: listViewForWeb(globalMessagesValue)),
        Align(alignment: Alignment.bottomCenter, child: fieldOfMessageForWeb())
      ],
    );
  }

  Widget listViewForWeb(List<Message> globalMessagesValue) {
    return ListView.separated(
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              buildTheMessage(globalMessagesValue,
                  globalMessagesValue[index].datePublished, index),
              if (index == globalMessagesValue.length - 1)
                const SizedBox(height: 50),
            ],
          );
        },
        itemCount: globalMessagesValue.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 5));
  }

  Widget notificationListenerForMobile(List<Message> globalMessagesValue) {
    return ListView.separated(
        controller: scrollControl,
        itemBuilder: (context, index) {
          Message messageInfo = globalMessagesValue[index];
          bool isThatMe = messageInfo.senderId == myPersonalId;

          if (!isThatMe && senderIdForGroup != messageInfo.senderId) {
            senderIdForGroup = messageInfo.senderId;
            checkForSenderNameInGroup = true;
          } else {
            senderIdForGroup = "";
            checkForSenderNameInGroup = false;
          }
          int indexForMobile = index != 0 ? index - 1 : 0;
          return Column(
            children: [
              if (index == 0) buildUserInfo(context),
              buildTheMessage(globalMessagesValue,
                  globalMessagesValue[indexForMobile].datePublished, index),
              if (index == globalMessagesValue.length - 1)
                const SizedBox(height: 50),
            ],
          );
        },
        itemCount: globalMessagesValue.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 5));
  }

  Widget buildCircularProgress() => const ThineCircularProgress();

  Column buildUserInfo(BuildContext context) {
    return Column(
      children: [
        circleAvatarOfImage(),
        const SizedBox(height: 10),
        nameOfUser(),
        if (receiversInfo.length == 1) ...[
          const SizedBox(height: 5),
          userName(),
          const SizedBox(height: 5),
          someInfoOfUser(),
          viewProfileButton(context),
        ],
      ],
    );
  }

  Widget buildTheMessage(
      List<Message> messagesInfo, String previousDateOfMessage, int index) {
    Message messageInfo = messagesInfo[index];
    bool isThatMe = messageInfo.senderId == myPersonalId;

    String theDate = DateReformat.fullDigitsFormat(
        messageInfo.datePublished, previousDateOfMessage);
    bool isLangArabic = !AppLanguage.getInstance().isLangEnglish;

    return Column(
      children: [
        if (theDate.isNotEmpty)
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 15, top: 15),
              child: Text(
                theDate,
                style: getNormalStyle(color: Theme.of(context).hoverColor),
              ),
            ),
          ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isLangArabic) ...[buildSendLoadingIcon(messageInfo, true)],
            const SizedBox(width: 10),
            if (isThatMe) const SizedBox(width: 100),
            Expanded(
              child: GestureDetector(
                onLongPress: () {
                  deleteThisMessage.value = messageInfo;
                  indexOfGarbageMessage.value = index;
                  unSend.value = true;
                },
                child: ValueListenableBuilder(
                  valueListenable: newMessageInfo,
                  builder: (context, Message? newMessageInfoValue, child) =>
                      Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (checkForSenderNameInGroup) ...[
                        senderNameText(context, messageInfo),
                        const SizedBox(height: 5),
                      ],
                      isThatMobile
                          ? buildMessageForMobile(isThatMe, messageInfo)
                          : buildMessageForWeb(isThatMe, messageInfo),
                    ],
                  ),
                ),
              ),
            ),
            if (!isThatMe) const SizedBox(width: 85),
            if (!isLangArabic) ...[buildSendLoadingIcon(messageInfo, false)],
          ],
        ),
      ],
    );
  }

  Visibility buildSendLoadingIcon(Message messageInfo, bool rotateIcon) {
    return Visibility(
      visible: messageInfo.senderId == myPersonalId &&
          messageInfo.messageUid.isEmpty,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 5.0),
        child: rotateIcon
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: sendIcon(),
              )
            : sendIcon(),
      ),
    );
  }

  SvgPicture sendIcon() {
    return SvgPicture.asset(
      IconsAssets.send2Icon,
      height: 15,
      colorFilter:
          ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
    );
  }

  BlocBuilder<UserInfoCubit, UserInfoState> senderNameText(
      BuildContext context, Message messageInfo) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      buildWhen: (previous, current) =>
          previous != current && current is CubitUserLoaded,
      bloc: UserInfoCubit.get(context)
        ..getUserInfo(messageInfo.senderId, isThatMyPersonalId: false),
      builder: (context, state) {
        UserPersonalInfo? userInfo;
        if (state is CubitUserLoaded) userInfo = state.userPersonalInfo;
        return Text(userInfo?.name ?? "",
            style: getNormalStyle(color: ColorManager.grey));
      },
    );
  }

  Align buildMessageForMobile(bool isThatMe, Message messageInfo) {
    String message = messageInfo.message;
    String imageUrl = messageInfo.imageUrl;
    String recordedUrl = messageInfo.recordedUrl;
    Widget messageWidget =
        messageInfo.isThatRecord || messageInfo.recordedUrl.isNotEmpty
            ? recordMessage(messageInfo.lengthOfRecord, recordedUrl, isThatMe)
            : (messageInfo.isThatPost
                ? SharedMessage(messageInfo: messageInfo, isThatMe: isThatMe)
                : (messageInfo.isThatImage
                    ? imageMessage(messageInfo, imageUrl)
                    : textMessage(message, isThatMe)));
    return Align(
      alignment: isThatMe
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        decoration: BoxDecoration(
          color: messageInfo.isThatPost
              ? (Theme.of(context).textTheme.titleMedium?.color)
              : (isThatMe
                  ? _colorTween.value
                  : Theme.of(context).textTheme.titleMedium?.color),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(isThatMe ? 24 : 0),
            bottomEnd: Radius.circular(isThatMe ? 0 : 24),
            topStart: const Radius.circular(20),
            topEnd: const Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: !messageInfo.isThatImage
            ? const EdgeInsetsDirectional.only(
                start: 10, end: 10, bottom: 8, top: 8)
            : const EdgeInsetsDirectional.all(0),
        child: messageWidget,
      ),
    );
  }

  Align buildMessageForWeb(bool isThatMe, Message messageInfo) {
    String message = messageInfo.message;
    String imageUrl = messageInfo.imageUrl;
    String recordedUrl = messageInfo.recordedUrl;
    Widget messageWidget =
        messageInfo.isThatRecord || messageInfo.recordedUrl.isNotEmpty
            ? recordMessage(messageInfo.lengthOfRecord, recordedUrl, isThatMe)
            : (messageInfo.isThatPost
                ? SharedMessage(messageInfo: messageInfo, isThatMe: isThatMe)
                : (messageInfo.isThatImage
                    ? imageMessage(messageInfo, imageUrl)
                    : textMessage(message, isThatMe)));
    Widget child = buildMessage(isThatMe, messageInfo, messageWidget);

    return Align(
      alignment: isThatMe
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: child,
    );
  }

  Container buildMessage(
      bool isThatMe, Message messageInfo, Widget messageWidget) {
    return Container(
      decoration: BoxDecoration(
        color: isThatMe
            ? Theme.of(context).textTheme.titleMedium?.color
            : ColorManager.white,
        borderRadius: const BorderRadiusDirectional.all(Radius.circular(25)),
        border:
            isThatMe ? null : Border.all(color: ColorManager.lowOpacityGrey),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      padding: !messageInfo.isThatImage
          ? const EdgeInsets.symmetric(vertical: 15, horizontal: 25)
          : const EdgeInsetsDirectional.all(0),
      child: messageWidget,
    );
  }

  ValueListenableBuilder<String> recordMessage(
      int lengthOfRecord, String recordedUrl, bool isThatMe) {
    return ValueListenableBuilder(
      valueListenable: records,
      builder: (context, String recordsValue, child) => SizedBox(
        width: isThatMobile ? 500 : 240,
        child: RecordView(
          urlRecord: recordedUrl.isEmpty ? recordsValue : recordedUrl,
          isThatLocalRecorded: recordedUrl.isEmpty,
          lengthOfRecord:
              recordedUrl.isEmpty ? tempLengthOfRecord : lengthOfRecord,
          isThatMe: isThatMe,
        ),
      ),
    );
  }

  SizedBox imageMessage(Message messageInfo, String imageUrl) {
    return SizedBox(
      height: isThatMobile ? 180 : 300,
      width: isThatMobile ? 140 : 210,
      child: imageUrl.isNotEmpty
          ? Hero(
              tag: imageUrl,
              child: NetworkDisplay(
                blurHash: messageInfo.blurHash,
                isThatImage: messageInfo.isThatImage,
                url: imageUrl,
              ),
            )
          : ValueListenableBuilder(
              valueListenable: newMessageInfo,
              builder: (context, Message? newMessageValue, child) {
                Uint8List? image = newMessageValue?.localImage;
                return image != null
                    ? MemoryDisplay(imagePath: image)
                    : Container(color: ColorManager.purple);
              },
            ),
    );
  }

  Text textMessage(String message, bool isThatMe) {
    TextStyle style = isThatMe
        ? getNormalStyle(color: ColorManager.white)
        : getNormalStyle(color: Theme.of(context).focusColor);
    style = isThatMobile
        ? style
        : getNormalStyle(color: Theme.of(context).focusColor);
    return Text(message, style: style);
  }

  Widget fieldOfMessageForMobile() {
    return ValueListenableBuilder(
      valueListenable: unSend,
      builder: (context, bool unSendValue, child) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: unSendValue ? deleteTheMessage(unSendValue) : textForm(),
      ),
    );
  }

  Widget textForm() => Stack(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child:
                  Container(height: 25, color: Theme.of(context).primaryColor)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(35)),
              height: 50,
              padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
              margin: const EdgeInsetsDirectional.only(start: 10, end: 10),
              child: Builder(builder: (context) {
                MessageCubit messageCubit = MessageCubit.get(context);
                return rowOfTextField(messageCubit);
              }),
            ),
          ),
        ],
      );

  Widget fieldOfMessageForWeb() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 70,
          color: Theme.of(context).primaryColor,
          child: Center(
              child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.grey[300]!, width: 1)),
            height: 50,
            padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
            margin: const EdgeInsetsDirectional.only(start: 10, end: 10),
            child: Builder(builder: (context) {
              MessageCubit messageCubit = MessageCubit.get(context);
              return rowOfTextFieldForWeb(messageCubit);
            }),
          )),
        ));
  }

  Widget rowOfTextFieldForWeb(MessageCubit messageCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.favorite_border_rounded,
            size: 27, color: ColorManager.black),
        const SizedBox(width: 10),
        messageTextField(),
        ValueListenableBuilder(
          valueListenable: _textController,
          builder: (context, TextEditingController textValue, child) {
            if (textValue.text.isNotEmpty) {
              return sendButton(messageCubit, textValue);
            } else {
              return Row(
                children: [
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      pickPhoto(messageCubit),
                      const SizedBox(width: 10),
                      const Icon(Icons.favorite_border_rounded,
                          size: 27, color: ColorManager.black),
                    ],
                  ),
                ],
              );
            }
          },
        )
      ],
    );
  }

  Widget deleteTheMessage(bool unSendValue) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: deleteThisMessage,
          builder: (context, Message? messageValue, child) {
            bool isThatMe = messageValue?.senderId == myPersonalId;
            return ValueListenableBuilder(
              valueListenable: isDeleteMessageDone,
              builder: (context, bool messageDoneValue, child) =>
                  ValueListenableBuilder(
                valueListenable: indexOfGarbageMessage,
                builder: (context, int? indexOfGarbageMessageValue, child) =>
                    BlocBuilder<MessageCubit, MessageState>(
                  buildWhen: (previous, current) =>
                      previous != current && (current is DeleteMessageLoaded),
                  builder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (unSendValue &&
                          indexOfGarbageMessageValue != null &&
                          messageDoneValue) {
                        isDeleteMessageDone.value = false;
                        unSend.value = false;
                        deleteThisMessage.value = null;
                        globalMessagesInfo.value
                            .removeAt(indexOfGarbageMessageValue);
                      }
                    });

                    return Container(
                      height: 45,
                      color: Theme.of(context).primaryColor,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 80, end: 80),
                        child: Row(
                          mainAxisAlignment: isThatMe
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(StringsManager.reply.tr,
                                style: getBoldStyle(
                                    color: Theme.of(context).focusColor,
                                    fontSize: 15)),
                            if (isThatMe)
                              GestureDetector(
                                onTap: () async {
                                  Message? deleteMessage =
                                      deleteThisMessage.value;
                                  List<Message> globalMessages =
                                      globalMessagesInfo.value;

                                  if (deleteMessage != null) {
                                    isDeleteMessageDone.value = true;
                                    Message? replacedMessage;
                                    if (globalMessages.last.messageUid ==
                                        deleteMessage.messageUid) {
                                      int length = globalMessages.length;
                                      replacedMessage = length > 1
                                          ? globalMessages[length - 2]
                                          : null;
                                    }
                                    await MessageCubit.get(context)
                                        .deleteMessage(
                                            messageInfo: deleteMessage,
                                            replacedMessage: replacedMessage,
                                            isThatOnlyMessageInChat:
                                                globalMessages.length <= 1);
                                    globalMessages.remove(deleteMessage);
                                    reLoad.value = true;
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  StringsManager.unSend.tr,
                                  style: getBoldStyle(
                                      color: Theme.of(context).focusColor,
                                      fontSize: 15),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> showIcons(bool show) async {
    if (show) {
      await Future.delayed(const Duration(milliseconds: 500), () {});
    }
    appearIcons.value = show;
  }

  Widget rowOfTextField(MessageCubit messageCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        pickImageFromCamera(messageCubit),
        messageTextField(),
        ValueListenableBuilder(
          valueListenable: _textController,
          builder: (context, TextEditingController textValue, child) {
            if (textValue.text.isNotEmpty) {
              return sendButton(messageCubit, textValue);
            } else {
              return Row(
                children: [
                  const SizedBox(width: 10),
                  recordButton(context, messageCubit),
                  if (AppLanguage.getInstance().isLangEnglish) const SizedBox(width: 10),
                  ValueListenableBuilder(
                    valueListenable: appearIcons,
                    builder: (context, bool appearIconsValue, child) =>
                        Visibility(
                      visible: appearIconsValue,
                      child: Row(
                        children: [
                          pickPhoto(messageCubit),
                          const SizedBox(width: 15),
                          pickSticker(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        )
      ],
    );
  }

  SocialMediaRecorder recordButton(
      BuildContext context, MessageCubit messageCubit) {
    return SocialMediaRecorder(
      showIcons: showIcons,
      slideToCancelText: StringsManager.slideToCancel.tr,
      cancelText: StringsManager.cancel.tr,
      sendRequestFunction: (File soundFile, int lengthOfRecordInSecond) async {
        tempLengthOfRecord = lengthOfRecordInSecond * 1000000;
        records.value = soundFile.path;
        isMessageLoaded.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
        bool isThatGroup = messageDetails.lastMessage?.isThatGroup ?? false;

        if (messageDetails.isThatGroupChat || isThatGroup) {
          newMessageInfo.value = newMessageForGroup(isThatRecord: true);
          if (!mounted) return;

          await MessageForGroupChatCubit.get(context).sendMessage(
              messageInfo: newMessageForGroup(isThatRecord: true),
              recordFile: soundFile);
          if (!mounted) return;
          updateGroupChat();
        } else {
          newMessageInfo.value = newMessage(isThatRecord: true);

          await messageCubit.sendMessage(
              messageInfo: newMessage(isThatRecord: true),
              recordFile: soundFile);
        }
        newMessageInfo.value = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });

        if (!mounted) return;
        scrollToLastIndex(context);
        records.value = "";
        tempLengthOfRecord = 0;
      },
    );
  }

  updateGroupChat() {
    Message lastMessage = MessageForGroupChatCubit.getLastMessage(context);
    messageDetails.lastMessage = lastMessage;
    isGroupIdEmpty = messageDetails.lastMessage?.chatOfGroupId.isEmpty ?? true;
    myPersonalInfo = UsersInfoReelTimeBloc.getMyInfoInReelTime(context) ??
        UserInfoCubit.getMyPersonalInfo(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Widget pickImageFromCamera(MessageCubit messageCubit) {
    return ValueListenableBuilder(
      valueListenable: appearIcons,
      builder: (context, bool appearIconsValue, child) => Visibility(
        visible: appearIconsValue,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 10.0),
          child: GestureDetector(
            onTap: () async => onSelectImage(messageCubit, ImageSource.camera),
            child: const CircleAvatar(
              backgroundColor: ColorManager.darkBlue,
              radius: 18,
              child: ClipOval(
                clipBehavior: Clip.none,
                child: Icon(
                  Icons.camera_alt,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget messageTextField() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: appearIcons,
        builder: (context, bool appearIconsValue, child) => Visibility(
          visible: appearIconsValue,
          child: ValueListenableBuilder(
            valueListenable: _textController,
            builder: (context, TextEditingController textValue, child) =>
                TextFormField(
              style: Theme.of(context).textTheme.bodyLarge,
              keyboardType: TextInputType.multiline,
              cursorColor: ColorManager.teal,
              maxLines: null,
              decoration: InputDecoration.collapsed(
                  hintText: StringsManager.messageP.tr,
                  hintStyle: const TextStyle(color: ColorManager.grey)),
              autofocus: false,
              controller: textValue,
              onChanged: (e) => setState(() {}),
              cursorWidth: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget sendButton(
      MessageCubit messageCubit, TextEditingController textValue) {
    return ValueListenableBuilder(
      valueListenable: appearIcons,
      builder: (context, bool appearIconsValue, child) =>
          ValueListenableBuilder(
        valueListenable: isSending,
        builder: (context, bool isSendingValue, child) => Visibility(
          visible: appearIconsValue,
          child: GestureDetector(
            onTap: () async {
              if (isSendingValue) return;

              isSending.value = true;

              if (_textController.value.text.isNotEmpty) {
                bool isThatGroup =
                    messageDetails.lastMessage?.isThatGroup ?? false;

                if (messageDetails.isThatGroupChat || isThatGroup) {
                  await MessageForGroupChatCubit.get(context)
                      .sendMessage(messageInfo: newMessageForGroup());
                  if (!mounted) return;
                  updateGroupChat();
                } else {
                  messageCubit.sendMessage(messageInfo: newMessage());
                }
                if (!mounted) return;

                if (isThatMobile) scrollToLastIndex(context);
                _textController.value.text = "";
              }
              isSending.value = false;
            },
            child: Text(
              StringsManager.send.tr,
              style: getMediumStyle(
                color: textValue.text.isNotEmpty
                    ? const Color.fromARGB(255, 33, 150, 243)
                    : const Color.fromARGB(255, 147, 198, 246),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget pickSticker() {
    return GestureDetector(
      child: SvgPicture.asset(
        "assets/icons/sticker.svg",
        height: 25,
        colorFilter:
            ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
      ),
    );
  }

  Future<void> onSelectImage(
      MessageCubit messageCubit, ImageSource source) async {
    SelectedImagesDetails? pickImage =
        await CustomImagePickerPlus.pickImage(context, source: source);
    if (pickImage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => isMessageLoaded.value = true);
      });
      Uint8List byte = pickImage.selectedFiles[0].selectedByte;
      String blurHash = await CustomBlurHash.blurHashEncode(byte);
      if (!mounted) return;
      bool isThatGroup = messageDetails.lastMessage?.isThatGroup ?? false;

      if (messageDetails.isThatGroupChat || isThatGroup) {
        newMessageInfo.value =
            newMessageForGroup(blurHash: blurHash, isThatImage: true);
        newMessageInfo.value?.localImage = byte;

        await MessageForGroupChatCubit.get(context).sendMessage(
            messageInfo:
                newMessageForGroup(blurHash: blurHash, isThatImage: true),
            pathOfPhoto: byte);

        if (!mounted) return;
        updateGroupChat();
      } else {
        newMessageInfo.value =
            newMessage(blurHash: blurHash, isThatImage: true);
        newMessageInfo.value?.localImage = byte;
        messageCubit.sendMessage(
            messageInfo: newMessage(blurHash: blurHash, isThatImage: true),
            pathOfPhoto: byte);
      }

      if (!mounted) return;

      scrollToLastIndex(context);
    } else {
      ToastShow.toast(StringsManager.noImageSelected.tr);
    }
  }

  Widget pickPhoto(MessageCubit messageCubit) {
    return GestureDetector(
      onTap: () async => onSelectImage(messageCubit, ImageSource.gallery),
      child: SvgPicture.asset(
        isThatMobile ? IconsAssets.gallery : IconsAssets.galleryBold,
        height: isThatMobile ? 23 : 26,
        colorFilter:
            ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
      ),
    );
  }

  Message newMessageForGroup({
    String blurHash = "",
    bool isThatImage = false,
    bool isThatRecord = false,
  }) {
    List<dynamic> usersIds = [];
    for (final userInfo in receiversInfo) {
      usersIds.add(userInfo.userId);
    }
    return Message(
      datePublished: DateReformat.dateOfNow(),
      message: _textController.value.text,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      blurHash: blurHash,
      receiversIds: usersIds,
      isThatImage: isThatImage,
      isThatRecord: isThatRecord,
      lengthOfRecord: tempLengthOfRecord,
      isThatGroup: true,
      chatOfGroupId: messageDetails.lastMessage?.chatOfGroupId ?? "",
    );
  }

  Message newMessage(
      {String blurHash = "",
      bool isThatImage = false,
      bool isThatRecord = false}) {
    dynamic userId = receiversInfo[0].userId;
    return Message(
      datePublished: DateReformat.dateOfNow(),
      message: _textController.value.text,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      blurHash: blurHash,
      lengthOfRecord: tempLengthOfRecord,
      isThatRecord: isThatRecord,
      receiversIds: [userId],
      isThatImage: isThatImage,
    );
  }

  Widget circleAvatarOfImage() {
    bool check = messageDetails.lastMessage?.isThatGroup ?? false;
    if (messageDetails.isThatGroupChat || check) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 115,
              top: -18,
              child: CircleAvatarOfProfileImage(
                bodyHeight: 700,
                userInfo: receiversInfo[1],
                showColorfulCircle: false,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatarOfProfileImage(
                bodyHeight: 700,
                userInfo: receiversInfo[0],
                showColorfulCircle: false,
              ),
            ),
          ],
        ),
      );
    } else {
      return CircleAvatarOfProfileImage(
          userInfo: receiversInfo[0],
          bodyHeight: 950,
          showColorfulCircle: false);
    }
  }

  Row userName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          receiversInfo[0].userName,
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

  Widget nameOfUser() {
    int length = receiversInfo.length;
    length = length >= 3 ? 3 : length;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  index == 2
                      ? "....."
                      : "${receiversInfo[index].name}${length > 1 ? ',' : ""}",
                  style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Row someInfoOfUser() {
    UserPersonalInfo userInfo = receiversInfo[0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${userInfo.followerPeople.length} ${StringsManager.followers.tr}",
          style: const TextStyle(color: ColorManager.grey, fontSize: 13),
        ),
        const SizedBox(width: 15),
        Text(
          "${userInfo.posts.length} ${StringsManager.posts.tr}",
          style: const TextStyle(fontSize: 13, color: ColorManager.grey),
        ),
      ],
    );
  }

  TextButton viewProfileButton(BuildContext context) {
    dynamic userId = receiversInfo[0].userId;

    return TextButton(
      onPressed: () {
        Go(context).push(page: UserProfilePage(userId: userId));
      },
      child: Text(
        StringsManager.viewProfile.tr,
        style: TextStyle(
            color: Theme.of(context).focusColor, fontWeight: FontWeight.normal),
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/blur_hash.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/functions/image_picker.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/translations/app_lang.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:instagram/presentation/customPackages/audio_recorder/social_media_recoder.dart';
import 'package:instagram/presentation/pages/profile/user_profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/messages_w/chat_page_component/shared_message.dart';
import 'package:instagram/presentation/widgets/belong_to/messages_w/record_view.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_linears_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatMessages extends StatefulWidget {
  final UserPersonalInfo userInfo;

  const ChatMessages({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages>
    with TickerProviderStateMixin {
  final ValueNotifier<List<Message>> globalMessagesInfo = ValueNotifier([]);
  final ValueNotifier<int?> indexOfGarbageMessage = ValueNotifier(null);
  final ValueNotifier<Message?> deleteThisMessage = ValueNotifier(null);
  final ValueNotifier<Message?> newMessageInfo = ValueNotifier(null);
  final itemScrollController = ValueNotifier(ItemScrollController());
  final _textController = ValueNotifier(TextEditingController());
  final isDeleteMessageDone = ValueNotifier(false);
  final isMessageLoaded = ValueNotifier(false);
  final appearIcons = ValueNotifier(true);
  final unSend = ValueNotifier(false);
  final records = ValueNotifier('');
  late AnimationController _colorAnimationController;
  late Animation _colorTween;
  int itemIndex = 0;

  Future<void> scrollToLastIndex(BuildContext context) async {
    if (globalMessagesInfo.value.length > 1) {
      itemScrollController.value.scrollTo(
          index: globalMessagesInfo.value.length - 1,
          alignment: 0.2,
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeInOutQuint);
    }
  }

  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _colorTween = ColorTween(begin: Colors.purple, end: Colors.blue)
        .animate(_colorAnimationController);
    super.initState();
  }

  @override
  void didUpdateWidget(ChatMessages oldWidget) {
    if (widget.userInfo != oldWidget.userInfo) {
      newMessageInfo.value = null;
      globalMessagesInfo.value.clear();
      isMessageLoaded.value = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: newMessageInfo,
      builder: (context, Message? newMessageValue, child) =>
          ValueListenableBuilder(
        valueListenable: globalMessagesInfo,
        builder: (context, List<Message> globalMessagesValue, child) =>
            ValueListenableBuilder(
          valueListenable: isMessageLoaded,
          builder: (context, bool isMessageLoadedValue, child) =>
              BlocBuilder<MessageBloc, MessageBlocState>(
                  bloc: BlocProvider.of<MessageBloc>(context)
                    ..add(LoadMessages(widget.userInfo.userId)),
                  buildWhen: (previous, current) =>
                      previous != current && (current is MessageBlocLoaded),
                  builder: (context, state) {
                    if (state is MessageBlocLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (state.messages.length >=
                            globalMessagesValue.length) {
                          globalMessagesInfo.value = state.messages;
                          if (itemIndex < globalMessagesValue.length - 1 &&
                              isThatMobile) {
                            itemIndex = globalMessagesValue.length - 1;
                            scrollToLastIndex(context);
                          }
                        }
                        if (newMessageValue != null && isMessageLoadedValue) {
                          isMessageLoaded.value = false;
                          globalMessagesInfo.value.add(newMessageValue);
                        }
                      });
                      return whichListOfMessages(globalMessagesValue, context);
                    } else {
                      return isThatMobile
                          ? buildCircularProgress()
                          : const ThineLinearProgress();
                    }
                  }),
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
              buildTheMessage(globalMessagesValue[index],
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

  NotificationListener<ScrollNotification> notificationListenerForMobile(
      List<Message> globalMessagesValue) {
    return NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: ValueListenableBuilder(
          valueListenable: itemScrollController,
          builder: (context, ItemScrollController itemScrollValue, child) =>
              ScrollablePositionedList.separated(
                  itemScrollController: itemScrollValue,
                  itemBuilder: (context, index) {
                    int indexForMobile = index != 0 ? index - 1 : 0;
                    return Column(
                      children: [
                        if (index == 0) buildUserInfo(context),
                        buildTheMessage(
                            globalMessagesValue[index],
                            globalMessagesValue[indexForMobile].datePublished,
                            index),
                        if (index == globalMessagesValue.length - 1)
                          const SizedBox(height: 50),
                      ],
                    );
                  },
                  itemCount: globalMessagesValue.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 5)),
        ));
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);
      return true;
    }
    return false;
  }

  Widget buildCircularProgress() => const ThineCircularProgress();

  Column buildUserInfo(BuildContext context) {
    return Column(
      children: [
        circleAvatarOfImage(),
        const SizedBox(height: 10),
        nameOfUser(),
        const SizedBox(height: 5),
        userName(),
        const SizedBox(height: 5),
        someInfoOfUser(),
        viewProfileButton(context),
      ],
    );
  }

  Widget buildTheMessage(
      Message messageInfo, String previousDateOfMessage, int index) {
    bool isThatMine = false;
    if (messageInfo.senderId == myPersonalId) isThatMine = true;
    String theDate = DateOfNow.chattingDateOfNow(
        messageInfo.datePublished, previousDateOfMessage);
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
              )),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isThatMine && !isThatMobile) ...[
              CircleAvatarOfProfileImage(
                bodyHeight: 350,
                userInfo: widget.userInfo,
                showColorfulCircle: false,
              ),
              const SizedBox(width: 10),
            ],
            if (isThatMine) const SizedBox(width: 100),
            Expanded(
              child: GestureDetector(
                onLongPress: () {
                  deleteThisMessage.value = messageInfo;
                  indexOfGarbageMessage.value = index;
                  unSend.value = true;
                },
                child: isThatMobile
                    ? buildMessageForMobile(isThatMine, messageInfo)
                    : buildMessageForWeb(isThatMine, messageInfo),
              ),
            ),
            if (!isThatMine) const SizedBox(width: 100),
            Visibility(
                visible: messageInfo.messageUid.isEmpty,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 5.0),
                  child: SvgPicture.asset(
                    IconsAssets.send2Icon,
                    height: 15,
                    color: Theme.of(context).focusColor,
                  ),
                )),
          ],
        ),
      ],
    );
  }

  Align buildMessageForMobile(bool isThatMine, Message messageInfo) {
    String message = messageInfo.message;
    String imageUrl = messageInfo.imageUrl;
    String recordedUrl = messageInfo.recordedUrl;
    Widget messageWidget = messageInfo.recordedUrl.isNotEmpty
        ? recordMessage(recordedUrl, isThatMine)
        : (messageInfo.isThatPost
            ? SharedMessage(
                messageInfo: messageInfo,
                isThatMine: isThatMine,
              )
            : (messageInfo.isThatImage
                ? imageMessage(messageInfo, imageUrl)
                : textMessage(message, isThatMine)));
    return Align(
      alignment: isThatMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (_, __) => Container(
                decoration: BoxDecoration(
                  color: messageInfo.isThatPost
                      ? (Theme.of(context).textTheme.subtitle1!.color)
                      : (isThatMine
                          ? _colorTween.value
                          : Theme.of(context).textTheme.subtitle1!.color),
                  borderRadius: BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(isThatMine ? 20 : 0),
                    bottomEnd: Radius.circular(isThatMine ? 0 : 20),
                    topStart: const Radius.circular(20),
                    topEnd: const Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                padding: imageUrl.isEmpty
                    ? const EdgeInsetsDirectional.only(
                        start: 10, end: 10, bottom: 8, top: 8)
                    : const EdgeInsetsDirectional.all(0),
                child: messageWidget,
              )),
    );
  }

  Align buildMessageForWeb(bool isThatMine, Message messageInfo) {
    String message = messageInfo.message;
    String imageUrl = messageInfo.imageUrl;
    String recordedUrl = messageInfo.recordedUrl;
    Widget messageWidget = messageInfo.recordedUrl.isNotEmpty
        ? recordMessage(recordedUrl, isThatMine)
        : (messageInfo.isThatPost
            ? SharedMessage(
                messageInfo: messageInfo,
                isThatMine: isThatMine,
              )
            : (messageInfo.isThatImage
                ? imageMessage(messageInfo, imageUrl)
                : textMessage(message, isThatMine)));
    return Align(
      alignment: isThatMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        decoration: BoxDecoration(
          color: isThatMine
              ? Theme.of(context).textTheme.subtitle1!.color
              : ColorManager.white,
          borderRadius: const BorderRadiusDirectional.all(Radius.circular(25)),
          border: isThatMine
              ? null
              : Border.all(color: ColorManager.lowOpacityGrey),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: imageUrl.isEmpty
            ? const EdgeInsets.symmetric(vertical: 15, horizontal: 25)
            : const EdgeInsetsDirectional.all(0),
        child: messageWidget,
      ),
    );
  }

  ValueListenableBuilder<String> recordMessage(
      String recordedUrl, bool isThatMine) {
    return ValueListenableBuilder(
      valueListenable: records,
      builder: (context, String recordsValue, child) => SizedBox(
        width: isThatMobile ? null : 240,
        child: RecordView(
          urlRecord: recordedUrl.isEmpty ? recordsValue : recordedUrl,
          isThatMine: isThatMine,
        ),
      ),
    );
  }

  SizedBox imageMessage(Message messageInfo, String imageUrl) {
    return SizedBox(
      height: isThatMobile ? 150 : 300,
      width: isThatMobile ? 90 : 210,
      child: messageInfo.messageUid.isNotEmpty
          ? Hero(
              tag: imageUrl,
              child: NetworkImageDisplay(
                blurHash: messageInfo.blurHash,
                imageUrl: imageUrl,
              ),
            )
          : ValueListenableBuilder(
              valueListenable: newMessageInfo,
              builder: (context, Message? newMessageValue, child) =>
                  Image.memory(newMessageValue!.localImage!, fit: BoxFit.cover),
            ),
    );
  }

  Text textMessage(String message, bool isThatMine) {
    TextStyle style = isThatMine
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

  ValueListenableBuilder<Message?> deleteTheMessage(bool unSendValue) {
    return ValueListenableBuilder(
      valueListenable: deleteThisMessage,
      builder: (context, Message? messageValue, child) {
        bool isThatMine = messageValue!.senderId == myPersonalId;
        return ValueListenableBuilder(
          valueListenable: isDeleteMessageDone,
          builder: (context, bool messageDoneValue, child) =>
              ValueListenableBuilder(
            valueListenable: indexOfGarbageMessage,
            builder: (context, int? indexOfGarbageMessageValue, child) =>
                BlocBuilder<MessageCubit, MessageState>(
              buildWhen: (previous, current) {
                if (previous != current && (current is DeleteMessageLoaded)) {
                  return true;
                }
                return false;
              },
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
                    padding:
                        const EdgeInsetsDirectional.only(start: 80, end: 80),
                    child: Row(
                        mainAxisAlignment: isThatMine
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(StringsManager.reply.tr,
                              style: getBoldStyle(
                                  color: Theme.of(context).focusColor,
                                  fontSize: 15)),
                          if (isThatMine)
                            GestureDetector(
                                onTap: () async {
                                  if (deleteThisMessage.value != null) {
                                    isDeleteMessageDone.value = true;
                                    Message? replacedMessage;
                                    if (globalMessagesInfo
                                            .value.last.messageUid ==
                                        deleteThisMessage.value!.messageUid) {
                                      replacedMessage = globalMessagesInfo
                                              .value[
                                          globalMessagesInfo.value.length - 2];
                                    }
                                    MessageCubit.get(context).deleteMessage(
                                        messageInfo: deleteThisMessage.value!,
                                        replacedMessage: replacedMessage);
                                  }
                                },
                                child: Text(StringsManager.unSend.tr,
                                    style: getBoldStyle(
                                        color: Theme.of(context).focusColor,
                                        fontSize: 15))),
                        ]),
                  ),
                );
              },
            ),
          ),
        );
      },
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
              return GetBuilder<AppLanguage>(
                  init: AppLanguage(),
                  builder: (controller) {
                    return Row(
                      children: [
                        const SizedBox(width: 10),
                        SocialMediaRecorder(
                          showIcons: showIcons,
                          slideToCancelText: StringsManager.slideToCancel.tr,
                          cancelText: StringsManager.cancel.tr,
                          sendRequestFunction: (File soundFile) async {
                            records.value = soundFile.path;
                            MessageCubit messageCubit =
                                MessageCubit.get(context);
                            newMessageInfo.value = newMessage();
                            isMessageLoaded.value = true;
                            await messageCubit.sendMessage(
                                messageInfo: newMessage(),
                                recordFile: soundFile);
                            newMessageInfo.value = null;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {});
                            });

                            if (!mounted) return;
                            scrollToLastIndex(context);
                          },
                        ),
                        if (controller.appLocale == 'en')
                          const SizedBox(width: 10),
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
                  });
            }
          },
        )
      ],
    );
  }

  Widget pickImageFromCamera(MessageCubit messageCubit) {
    return ValueListenableBuilder(
        valueListenable: appearIcons,
        builder: (context, bool appearIconsValue, child) => Visibility(
              visible: appearIconsValue,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 10.0),
                child: GestureDetector(
                  onTap: () async {
                    Uint8List? pickImage = await imageCameraPicker();
                    if (pickImage != null) {
                      isMessageLoaded.value = true;
                      String blurHash = await blurHashEncode(pickImage);

                      newMessageInfo.value =
                          newMessage(blurHash: blurHash, isThatImage: true);
                      newMessageInfo.value!.localImage = pickImage;
                      messageCubit.sendMessage(
                          messageInfo:
                              newMessage(blurHash: blurHash, isThatImage: true),
                          pathOfPhoto: pickImage);
                      if (!mounted) return;

                      scrollToLastIndex(context);
                    } else {
                      ToastShow.toast(StringsManager.noImageSelected.tr);
                    }
                  },
                  child: const CircleAvatar(
                      backgroundColor: ColorManager.darkBlue,
                      radius: 18,
                      child: ClipOval(
                          child: Icon(
                        Icons.camera_alt,
                        color: ColorManager.white,
                      ))),
                ),
              ),
            ));
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
              style: Theme.of(context).textTheme.bodyText1,
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
      builder: (context, bool appearIconsValue, child) => Visibility(
        visible: appearIconsValue,
        child: GestureDetector(
          onTap: () {
            if (_textController.value.text.isNotEmpty) {
              messageCubit.sendMessage(
                messageInfo: newMessage(),
              );
              if (isThatMobile) scrollToLastIndex(context);
              _textController.value.text = "";
            }
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
    );
  }

  Widget pickSticker() {
    return GestureDetector(
      child: SvgPicture.asset(
        "assets/icons/sticker.svg",
        height: 25,
        color: Theme.of(context).focusColor,
      ),
    );
  }

  Widget pickPhoto(MessageCubit messageCubit) {
    return GestureDetector(
      onTap: () async {
        Uint8List? pickImage = await imageGalleryPicker();
        if (pickImage != null) {
          isMessageLoaded.value = true;
          String blurHash = await blurHashEncode(pickImage);
          newMessageInfo.value =
              newMessage(blurHash: blurHash, isThatImage: true);
          newMessageInfo.value!.localImage = pickImage;

          messageCubit.sendMessage(
              messageInfo: newMessage(blurHash: blurHash, isThatImage: true),
              pathOfPhoto: pickImage);
          if (!mounted) return;

          scrollToLastIndex(context);
        } else {
          ToastShow.toast(StringsManager.noImageSelected.tr);
        }
      },
      child: SvgPicture.asset(
        isThatMobile ? IconsAssets.gallery : IconsAssets.galleryBold,
        height: isThatMobile ? 23 : 26,
        color: Theme.of(context).focusColor,
      ),
    );
  }

  Message newMessage({String blurHash = "", bool isThatImage = false}) {
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: _textController.value.text,
      senderId: myPersonalId,
      blurHash: blurHash,
      receiverId: widget.userInfo.userId,
      isThatImage: isThatImage,
    );
  }

  CircleAvatar circleAvatarOfImage() {
    return CircleAvatar(
        radius: 45,
        child: ClipOval(
            child: NetworkImageDisplay(
          imageUrl: widget.userInfo.profileImageUrl,
        )));
  }

  Row userName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.userInfo.userName,
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

  Text nameOfUser() {
    return Text(
      widget.userInfo.name,
      style: TextStyle(
          color: Theme.of(context).focusColor,
          fontSize: 16,
          fontWeight: FontWeight.w400),
    );
  }

  Row someInfoOfUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${widget.userInfo.followerPeople.length} ${StringsManager.followers.tr}",
          style: TextStyle(
              color: Theme.of(context).textTheme.subtitle2!.color,
              fontSize: 13),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${widget.userInfo.posts.length} ${StringsManager.posts.tr}",
          style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.subtitle2!.color),
        ),
      ],
    );
  }

  TextButton viewProfileButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        pushToPage(context,
            page: UserProfilePage(userId: widget.userInfo.userId));
      },
      child: Text(StringsManager.viewProfile.tr,
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontWeight: FontWeight.normal)),
    );
  }
}

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/core/functions/date_of_now.dart';
import 'package:instegram/core/functions/image_picker.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/bloc/massage_bloc.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/cubit/massage_cubit.dart';
import 'package:instegram/presentation/widgets/audio_recorder_view.dart';
import 'package:instegram/presentation/widgets/custom_circular_progress.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';
import 'package:instegram/presentation/widgets/record_view.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import 'package:instegram/presentation/widgets/user_profile_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChattingPage extends StatefulWidget {
  final UserPersonalInfo userInfo;
  ChattingPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _textController = TextEditingController();
  final itemScrollController = ItemScrollController();
  List<Massage> globalMassagesInfo = [];
  Massage? newMassageInfo;
  bool isMassageLoaded = false;

  late Directory appDirectory;
  String records = '';
  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records = onData.path;
      }).onDone(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDirectory.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: buildBody(context),
    );
  }

  BlocBuilder<MassageBloc, MassageBlocState> buildBody(BuildContext context) {
    return BlocBuilder<MassageBloc, MassageBlocState>(
        bloc: BlocProvider.of<MassageBloc>(context)
          ..add(LoadMassages(widget.userInfo.userId)),
        buildWhen: (previous, current) {
          if (previous != current && (current is MassageBlocLoaded)) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is MassageBlocLoaded) {
            if (state.massages.length >= globalMassagesInfo.length) {
              globalMassagesInfo = state.massages;
            }
            if (newMassageInfo != null && isMassageLoaded) {
              isMassageLoaded = false;
              globalMassagesInfo.add(newMassageInfo!);
            }
            return Padding(
              padding: const EdgeInsetsDirectional.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: globalMassagesInfo.isNotEmpty
                        ? ScrollablePositionedList.separated(
                        itemScrollController: itemScrollController,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              if (index == 0) buildUserInfo(context),
                              // if (index > 0)
                              buildTheMassage(
                                  globalMassagesInfo[index],
                                  globalMassagesInfo[
                                  index != 0 ? index - 1 : 0]
                                      .datePublished),
                              if (index == globalMassagesInfo.length - 1)
                                const SizedBox(height: 10),
                            ],
                          );
                        },
                        itemCount: globalMassagesInfo.length,
                        separatorBuilder:
                            (BuildContext context, int index) =>
                        const SizedBox(height: 5))
                        : buildUserInfo(context),
                  ),
                  if (!unSend) fieldOfMassage(),
                ],
              ),
            );
          } else {
            return buildCircularProgress();
          }
        });
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

  Massage? deleteThisMassage;
  Widget buildTheMassage(Massage massageInfo, String previousDateOfMassage) {
    bool isThatMine = false;
    if (massageInfo.senderId == myPersonalId) isThatMine = true;
    String theDate = DateOfNow.chattingDateOfNow(
        massageInfo.datePublished, previousDateOfMassage);
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
            if (isThatMine) const SizedBox(width: 100),
            Expanded(
              child: GestureDetector(
                onLongPress: () {
                  setState(() {
                    deleteThisMassage = massageInfo;
                    unSend = true;
                  });
                },
                child: buildMassage(isThatMine, massageInfo),
              ),
            ),
            if (!isThatMine) const SizedBox(width: 100),
            Visibility(
                visible: massageInfo.massageUid.isEmpty,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 5.0),
                  child: SvgPicture.asset(
                    "assets/icons/paper_plane_right.svg",
                    height: 15,
                    color: Theme.of(context).focusColor,
                  ),
                )),
          ],
        ),
      ],
    );
  }

  bool unSend = false;
  Align buildMassage(bool isThatMine, Massage massageInfo) {
    String massage = massageInfo.massage;
    String imageUrl = massageInfo.imageUrl;
    String recordedUrl = massageInfo.recordedUrl;
    return Align(
      alignment: isThatMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        decoration: BoxDecoration(
            color: isThatMine
                ? ColorManager.blue
                : Theme.of(context).selectedRowColor,
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(isThatMine ? 20 : 0),
              bottomEnd: Radius.circular(isThatMine ? 0 : 20),
              topStart: const Radius.circular(20),
              topEnd: const Radius.circular(20),
            )),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: imageUrl.isEmpty
            ? const EdgeInsetsDirectional.only(
            start: 10, end: 10, bottom: 8, top: 8)
            : const EdgeInsetsDirectional.all(0),
        child: massage.isNotEmpty
            ? Text(massage, style: Theme.of(context).textTheme.bodyText1)
            : (massageInfo.isThatImage
            ? SizedBox(
            width: 90,
            height: 150,
            child: massageInfo.massageUid.isNotEmpty
                ? CustomFadeInImage(
              imageUrl: imageUrl,
            )
                : Image.asset(imageUrl, fit: BoxFit.cover))
            : SizedBox(
            child: RecordView(
              record: recordedUrl.isEmpty ? records : recordedUrl,isThatMine:isThatMine,
            ))),
      ),
    );
  }

  _onRecordComplete() {
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records = onData.path;
    }).onDone(() async {
      setState(() {});
      MassageCubit massageCubit = MassageCubit.get(context);
      newMassageInfo = newMassage();
      isMassageLoaded = true;
      massageCubit.sendMassage(
          massageInfo: newMassage(), pathOfRecorded: records);
    });
  }

  Widget fieldOfMassage() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: unSend
          ? deleteTheMassage()
          : Container(
        decoration: BoxDecoration(
            color: Theme.of(context).selectedRowColor,
            borderRadius: BorderRadius.circular(35)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 50,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
          child: Builder(builder: (context) {
            MassageCubit massageCubit = MassageCubit.get(context);
            return rowOfTextField(massageCubit);
          }),
        ),
      ),
    );
  }

  Container deleteTheMassage() {
    return Container(
      height: 60,
      color: ColorManager.lowOpacityGrey,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 80, end: 80),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(StringsManager.reply.tr(),
              style: getBoldStyle(
                  color: Theme.of(context).focusColor, fontSize: 15)),
          GestureDetector(
              onTap: () {
                // massageCubit.
              },
              child: Text(StringsManager.unSend.tr(),
                  style: getBoldStyle(
                      color: Theme.of(context).focusColor, fontSize: 15))),
        ]),
      ),
    );
  }

  Row rowOfTextField(MassageCubit massageCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        pickImageFromCamera(massageCubit),
        const SizedBox(width: 10.0),
        massageTextField(),
        if (_textController.text.isNotEmpty) sendButton(massageCubit),
        if (_textController.text.isEmpty)
          Row(
            children: [
              const SizedBox(width: 10),
              RecorderView(
                  onSaved: _onRecordComplete,
                  icon: SvgPicture.asset(
                    "assets/icons/microphone.svg",
                    height: 25,
                    color: Theme.of(context).focusColor,
                  )),
              const SizedBox(width: 10),
              pickPhoto(massageCubit),
              const SizedBox(width: 10),
              pickSticker(),
            ],
          )
      ],
    );
  }

  GestureDetector pickImageFromCamera(MassageCubit massageCubit) {
    return GestureDetector(
      onTap: () async {
        File? pickImage = await imageCameraPicker();
        if (pickImage != null) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            setState(() {
              isMassageLoaded = true;
              newMassageInfo = newMassage(isThatImage: true);
              newMassageInfo!.imageUrl = pickImage.path;
            });
          });
          massageCubit.sendMassage(
              massageInfo: newMassage(isThatImage: true),
              pathOfPhoto: pickImage.path);
        } else {
          ToastShow.toast(StringsManager.noImageSelected.tr());
        }
      },
      child: CircleAvatar(
          backgroundColor: ColorManager.darkBlue,
          child: ClipOval(
              child: Icon(
                Icons.camera_alt,
                color: Theme.of(context).focusColor,
              )),
          radius: 18),
    );
  }

  Expanded massageTextField() {
    return Expanded(
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyText1,
        keyboardType: TextInputType.multiline,
        cursorColor: ColorManager.teal,
        maxLines: null,
        decoration: InputDecoration.collapsed(
            hintText: StringsManager.massageP.tr(),
            hintStyle: TextStyle(color: Theme.of(context).cardColor)),
        autofocus: false,
        controller: _textController,
        cursorWidth: 1.5,
        onChanged: (e) {
          setState(() {
            _textController;
          });
        },
      ),
    );
  }

  GestureDetector sendButton(MassageCubit massageCubit) {
    return GestureDetector(
      onTap: () {
        // if (_textController.text.isNotEmpty) {
        massageCubit.sendMassage(
          massageInfo: newMassage(),
        );
        _textController.text = "";
        // }
      },
      child: Text(
        StringsManager.send.tr(),
        style: getMediumStyle(
          color: _textController.text.isNotEmpty
              ? const Color.fromARGB(255, 33, 150, 243)
              : const Color.fromARGB(255, 147, 198, 246),
        ),
      ),
    );
  }

  GestureDetector pickSticker() {
    return GestureDetector(
      onTap: () {},
      child: SvgPicture.asset(
        "assets/icons/sticker.svg",
        height: 25,
        color: Theme.of(context).focusColor,
      ),
    );
  }

  GestureDetector pickPhoto(MassageCubit massageCubit) {
    return GestureDetector(
      onTap: () async {
        File? pickImage = await imageGalleryPicker();
        if (pickImage != null) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            setState(() {
              isMassageLoaded = true;
              newMassageInfo = newMassage(isThatImage: true);
              newMassageInfo!.imageUrl = pickImage.path;
            });
          });
          massageCubit.sendMassage(
              massageInfo: newMassage(isThatImage: true),
              pathOfPhoto: pickImage.path);
          // setState(() {
          //   isImageUpload = true;
          // });
        } else {
          ToastShow.toast(StringsManager.noImageSelected.tr());
        }
      },
      child: SvgPicture.asset(
        "assets/icons/gallery.svg",
        height: 23,
        color: Theme.of(context).focusColor,
      ),
    );
  }

  Massage newMassage({bool isThatImage = false}) {
    return Massage(
      datePublished: DateOfNow.dateOfNow(),
      massage: _textController.text,
      senderId: myPersonalId,
      receiverId: widget.userInfo.userId,
      isThatImage: isThatImage,
    );
  }

  CircleAvatar circleAvatarOfImage() {
    return CircleAvatar(
        child: ClipOval(
            child: CustomFadeInImage(
              imageUrl: widget.userInfo.profileImageUrl,
            )),
        radius: 45);
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
          "${widget.userInfo.followerPeople.length} ${StringsManager.followers.tr()}",
          style: TextStyle(
              color: Theme.of(context).bottomAppBarColor, fontSize: 13),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${widget.userInfo.posts.length} ${StringsManager.posts.tr()}",
          style: TextStyle(
              fontSize: 13, color: Theme.of(context).bottomAppBarColor),
        ),
      ],
    );
  }

  TextButton viewProfileButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(CupertinoPageRoute(
          builder: (context) => UserProfilePage(
            userId: widget.userInfo.userId,
          ),
          maintainState: false,
        ));
      },
      child: Text(StringsManager.viewProfile.tr(),
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontWeight: FontWeight.normal)),
    );
  }

  AppBar appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        children: [
          CircleAvatar(
              child: ClipOval(
                  child: CustomFadeInImage(
                    imageUrl: widget.userInfo.profileImageUrl,
                  )),
              radius: 17),
          const SizedBox(
            width: 15,
          ),
          Text(
            widget.userInfo.name,
            style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          )
        ],
      ),
      actions: [
        SvgPicture.asset(
          "assets/icons/phone.svg",
          height: 27,
          color: Theme.of(context).focusColor,
        ),
        const SizedBox(
          width: 20,
        ),
        SvgPicture.asset(
          "assets/icons/video_point.svg",
          height: 25,
          color: Theme.of(context).focusColor,
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}

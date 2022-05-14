import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/functions/image_picker.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/massage.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/massage/bloc/massage_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/massage/cubit/massage_cubit.dart';
import 'package:instagram/presentation/customPackages/audio_recorder/social_media_recoder.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/picture_viewer.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/widgets/global/image_display.dart';
import 'package:instagram/presentation/widgets/belong_to/massages_w/record_view.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/presentation/pages/profile/user_profile_page.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChattingPage extends StatefulWidget {
  final UserPersonalInfo userInfo;
  const ChattingPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with TickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late Animation _colorTween;
  final TextEditingController _textController = TextEditingController();
  final itemScrollController = ItemScrollController();
  List<Massage> globalMassagesInfo = [];
  Massage? newMassageInfo;
  Massage? deleteThisMassage;
  bool isDeleteMassageDone = false;
  bool isMassageLoaded = false;
  int? indexOfGarbageMassage;
  int temIndex = 0;
  String records = '';
  bool unSend = false;
  bool appearIcons = true;

  Future<void> scrollToLastIndex(BuildContext context) async {
    if (globalMassagesInfo.length > 1) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        setState(() {
          itemScrollController.scrollTo(
              index: globalMassagesInfo.length - 1,
              alignment: 0.2,
              duration: const Duration(milliseconds: 10),
              curve: Curves.easeInOutQuint);
        });
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.chattingAppBar(widget.userInfo, context),
      body: GestureDetector(
          onTap: () {
            setState(() {
              unSend = false;
              deleteThisMassage = null;
            });
          },
          child: buildBody(context)),
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
              if (temIndex < globalMassagesInfo.length - 1) {
                temIndex = globalMassagesInfo.length - 1;
                scrollToLastIndex(context);
              }
            }
            if (newMassageInfo != null && isMassageLoaded) {
              isMassageLoaded = false;
              globalMassagesInfo.add(newMassageInfo!);
            }
            return Stack(
              children: [
                Padding(
                    padding: const EdgeInsetsDirectional.only(
                        end: 10, start: 10, top: 10, bottom: 10),
                    child: globalMassagesInfo.isNotEmpty
                        ? NotificationListener<ScrollNotification>(
                            onNotification: _scrollListener,
                            child: ScrollablePositionedList.separated(
                                itemScrollController: itemScrollController,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      if (index == 0) buildUserInfo(context),
                                      buildTheMassage(
                                          globalMassagesInfo[index],
                                          globalMassagesInfo[
                                                  index != 0 ? index - 1 : 0]
                                              .datePublished,
                                          index),
                                      if (index ==
                                          globalMassagesInfo.length - 1)
                                        const SizedBox(height: 50),
                                    ],
                                  );
                                },
                                itemCount: globalMassagesInfo.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(height: 5)))
                        : buildUserInfo(context)),
                Align(
                    alignment: Alignment.bottomCenter, child: fieldOfMassage()),
              ],
            );
          } else {
            return buildCircularProgress();
          }
        });
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

  Widget buildTheMassage(
      Massage massageInfo, String previousDateOfMassage, int index) {
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
                    indexOfGarbageMassage = index;
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

  Align buildMassage(bool isThatMine, Massage massageInfo) {
    String massage = massageInfo.massage;
    String imageUrl = massageInfo.imageUrl;
    String recordedUrl = massageInfo.recordedUrl;
    return Align(
      alignment: isThatMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (_, __) => Container(
                decoration: BoxDecoration(
                    color: isThatMine
                        ? _colorTween.value
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
                    ? Text(massage,
                        style: isThatMine
                            ? Theme.of(context).textTheme.bodyText2
                            : Theme.of(context).textTheme.bodyText1)
                    : (massageInfo.isThatImage
                        ? SizedBox(
                            width: 90,
                            height: 150,
                            child: massageInfo.massageUid.isNotEmpty
                                ? GestureDetector(
                                    onTap: () async {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) {
                                            return PictureViewer(
                                                imageUrl: imageUrl);
                                          },
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag: imageUrl,
                                      child: ImageDisplay(
                                        imageUrl: imageUrl,
                                      ),
                                    ),
                                  )
                                : Image.file(File(newMassageInfo!.imageUrl),
                                    fit: BoxFit.cover))
                        : SizedBox(
                            child: RecordView(
                              record:
                                  recordedUrl.isEmpty ? records : recordedUrl,
                              isThatMine: isThatMine,
                            ),
                          )),
              )),
    );
  }

  Widget fieldOfMassage() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 0),
      child: unSend ? deleteTheMassage() : textForm(),
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
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(35)),
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 50,
              padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
              margin: const EdgeInsetsDirectional.only(start: 10, end: 10),
              child: Builder(builder: (context) {
                MassageCubit massageCubit = MassageCubit.get(context);
                return rowOfTextField(massageCubit);
              }),
            ),
          ),
        ],
      );

  Widget deleteTheMassage() {
    bool isThatMine = deleteThisMassage!.senderId == myPersonalId;
    return BlocBuilder<MassageCubit, MassageState>(
      buildWhen: (previous, current) {
        if (previous != current && (current is DeleteMassageLoaded)) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (deleteThisMassage != null &&
            unSend &&
            indexOfGarbageMassage != null &&
            isDeleteMassageDone) {
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            setState(() {
              isDeleteMassageDone = false;
              unSend = false;
              deleteThisMassage = null;
              globalMassagesInfo.removeAt(indexOfGarbageMassage!);
            });
          });
        }
        return Container(
          height: 45,
          color: Theme.of(context).primaryColorLight,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 80, end: 80),
            child: Row(
                mainAxisAlignment: isThatMine
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(StringsManager.reply.tr(),
                      style: getBoldStyle(
                          color: Theme.of(context).focusColor, fontSize: 15)),
                  if (isThatMine)
                    GestureDetector(
                        onTap: () async {
                          if (deleteThisMassage != null) {
                            WidgetsBinding.instance!
                                .addPostFrameCallback((_) async {
                              setState(() {
                                isDeleteMassageDone = true;
                                MassageCubit.get(context).deleteMassage(
                                    massageInfo: deleteThisMassage!);
                              });
                            });
                          }
                        },
                        child: Text(StringsManager.unSend.tr(),
                            style: getBoldStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 15))),
                ]),
          ),
        );
      },
    );
  }

  Future<void> showIcons(bool show) async {
    if (show) {
      await Future.delayed(const Duration(milliseconds: 100), () {});
    }
    setState(() {
      appearIcons = show;
    });
  }

  Widget rowOfTextField(MassageCubit massageCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        pickImageFromCamera(massageCubit),
        massageTextField(),
        if (_textController.text.isNotEmpty) sendButton(massageCubit),
        if (_textController.text.isEmpty)
          Row(
            children: [
              const SizedBox(width: 10),
              SocialMediaRecorder(
                showIcons: showIcons,
                sendRequestFunction: (File soundFile) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                    File? compressSoundFile = await compressFile(soundFile);
                    setState(() {
                      records = soundFile.path;
                      MassageCubit massageCubit = MassageCubit.get(context);
                      newMassageInfo = newMassage();
                      isMassageLoaded = true;
                      scrollToLastIndex(context);

                      massageCubit.sendMassage(
                          massageInfo: newMassage(),
                          pathOfRecorded: compressSoundFile!.path);
                    });
                  });
                },
              ),
              Visibility(
                visible: appearIcons,
                child: Row(
                  children: [
                    pickPhoto(massageCubit),
                    const SizedBox(width: 10),
                    pickSticker(),
                  ],
                ),
              ),
            ],
          )
      ],
    );
  }

  Widget pickImageFromCamera(MassageCubit massageCubit) {
    return Visibility(
      visible: appearIcons,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: GestureDetector(
          onTap: () async {
            File? pickImage = await imageCameraPicker();
            if (pickImage != null) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                setState(() {
                  isMassageLoaded = true;
                  newMassageInfo = newMassage(isThatImage: true);
                  newMassageInfo!.imageUrl = pickImage.path;
                  scrollToLastIndex(context);
                });
              });
              massageCubit.sendMassage(
                  massageInfo: newMassage(isThatImage: true),
                  pathOfPhoto: pickImage.path);
            } else {
              ToastShow.toast(StringsManager.noImageSelected.tr());
            }
          },
          child: const CircleAvatar(
              backgroundColor: ColorManager.darkBlue,
              child: ClipOval(
                  child: Icon(
                Icons.camera_alt,
                color: ColorManager.white,
              )),
              radius: 18),
        ),
      ),
    );
  }

  Widget massageTextField() {
    return Expanded(
      child: Visibility(
        visible: appearIcons,
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
      ),
    );
  }

  Widget sendButton(MassageCubit massageCubit) {
    return Visibility(
      visible: appearIcons,
      child: GestureDetector(
        onTap: () {
          if (_textController.text.isNotEmpty) {
            massageCubit.sendMassage(
              massageInfo: newMassage(),
            );
            scrollToLastIndex(context);
            _textController.text = "";
          }
        },
        child: Text(
          StringsManager.send.tr(),
          style: getMediumStyle(
            color: _textController.text.isNotEmpty
                ? const Color.fromARGB(255, 33, 150, 243)
                : const Color.fromARGB(255, 147, 198, 246),
          ),
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

  Widget pickPhoto(MassageCubit massageCubit) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: GestureDetector(
        onTap: () async {
          File? pickImage = await imageGalleryPicker();
          if (pickImage != null) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              setState(() {
                isMassageLoaded = true;
                newMassageInfo = newMassage(isThatImage: true);
                newMassageInfo!.imageUrl = pickImage.path;
                scrollToLastIndex(context);
              });
            });
            massageCubit.sendMassage(
                massageInfo: newMassage(isThatImage: true),
                pathOfPhoto: pickImage.path);
          } else {
            ToastShow.toast(StringsManager.noImageSelected.tr());
          }
        },
        child: SvgPicture.asset(
          "assets/icons/gallery.svg",
          height: 23,
          color: Theme.of(context).focusColor,
        ),
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
            child: ImageDisplay(
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
}

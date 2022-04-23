import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/massage_cubit.dart';
import 'package:instegram/presentation/widgets/audio_recorder_view.dart';
import 'package:instegram/presentation/widgets/record_view.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import 'package:instegram/presentation/widgets/user_profile_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../core/utility/constant.dart';
import '../../core/globall.dart';

class ChattingPage extends StatefulWidget {
  final UserPersonalInfo userInfo;
  ChattingPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _textController = TextEditingController();
  final itemScrollController = ItemScrollController();
  List<Massage> massagesInfo = [];
  bool isThatLoaded = false;
  bool isThatRecordedLoaded = false;

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
      body: Builder(builder: (context) {
        MassageCubit massageCubit = MassageCubit.get(context);
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: massageCubit.getMassages(widget.userInfo.userId),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots) {
              if (!snapshots.hasData) {
                return Column(
                  children: [
                    buildUserInfo(context),
                    const Center(
                      child: Text('There is no Massages yet!'),
                    ),
                  ],
                );
              } else {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> snap =
                    snapshots.data!.docs;
                if (!isThatLoaded) {
                  for (int i = 0; i < snap.length; i++) {
                    if (!massagesInfo.contains(Massage.fromJson(snap[i]))) {
                      massagesInfo.add(Massage.fromJson(snap[i]));
                    }
                  }
                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                    setState(() {
                      isThatLoaded = true;
                    });
                  });


                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black54,
                    strokeWidth: 1.3,
                  ));
                }
                if(isThatRecordedLoaded){
                  massagesInfo.removeLast();
                  massagesInfo.add(Massage.fromJson(snap[snap.length - 1]));
                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                    setState(() {
                      isThatRecordedLoaded = true;
                    });
                  });
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: massagesInfo.isNotEmpty
                            ? ScrollablePositionedList.separated(
                                itemScrollController: itemScrollController,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      if (index == 0) buildUserInfo(context),
                                      // if (index > 0)
                                      buildTheMassage(
                                          massagesInfo[index],
                                          massagesInfo[
                                                  index != 0 ? index - 1 : 0]
                                              .datePublished),
                                      if (index == massagesInfo.length - 1)
                                        const SizedBox(height: 10),
                                    ],
                                  );
                                },
                                itemCount: massagesInfo.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(height: 5))
                            : buildUserInfo(context),
                      ),
                      fieldOfMassage(),
                    ],
                  ),
                );
              }
            }

            // },
            );
      }),
    );
  }

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

  Widget buildTheMassage(Massage massageInfo, String previousDateOfMassage) {
    bool isThatMine = false;
    if (massageInfo.senderId == myPersonalId) isThatMine = true;
    String massage = massageInfo.massage;
    String imageUrl = massageInfo.imageUrl.toString();
    String recordedUrl = massageInfo.recordedUrl.toString();
    bool check=recordedUrl.isNotEmpty;
    String theDate = DateOfNow.chattingDateOfNow(
        massageInfo.datePublished, previousDateOfMassage);
    return Column(
      children: [
        if (theDate.isNotEmpty)
          Align(
              alignment: AlignmentDirectional.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  theDate,
                  style: const TextStyle(color: Colors.black54),
                ),
              )),
        const SizedBox(height: 5),
        Row(
          children: [
            if (isThatMine)
              const SizedBox(
                width: 100,
              ),
            Expanded(
              child: Align(
                alignment: isThatMine
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Container(
                  decoration: BoxDecoration(
                      color: isThatMine
                          ? const Color.fromARGB(255, 4, 113, 238)
                          : Colors.grey[200],
                      borderRadius: BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(isThatMine ? 20 : 0),
                        bottomEnd: Radius.circular(isThatMine ? 0 : 20),
                        topStart: const Radius.circular(20),
                        topEnd: const Radius.circular(20),
                      )),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  padding: imageUrl.isEmpty
                      ? const EdgeInsets.symmetric(vertical: 8, horizontal: 10)
                      : const EdgeInsets.all(0),
                  child: imageUrl.isEmpty
                      ? (check&&records.isEmpty
                          // recordedUrl.isEmpty
                          ? Text(
                              massage,
                              style: TextStyle(
                                  color:
                                      isThatMine ? Colors.white : Colors.black),
                            )
                          : SizedBox(
                              child: RecordView(
                              record:
                                  recordedUrl.isEmpty ? records : recordedUrl,
                            )))
                      : SizedBox(
                          width: 90,
                          height: 150,
                          child: Image.network(imageUrl, fit: BoxFit.cover)),
                ),
              ),
            ),
            if (!isThatMine)
              const SizedBox(
                width: 100,
              )
          ],
        ),
      ],
    );
  }

  _onRecordComplete() {
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records = onData.path;
    }).onDone(() async {
      setState(() {});
      massagesInfo.add(newMassage());

      MassageCubit massageCubit = MassageCubit.get(context);
      await massageCubit.sendMassage(
          massageInfo: newMassage(), pathOfRecorded: records);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          isThatRecordedLoaded = true;
        });
      });
    });
  }

  Widget fieldOfMassage() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(35)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Builder(builder: (context) {
            MassageCubit massageCubit = MassageCubit.get(context);
            return rowOfTextField(massageCubit);
          }),
        ),
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
              RecorderView(onSaved: _onRecordComplete),
              const SizedBox(width: 10),
              pickPhoto(massageCubit),
              const SizedBox(width: 10),
              pickSticker(),
            ],
          )
      ],
    );
  }

  InkWell pickImageFromCamera(MassageCubit massageCubit) {
    return InkWell(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          await massageCubit.sendMassage(
              massageInfo: newMassage(), pathOfPhoto: pickedFile.path);
          // setState(() {
          //   isImageUpload = true;
          // });
        } else {
          ToastShow.toast('No image selected.');
        }
      },
      child: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 4, 113, 238),
          child: ClipOval(
              child: Icon(
            Icons.camera_alt,
            color: Colors.white,
          )),
          radius: 20),
    );
  }

  Expanded massageTextField() {
    return Expanded(
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        cursorColor: Colors.teal,
        maxLines: null,
        decoration: const InputDecoration.collapsed(
            hintText: 'Message...',
            hintStyle: TextStyle(color: Colors.black26)),
        autofocus: false,
        controller: _textController,
        cursorWidth: 1.5,
        onChanged: (e) {
          setState(() {
            _textController;
          });
          print(e.toString());
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
        'Send',
        style: TextStyle(
            color: _textController.text.isNotEmpty
                ? const Color.fromARGB(255, 33, 150, 243)
                : const Color.fromARGB(255, 147, 198, 246),
            fontWeight: FontWeight.w500),
      ),
    );
  }

  GestureDetector pickSticker() {
    return GestureDetector(
      onTap: () {},
      child: const Icon(Icons.sticky_note_2),
    );
  }

  GestureDetector pickPhoto(MassageCubit massageCubit) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          await massageCubit.sendMassage(
              massageInfo: newMassage(), pathOfPhoto: pickedFile.path);
          // setState(() {
          //   isImageUpload = true;
          // });
        } else {
          ToastShow.toast('No image selected.');
        }
      },
      child: const Icon(Icons.photo),
    );
  }

  Massage newMassage() {
    return Massage(
      datePublished: DateOfNow.dateOfNow(),
      massage: _textController.text,
      senderId: myPersonalId,
      receiverId: widget.userInfo.userId,
    );
  }

  CircleAvatar circleAvatarOfImage() {
    return CircleAvatar(
        child: ClipOval(
            child: Image.network(
          widget.userInfo.profileImageUrl,
          fit: BoxFit.cover,
        )),
        radius: 45);
  }

  Row userName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.userInfo.userName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          "Instagram",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Text nameOfUser() {
    return Text(
      widget.userInfo.name,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }

  Row someInfoOfUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${widget.userInfo.followerPeople.length} Followers",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${widget.userInfo.posts.length} Posts",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
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
        ).push(MaterialPageRoute(
          builder: (context) => UserProfilePage(
            userId: widget.userInfo.userId,
          ),
          maintainState: false,
        ));
      },
      child: const Text("View Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal)),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          CircleAvatar(
              child: ClipOval(
                  child: Image.network(
                widget.userInfo.profileImageUrl,
                fit: BoxFit.cover,
              )),
              radius: 17),
          const SizedBox(
            width: 15,
          ),
          Text(
            widget.userInfo.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          )
        ],
      ),
      actions: const [
        Icon(
          Icons.phone,
          color: Colors.black,
        ),
        SizedBox(
          width: 20,
        ),
        Icon(
          Icons.video_call,
          color: Colors.black,
        ),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }
}

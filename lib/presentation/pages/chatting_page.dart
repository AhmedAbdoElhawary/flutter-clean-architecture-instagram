import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/massage_cubit.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import 'package:instegram/presentation/widgets/user_profile_page.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/utility/constant.dart';
import '../../core/globall.dart';

class ChatingPage extends StatefulWidget {
  final UserPersonalInfo userInfo;
  ChatingPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
  final TextEditingController _textController = TextEditingController();
  final itemScrollController = ItemScrollController();
  List<DocumentSnapshot> massages=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Builder(builder: (context) {
        MassageCubit massageCubit = MassageCubit.get(context);
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: massageCubit.getMassages(widget.userInfo.userId),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
            // MassageCubit massageCubit = MassageCubit.get(context);

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
              massages = snapshots.data!.docs;
              // itemScrollController.jumpTo(index: massages.length-1);
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ScrollablePositionedList.separated(
                          itemScrollController: itemScrollController,
                          itemBuilder: (context, index) {
                            // Massage theMassageInfo = Massage.fromJson(massages[index]);

                            return Column(
                              children: [
                                if (index == 0) buildUserInfo(context),
                                // if (index > 0)
                                buildTheMassage(massages[index]),
                                if (index == massages.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            );
                          },
                          itemCount: massages.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 5)),
                    ),
                    fieldOfMassage(),
                  ],
                ),
              );
            }
          },
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

  Widget buildTheMassage(DocumentSnapshot massageInfo) {
    // Massage theMassageInfo = Massage.fromJson(massages[index]);

    bool isThatMine = false;
    if (massageInfo["senderId"] == myPersonalId) isThatMine = true;
    String massage = massageInfo["massage"];
    String imageUrl = massageInfo["imageUrl"].toString();
    return Row(
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
                  color: isThatMine ? Colors.blueAccent : Colors.grey[200],
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
                  ? Text(
                      massage,
                      style: TextStyle(
                          color: isThatMine ? Colors.white : Colors.black),
                    )
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
    );
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

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? pickedFile =
                        await _picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      await massageCubit.sendMassage(
                          massageInfo: newMassage(),
                          pathOfPhoto: pickedFile.path);
                      // setState(() {
                      //   isImageUpload = true;
                      // });
                    } else {
                      ToastShow.toast('No image selected.');
                    }
                  },
                  child: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: ClipOval(
                          child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                      radius: 20),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
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
                ),
                if (_textController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      // if (_textController.text.isNotEmpty) {
                      massageCubit.sendMassage(
                          massageInfo: newMassage(), pathOfPhoto: "");
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
                  ),
                if (_textController.text.isEmpty)
                  Row(
                    children: [
                      const SizedBox(width: 10,),

                      GestureDetector(onTap: (){},child: const Icon(Icons.mic_none_rounded),),
                      const SizedBox(width: 10,),
                      GestureDetector(onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedFile =
                            await _picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          await massageCubit.sendMassage(
                              massageInfo: newMassage(),
                              pathOfPhoto: pickedFile.path);
                          // setState(() {
                          //   isImageUpload = true;
                          // });
                        } else {
                          ToastShow.toast('No image selected.');
                        }
                      },child: const Icon(Icons.photo),),
                      const SizedBox(width: 10,),

                      GestureDetector(onTap: (){},child: const Icon(Icons.sticky_note_2),),
                    ],
                  )
              ],
            );
          }),
        ),
      ),
    );
  }

  Massage newMassage() {
    return Massage(
      datePublished:  DateOfNow.dateOfNow(),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/massage_cubit.dart';
import 'package:instegram/presentation/widgets/user_profile_page.dart';

class TextingPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  final UserPersonalInfo userInfo;
  TextingPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocBuilder<MassageCubit, MassageState>(
        bloc: MassageCubit.get(context)..getMassages(userInfo.userId),
        builder: (context, state) {
          return ListView.separated(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    circleAvatarOfImage(),
                    const SizedBox(height: 10),
                    nameOfUser(),
                    const SizedBox(height: 5),
                    userName(),
                    const SizedBox(height: 5),
                    someInfoOfUser(),
                    viewProfileButton(context)
                  ],
                );
              },
              itemCount: 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider());
        },
      ),
      bottomSheet: fieldOfMassage(),
    );
  }

  SingleChildScrollView fieldOfMassage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(35)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: ClipOval(
                          child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                      radius: 20),
                ),
                const SizedBox(
                  width: 20.0,
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
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // if (_textController.text.isNotEmpty) {
                    //   postTheComment(userPersonalInfo);
                    // }
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(
                        color: Color.fromARGB(255, 33, 150, 243),
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  CircleAvatar circleAvatarOfImage() {
    return CircleAvatar(
        child: ClipOval(
            child: Image.network(
          userInfo.profileImageUrl,
          fit: BoxFit.cover,
        )),
        radius: 45);
  }

  Row userName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userInfo.userName,
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
      userInfo.name,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }

  Row someInfoOfUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${userInfo.followerPeople.length} Followers",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${userInfo.posts.length} Posts",
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
            userId: userInfo.userId,
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
                userInfo.profileImageUrl,
                fit: BoxFit.cover,
              )),
              radius: 12),
          const SizedBox(
            width: 15,
          ),
          Text(
            userInfo.name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
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

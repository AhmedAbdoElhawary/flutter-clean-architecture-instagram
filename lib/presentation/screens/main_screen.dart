import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/pages/all_user_posts_page.dart';
import 'package:instegram/presentation/pages/profile_page.dart';
import '../pages/home_page.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar:
            CupertinoTabBar(backgroundColor: Colors.white, height: 40, items: [
          navigationBarItem("house_white.svg"),
          navigationBarItem("search.svg"),
          navigationBarItem("video.svg"),
          navigationBarItem("shop_white.svg"),
          BottomNavigationBarItem(
            icon:
                BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
                    builder: (context, state) {
              FirestoreUserInfoCubit userCubit =
                  FirestoreUserInfoCubit.get(context);
              String userImage = userCubit.personalInfo!.profileImageUrl;

              return CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black12,
                  child: ClipOval(
                    child: userImage.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : Image.network(userImage),
                  ));
            }),
          ),
        ]),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) => CupertinoPageScaffold(
                    child: HomeScreen(userId: widget.userId)),
              );
            case 1:
              return CupertinoTabView(
                builder: (context) => CupertinoPageScaffold(
                    child: AllUserPostPage(userId: widget.userId)),
              );
            case 2:
              return CupertinoTabView(
                builder: (context) => const CupertinoPageScaffold(
                  child: Text(
                    "widget.userInfo.email",
                    style: optionStyle,
                  ),
                ),
              );
            case 3:
              return CupertinoTabView(
                builder: (context) => CupertinoPageScaffold(
                  child: Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(userId: widget.userId)));
                        },
                        child: const Text("Click here mother f***k")),
                  ),
                ),
              );
            default:
              return CupertinoTabView(
                builder: (context) =>
                    CupertinoPageScaffold(child: ProfilePage(widget.userId)),
              );
          }
        });
  }

  BottomNavigationBarItem navigationBarItem(String fileName) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        "assets/icons/$fileName",
        height: 25,
      ),
    );
  }
}

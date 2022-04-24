import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/injector.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/pages/search_about_user_page.dart';
import 'package:instegram/presentation/pages/personal_profile_page.dart';
import 'package:instegram/presentation/pages/shop_page.dart';
import 'package:instegram/presentation/pages/videos_page.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';
import '../pages/home_page.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              String userImage = userCubit.myPersonalInfo!.profileImageUrl;

              return CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black12,
                  child: ClipOval(
                    child: userImage.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        :CustomFadeInImage(imageUrl:userImage) ,
                  ));
            }),
          ),
        ]),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) => CupertinoPageScaffold(
                    child: BlocProvider<PostCubit>(
                  create: (context) => injector<PostCubit>(),
                  child: HomeScreen(userId: widget.userId),
                )),
              );
            case 1:
              return CupertinoTabView(
                builder: (context) => CupertinoPageScaffold(
                    child: BlocProvider<PostCubit>(
                        create: (context) => injector<PostCubit>()..getAllPostInfo(),
                        child: SearchAboutUserPage(userId: widget.userId))),
              );
            case 2:
              return CupertinoTabView(
                builder: (context) => CupertinoPageScaffold(
                  child: BlocProvider<PostCubit>(
                      create: (context) => injector<PostCubit>(),
                      child: const VideosPage()),
                ),
              );
            case 3:
              return CupertinoTabView(
                builder: (context) => const CupertinoPageScaffold(
                  child: ShopPage(),
                ),
              );
            default:
              return CupertinoTabView(
                builder: (context) => CupertinoPageScaffold(
                  child: BlocProvider<PostCubit>(
                    create: (context) => injector<PostCubit>(),
                    child: PersonalProfilePage(personalId: widget.userId),
                  ),
                ),
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

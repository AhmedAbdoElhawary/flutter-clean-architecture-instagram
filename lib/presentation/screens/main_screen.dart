import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/profile/personal_profile_page.dart';
import 'package:instagram/presentation/pages/shop/shop_page.dart';
import 'package:instagram/presentation/pages/time_line/all_user_time_line/all_users_time_line.dart';
import 'package:instagram/presentation/pages/time_line/my_own_time_line/home_page.dart';
import 'package:instagram/presentation/pages/video/videos_page.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ValueNotifier<bool> stopVideo = ValueNotifier(false);
  CupertinoTabController controller = CupertinoTabController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: ValueListenableBuilder(
        valueListenable: stopVideo,
        builder: (BuildContext context, bool value, __) {
          return CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                  backgroundColor: value
                      ? ColorManager.black
                      : Theme.of(context).primaryColor,
                  height: 40,
                  items: [
                    navigationBarItem("house_white.svg", value),
                    navigationBarItem("search.svg", value),
                    navigationBarItem("video.svg", value),
                    navigationBarItem("shop_white.svg", value),
                    BottomNavigationBarItem(
                      icon: BlocBuilder<FirestoreUserInfoCubit,
                          FirestoreGetUserInfoState>(builder: (context, state) {
                        FirestoreUserInfoCubit userCubit =
                            FirestoreUserInfoCubit.get(context);
                        String userImage =
                            userCubit.myPersonalInfo!.profileImageUrl;

                        return CircleAvatar(
                            radius: 14,
                            backgroundImage: userImage.isNotEmpty
                                ? NetworkImage(userImage)
                                : null,
                            backgroundColor: Theme.of(context).hintColor,
                            child: userImage.isEmpty
                                ? const Icon(Icons.person,
                                    color: ColorManager.white)
                                : null);
                      }),
                    ),
                  ]),
              controller: controller,
              tabBuilder: (context, index) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  stopVideo.value = controller.index == 2 ? true : false;
                });

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
                      builder: (context) =>
                          CupertinoPageScaffold(child: AllUsersTimeLinePage()),
                    );
                  case 2:
                    return CupertinoTabView(
                      builder: (context) => CupertinoPageScaffold(
                        child: BlocProvider<PostCubit>(
                            create: (context) => injector<PostCubit>(),
                            child: VideosPage(
                              stopVideo: value,
                            )),
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
        },
      ),
    );
  }

  BottomNavigationBarItem navigationBarItem(String fileName, bool value) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        "assets/icons/$fileName",
        height: 25,
        color: value ? ColorManager.white : Theme.of(context).focusColor,
      ),
    );
  }
}

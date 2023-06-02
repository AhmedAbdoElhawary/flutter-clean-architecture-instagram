import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/core/widgets/svg_pictures.dart';
import 'package:instagram/data/models/child_classes/notification.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instagram/presentation/cubit/notification/notification_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/messages/messages_for_web.dart';
import 'package:instagram/presentation/pages/profile/personal_profile_page.dart';
import 'package:instagram/presentation/pages/register/login_page.dart';
import 'package:instagram/presentation/pages/shop/shop_page.dart';
import 'package:instagram/presentation/pages/time_line/all_user_time_line/all_users_time_line.dart';
import 'package:instagram/presentation/pages/time_line/my_own_time_line/home_page.dart';
import 'package:instagram/presentation/widgets/global/screens_w.dart';
import 'package:instagram/presentation/widgets/global/others/notification_card_info.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/web/new_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

int pageOfController = 0;

class WebScreenLayout extends StatefulWidget {
  final Widget? body;
  final UserPersonalInfo? userInfoForMessagePage;
  const WebScreenLayout({Key? key, this.body, this.userInfoForMessagePage})
      : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: pageOfController);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() => page = page);
  }

  void navigationTapped(int page) {
    if (widget.body != null) {
      setState(() => page = page);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const WebScreenLayout()));
    } else {
      pageController.jumpToPage(page);
      setState(() => pageOfController = page);
    }
  }

  void onPressedAdd(int page) {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) => const PopupNewPost(),
      ),
    );
    setState(() => pageOfController = page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          appBar(context),
          Expanded(
            child: widget.body ??
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  children: homeScreenItems(),
                ),
          ),
        ],
      ),
    );
  }

  Container appBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: const Border(
          bottom: BorderSide(
            color: ColorManager.lowOpacityGrey,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 960,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 5),
              const InstagramLogo(),
              const Expanded(child: SizedBox(width: 1)),
              Column(
                children: [
                  Center(
                    child: IconButton(
                      icon: Icon(
                        pageOfController == 0
                            ? Icons.home_rounded
                            : Icons.home_outlined,
                        color: Theme.of(context).focusColor,
                        size: 32,
                      ),
                      onPressed: () => navigationTapped(0),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(IconsAssets.messengerIcon, pageOfController == 1,
                    biggerIcon: true),
                onPressed: () => navigationTapped(1),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(IconsAssets.addIcon, pageOfController == 2),
                onPressed: () => onPressedAdd(2),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(IconsAssets.compass, pageOfController == 3),
                onPressed: () => navigationTapped(3),
              ),
              const SizedBox(width: 5),
              PopupMenuButton<int>(
                tooltip: "Show notifications",
                constraints:
                    const BoxConstraints.tightFor(height: 360, width: 500),
                position: PopupMenuPosition.under,
                elevation: 20,
                color: Theme.of(context).splashColor,
                offset: const Offset(90, 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  pageOfController == 4
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: Theme.of(context).focusColor,
                  size: 28,
                ),
                itemBuilder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await NotificationCubit.get(context)
                        .getNotifications(userId: myPersonalId);
                  });
                  List<CustomNotification> notifications =
                      NotificationCubit.get(context).notifications;

                  return List<PopupMenuEntry<int>>.generate(
                    notifications.length,
                    (index) => PopupMenuItem<int>(
                      value: index,
                      child: NotificationCardInfo(
                          notificationInfo: notifications[index]),
                    ),
                  );
                },
              ),
              const SizedBox(width: 5),
              buildPopupMenuButton(context),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<int> buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: "Show profile menu",
      elevation: 20,
      constraints: const BoxConstraints.tightFor(width: 180),
      position: PopupMenuPosition.under,
      color: Theme.of(context).splashColor,
      offset: const Offset(90, 12),
      icon: const PersonalImageIcon(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onSelected: (int item) => onSelectedProfileMenu(item),
      itemBuilder: (context) => profileItems(),
    );
  }

  onSelectedProfileMenu(int item) {
    if (item == 0) navigationTapped(5);
    if (item == 2) {
      final SharedPreferences sharePrefs = injector<SharedPreferences>();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
        await authCubit.signOut(userId: myPersonalId);

        await sharePrefs.clear();
        Get.offAll(const LoginPage(),
            duration: const Duration(milliseconds: 0));
      });
    }
  }

  List<PopupMenuEntry<int>> profileItems() => [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              const Icon(Icons.person, size: 15),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Profile",
                  style: getNormalStyle(
                      color: Theme.of(context).focusColor, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.settings_rounded, size: 15),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Settings",
                  style: getNormalStyle(
                      color: Theme.of(context).focusColor, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text(
            "Log Out",
            style: getNormalStyle(
                color: Theme.of(context).focusColor, fontSize: 15),
          ),
        ),
      ];

  List<Widget> homeScreenItems() {
    return [
      const _HomePage(),
      MessagesForWeb(selectedTextingUser: widget.userInfoForMessagePage),
      const ShopPage(),
      AllUsersTimeLinePage(),
      const _PersonalProfilePage(),
    ];
  }

  SvgPicture icons(String icon, bool value, {bool biggerIcon = false}) {
    return SvgPicture.asset(
      icon,
      height: biggerIcon ? 30 : 25,
      colorFilter:
          ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => injector<PostCubit>(),
      child: HomePage(userId: myPersonalId),
    );
  }
}

class _PersonalProfilePage extends StatelessWidget {
  const _PersonalProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => injector<PostCubit>(),
      child: PersonalProfilePage(personalId: myPersonalId),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/core/widgets/svg_pictures.dart';
import 'package:instagram/data/models/notification.dart';
import 'package:instagram/presentation/cubit/notification/notification_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/messages/messages_for_web.dart';
import 'package:instagram/presentation/pages/profile/personal_profile_page.dart';
import 'package:instagram/presentation/pages/shop/shop_page.dart';
import 'package:instagram/presentation/pages/time_line/all_user_time_line/all_users_time_line.dart';
import 'package:instagram/presentation/pages/time_line/my_own_time_line/home_page.dart';
import 'package:instagram/presentation/widgets/belong_to/screens_w.dart';
import 'package:instagram/presentation/widgets/global/others/notification_card_info.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/web/new_post.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() => _page = page);
  }

  void onPressedAdd(int page) {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) => const PopupNewPost(),
      ),
    );
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: ColorManager.appBarElationColor,
              offset: Offset(0, 1.0),
              blurRadius: 0,
            )
          ]),
          child: AppBar(
            elevation: 1,
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: false,
            title: const InstagramLogo(),
            actions: [
              IconButton(
                icon: Icon(
                  _page == 0 ? Icons.home_rounded : Icons.home_outlined,
                  color: Theme.of(context).focusColor,
                  size: 32,
                ),
                onPressed: () => navigationTapped(0),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(IconsAssets.messengerIcon, _page == 1),
                onPressed: () => navigationTapped(1),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(IconsAssets.addIcon, _page == 2),
                onPressed: () => onPressedAdd(2),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(IconsAssets.compass, _page == 3),
                onPressed: () => navigationTapped(3),
              ),
              const SizedBox(width: 5),
              PopupMenuButton<int>(
                constraints:
                    const BoxConstraints.tightFor(height: 360, width: 500),
                position: PopupMenuPosition.under,
                tooltip: "Show notifications",
                elevation: 20,
                color: Theme.of(context).splashColor,
                offset: const Offset(90, 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  _page == 4
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
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }

  PopupMenuButton<int> buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      constraints: const BoxConstraints.tightFor(width: 180),
      tooltip: "Show profile menu",
      position: PopupMenuPosition.under,
      elevation: 20,
      color: Theme.of(context).splashColor,
      offset: const Offset(90, 12),
      icon: const PersonalImageIcon(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onSelected: (int item) => onSelectedProfileMenu(item),
      itemBuilder: (context) => profileItems(),
    );
  }

  onSelectedProfileMenu(int item) {
    if (item == 0) {
      navigationTapped(5);
      return;
    } else if (item == 1) {
    } else {}
  }

  List<PopupMenuEntry<int>> profileItems() => [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              const Icon(Icons.grid_on_sharp, size: 15),
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

  List<Widget> homeScreenItems = [
    const _HomePage(),
    const MessagesForWeb(),
    const ShopPage(),
    AllUsersTimeLinePage(),
    const _PersonalProfilePage(),
  ];

  SvgPicture icons(String icon, bool value) {
    return SvgPicture.asset(
      icon,
      height: 25,
      color: Theme.of(context).focusColor,
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

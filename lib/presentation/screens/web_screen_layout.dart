import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/core/widgets/svg_pictures.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/profile/personal_profile_page.dart';
import 'package:instagram/presentation/pages/shop/shop_page.dart';
import 'package:instagram/presentation/pages/time_line/all_user_time_line/all_users_time_line.dart';
import 'package:instagram/presentation/pages/time_line/my_own_time_line/home_page.dart';
import 'package:instagram/presentation/widgets/belong_to/screens_w.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

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
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            onPressed: () => navigationTapped(2),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: icons(IconsAssets.shop, _page == 3),
            onPressed: () => navigationTapped(3),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: Icon(
              _page == 4 ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: Theme.of(context).focusColor,
              size: 28,
            ),
            onPressed: () => navigationTapped(4),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: const PersonalImageIcon(),
            onPressed: () => navigationTapped(5),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }

  List<Widget> homeScreenItems = [
    const _HomePage(),
    AllUsersTimeLinePage(),
    const ShopPage(),
    AllUsersTimeLinePage(),
    const ShopPage(),
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
      child: ValueListenableBuilder(
        valueListenable: ValueNotifier(false),
        builder: (context, bool playVideoValue, child) => HomePage(
          userId: myPersonalId,
          playVideo: playVideoValue,
        ),
      ),
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

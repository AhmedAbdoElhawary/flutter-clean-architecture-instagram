import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/messages/messages_page_for_mobile.dart';
import 'package:instagram/presentation/pages/profile/personal_profile_page.dart';
import 'package:instagram/presentation/pages/shop/shop_page.dart';
import 'package:instagram/presentation/pages/time_line/all_user_time_line/all_users_time_line.dart';
import 'package:instagram/presentation/pages/time_line/my_own_time_line/home_page.dart';
import 'package:instagram/presentation/widgets/belong_to/screens_w.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';

class MobileScreenLayout extends StatefulWidget {
  final String userId;
  const MobileScreenLayout(this.userId, {Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  ValueNotifier<bool> playHomeVideo = ValueNotifier(false);
  CupertinoTabController controller = CupertinoTabController();
  ValueNotifier<bool> stopReelVideo = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            backgroundColor: Theme.of(context).primaryColor,
            height: 40,
            items: [
              navigationBarItem(IconsAssets.home),
              navigationBarItem(IconsAssets.messengerIcon),
              navigationBarItem(IconsAssets.addIcon, littleSmall: true),
              navigationBarItem(IconsAssets.search),
              personalImageItem(),
            ]),
        controller: controller,
        tabBuilder: (context, index) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            stopReelVideo.value = controller.index != 0 ? true : false;
            playHomeVideo.value = controller.index == 0 ? true : false;
          });

          switch (index) {
            case 0:
              return homePage();
            case 1:
              return messagesPage();
            case 2:
              return galleryPage();
            case 3:
              return allUsersTimLinePage();
            default:
              return personalProfilePage();
          }
        });
  }

  CupertinoTabView allUsersTimLinePage() => CupertinoTabView(
        builder: (context) =>
            CupertinoPageScaffold(child: AllUsersTimeLinePage()),
      );

  CupertinoTabView shopPage() => CupertinoTabView(
        builder: (context) => const CupertinoPageScaffold(
          child: ShopPage(),
        ),
      );

  CupertinoTabView personalProfilePage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          child: BlocProvider<PostCubit>(
            create: (context) => injector<PostCubit>(),
            child: PersonalProfilePage(personalId: widget.userId),
          ),
        ),
      );

  Widget messagesPage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          child: BlocProvider<UsersInfoCubit>(
            create: (context) => injector<UsersInfoCubit>(),
            child: const MessagesPageForMobile(),
          ),
        ),
      );
  Widget galleryPage() => CupertinoTabView(
    builder: (context) => const CupertinoPageScaffold(
      child:CustomGalleryDisplay(),
    ),
  );

  Widget homePage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(child: home()),
      );

  BlocProvider<PostCubit> home() => BlocProvider<PostCubit>(
        create: (context) => injector<PostCubit>(),
        child: ValueListenableBuilder(
          valueListenable: playHomeVideo,
          builder: (context, bool playVideoValue, child) => HomePage(
            userId: widget.userId,
            playVideo: playVideoValue,
            stopReelVideoValue: stopReelVideo,
          ),
        ),
      );

  BottomNavigationBarItem personalImageItem() {
    return const BottomNavigationBarItem(
      icon: PersonalImageIcon(),
    );
  }

  BottomNavigationBarItem navigationBarItem(String icon,
      {bool littleSmall = false}) {
    return BottomNavigationBarItem(
      icon: GestureDetector(
        onTap: littleSmall
            ? () {
                pushToPage(context,
                    page: const CustomGalleryDisplay(), withoutRoot: false);
              }
            : null,
        child: SvgPicture.asset(
          icon,
          height: littleSmall ? 23 : 25,
          color: Theme.of(context).focusColor,
        ),
      ),
    );
  }
}

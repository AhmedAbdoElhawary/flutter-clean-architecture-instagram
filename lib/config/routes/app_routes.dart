import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/pages/messages/chatting_page.dart';
import 'package:instagram/presentation/pages/messages/video_call_page.dart';
import 'package:instagram/presentation/pages/profile/followers_info_page.dart';
import 'package:instagram/presentation/pages/profile/user_profile_page.dart';
import 'package:instagram/presentation/pages/profile/users_who_likes_for_mobile.dart';
import 'package:instagram/presentation/pages/profile/widgets/which_profile_page.dart';
import 'package:instagram/presentation/pages/register/login_page.dart';
import 'package:instagram/presentation/pages/story/create_story.dart';
import 'package:instagram/presentation/pages/story/story_page_for_mobile.dart';
import 'package:instagram/presentation/screens/web_screen_layout.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/get_post_info.dart';

/// handle root of bar [withoutRoot]

Future pushToPage(
  BuildContext context, {
  required String routeName,
  bool withoutRoot = true,
  Object? arguments,
}) async {
  if (isThatMobile) {
    return Navigator.of(context, rootNavigator: withoutRoot)
        .pushNamed(routeName, arguments: arguments);
  } else {
    return Navigator.of(context, rootNavigator: withoutRoot)
        .pushName(Routes.webScreenLayout, arguments: arguments);
  }
}

class Routes {
  static const String login = "/login";
  static const String webScreenLayout = "/Screen Layout";

  static const String storyPageForMobile = "/story Page";
  static const String followersInfoPage = "/Followers Info";
  static const String usersWhoLikesForMobile = "/Users Who Likes";
  static const String createStoryPage = "/Create Story";
  static const String getsPostInfoAndDisplay = "/Gets Post And Display";
  static const String userProfilePage = "/User Profile ";
  static const String whichProfilePage = "/Which Profile Page";
  static const String chattingPage = "/Chatting Page";
  static const String callPage = "/Call Page";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.login:
        return CupertinoPageRoute(builder: (_) => const LoginPage());
      case Routes.webScreenLayout:
        return CupertinoPageRoute(
            builder: (_) => WebScreenLayout(
                routeSettings.arguments as WebScreenLayoutParameters?));
      case Routes.storyPageForMobile:
        return CupertinoPageRoute(
            builder: (_) =>
                StoryPageForMobile(routeSettings.arguments as StoryPagePar));
      case Routes.followersInfoPage:
        return CupertinoPageRoute(
            builder: (_) => FollowersInfoPage(
                routeSettings.arguments as FollowersInfoPagePar));
      case Routes.usersWhoLikesForMobile:
        return CupertinoPageRoute(
            builder: (_) => UsersWhoLikesForMobile(
                routeSettings.arguments as UsersWhoLikesForMobilePar));
      case Routes.createStoryPage:
        return CupertinoPageRoute(
            builder: (_) =>
                CreateStoryPage(routeSettings.arguments as CreateStoryPagePar));
      case Routes.getsPostInfoAndDisplay:
        return CupertinoPageRoute(
            builder: (_) => GetsPostInfoAndDisplay(
                routeSettings.arguments as GetsPostInfoAndDisplayPar));
      case Routes.userProfilePage:
        return CupertinoPageRoute(
            builder: (_) => UserProfilePage(
                routeSettings.arguments as UserProfilePageParameters));
      case Routes.whichProfilePage:
        return CupertinoPageRoute(
            builder: (_) => WhichProfilePage(
                routeSettings.arguments as WhichProfilePageParameters));
      case Routes.chattingPage:
        return CupertinoPageRoute(
            builder: (_) => ChattingPage(
                routeSettings.arguments as ChattingPageParameters));
      case Routes.callPage:
        return CupertinoPageRoute(
            builder: (_) =>
                CallPage(routeSettings.arguments as CallPageParameters));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return CupertinoPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(StringsManager.noRouteFound).tr(),
              ),
              body: Center(child: const Text(StringsManager.noRouteFound).tr()),
            ));
  }
}

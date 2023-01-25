import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instagram/core/resources/strings_manager.dart';
class Routes {
  static const String storyPageForMobile = "/story Page";
  static const String followersInfoPage = "/Followers Info";
  static const String usersWhoLikesForMobile = "/Users Who Likes";
  static const String createStoryPage = "/Create Story";
  static const String getsPostInfoAndDisplay = "/Gets Post And Display";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return CupertinoPageRoute(builder: (_) => SplashView());
      case Routes.loginRoute:
        return CupertinoPageRoute(builder: (_) => LoginView());
      case Routes.onBoardingRoute:
        return CupertinoPageRoute(builder: (_) => OnBoardingView());
      case Routes.registerRoute:
        return CupertinoPageRoute(builder: (_) => RegisterView());
      case Routes.forgotPasswordRoute:
        return CupertinoPageRoute(builder: (_) => ForgotPasswordView());
      case Routes.mainRoute:
        return CupertinoPageRoute(builder: (_) => MainView());
      case Routes.storeDetailsRoute:
        return CupertinoPageRoute(builder: (_) => StoreDetailsView());
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

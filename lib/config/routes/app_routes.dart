import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/screens/web_screen_layout.dart';

/// I don't use routes methods because there is a lot of run time error.
/// I use normal Navigator because i don't know how to make Get.to without root.
Future pushToPage(
  BuildContext context, {
  required Widget page,
  bool withoutRoot = true,
  bool withoutPageTransition = false,
}) async {
  if (isThatMobile) {
    PageRoute route = withoutPageTransition
        ? MaterialPageRoute(
            builder: (context) => page, maintainState: !withoutRoot)
        : CupertinoPageRoute(
            builder: (context) => page, maintainState: !withoutRoot);
    return Navigator.of(context, rootNavigator: withoutRoot).push(route);
  } else {
    return Get.to(WebScreenLayout(body: page),
        transition: Transition.noTransition);
  }
}

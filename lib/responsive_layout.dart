import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// i'm not using it now!

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout(
      {Key? key,
      required this.mobileScreenLayout,
      required this.webScreenLayout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid || Platform.isIOS
        ? mobileScreenLayout
        : webScreenLayout;
  }
}

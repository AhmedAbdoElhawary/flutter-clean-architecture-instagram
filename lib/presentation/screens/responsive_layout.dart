import 'package:flutter/material.dart';
import 'package:instagram/core/utility/constant.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout({
    super.key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  });

  @override
  Widget build(BuildContext context) {
    return isThatMobile ? mobileScreenLayout : webScreenLayout;
  }
}

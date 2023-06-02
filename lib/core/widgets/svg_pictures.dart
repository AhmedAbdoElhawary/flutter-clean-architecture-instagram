import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/presentation/screens/web_screen_layout.dart';

class InstagramLogo extends StatelessWidget {
  final Color? color;
  final bool enableOnTapForWeb;
  const InstagramLogo({Key? key, this.color, this.enableOnTapForWeb = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: enableOnTapForWeb
            ? () => Get.offAll(const WebScreenLayout())
            : null,
        child: SvgPicture.asset(
          IconsAssets.instagramLogo,
          height: 32,
          colorFilter: ColorFilter.mode(
              color ?? Theme.of(context).focusColor, BlendMode.srcIn),
        ),
      );
}

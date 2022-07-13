import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';

class InstagramLogo extends StatelessWidget {
  const InstagramLogo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        IconsAssets.instagramLogo,
        height: 32,
        color: Theme.of(context).focusColor,
      );
}

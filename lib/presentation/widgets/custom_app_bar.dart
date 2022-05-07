import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/resources/assets_manager.dart';

AppBar customAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    centerTitle: false,
    iconTheme: IconThemeData(color: Theme.of(context).focusColor),
    title: SvgPicture.asset(
      IconsAssets.instagramLogo,
      height: 32,
      color: Theme.of(context).focusColor,
    ),
    actions: [
      IconButton(
        icon: SvgPicture.asset(
          IconsAssets.addIcon,
          color: Theme.of(context).focusColor,
          height: 22.5,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: SvgPicture.asset(
          IconsAssets.heartIcon,
          color: Theme.of(context).focusColor,
          height: 22.5,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: SvgPicture.asset(
          IconsAssets.send1Icon,
          color: Theme.of(context).focusColor,
          height: 22.5,
        ),
        onPressed: () {},
      )
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/resources/assets_manager.dart';

AppBar customAppBar () {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      title: SvgPicture.asset(
        IconsAssets.instagramLogo,
        height: 32,
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            IconsAssets.addIcon,
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            IconsAssets.heartIcon,
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            IconsAssets.sendIcon,
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        )
      ],
    );
}

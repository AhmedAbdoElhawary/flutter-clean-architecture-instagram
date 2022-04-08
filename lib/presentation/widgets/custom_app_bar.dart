import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

AppBar customAppBar () {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      title: SvgPicture.asset(
        "assets/icons/ic_instagram.svg",
        height: 32,
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/heart.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/send.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        )
      ],
    );
}

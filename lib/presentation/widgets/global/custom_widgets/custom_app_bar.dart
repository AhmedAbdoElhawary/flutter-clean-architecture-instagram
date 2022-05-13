import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/widgets/global/image_display.dart';

class CustomAppBar {
  static AppBar basicAppBar(BuildContext context) {
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

  static AppBar chattingAppBar(UserPersonalInfo userInfo, BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        children: [
          CircleAvatar(
              child: ClipOval(
                  child: ImageDisplay(
                imageUrl: userInfo.profileImageUrl,
              )),
              radius: 17),
          const SizedBox(
            width: 15,
          ),
          Text(
            userInfo.name,
            style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          )
        ],
      ),
      actions: [
        SvgPicture.asset(
          "assets/icons/phone.svg",
          height: 27,
          color: Theme.of(context).focusColor,
        ),
        const SizedBox(
          width: 20,
        ),
        SvgPicture.asset(
          "assets/icons/video_point.svg",
          height: 25,
          color: Theme.of(context).focusColor,
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  static AppBar oneTitleAppBar(BuildContext context, String text) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: Text(
        text,
        style:
            getMediumStyle(color: Theme.of(context).focusColor, fontSize: 20),
      ),
    );
  }

  static AppBar menuOfUserAppBar(
      BuildContext context, String text, AsyncCallback bottomSheet) {
    return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(text,
            style: getMediumStyle(
                color: Theme.of(context).focusColor, fontSize: 20)),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.menuHorizontalIcon,
              color: Theme.of(context).focusColor,
              height: 22.5,
            ),
            onPressed: () => bottomSheet,
          ),
          const SizedBox(width: 5)
        ]);
  }
}

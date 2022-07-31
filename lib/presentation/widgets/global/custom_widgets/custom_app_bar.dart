import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/widgets/svg_pictures.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/pages/activity/activity_for_mobile.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/custom_gallery/create_new_story.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';

class CustomAppBar {
  static AppBar basicAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: const InstagramLogo(),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            IconsAssets.favorite,
            color: Theme.of(context).focusColor,
            height: 30,
          ),
          onPressed: () {
            pushToPage(context, page: const ActivityPage(), withoutRoot: false);
          },
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  static void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        _pushToCustomGallery(context);
        break;
      case 1:
        pushToPage(context, page: const CreateNewStory());
        break;
      case 2:
        _pushToCustomGallery(context);
        break;
      case 3:
    }
  }

  static Future _pushToCustomGallery(BuildContext context) =>
  pushToPage(context, page: const CustomGalleryDisplay());


  static AppBar chattingAppBar(
      UserPersonalInfo userInfo, BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        children: [
          CircleAvatar(
              child: ClipOval(
                  child: NetworkImageDisplay(
                imageUrl: userInfo.profileImageUrl,
              )),
              radius: 17),
          const SizedBox(width: 15),
          Text(
            userInfo.name,
            style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        SvgPicture.asset(
          IconsAssets.phone,
          height: 27,
          color: Theme.of(context).focusColor,
        ),
        const SizedBox(
          width: 20,
        ),
        SvgPicture.asset(
          IconsAssets.videoPoint,
          height: 25,
          color: Theme.of(context).focusColor,
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  static AppBar oneTitleAppBar(BuildContext context, String text,
      {bool logoOfInstagram = false}) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: logoOfInstagram
          ? const InstagramLogo()
          : Text(
              text,
              style: getMediumStyle(
                  color: Theme.of(context).focusColor, fontSize: 20),
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

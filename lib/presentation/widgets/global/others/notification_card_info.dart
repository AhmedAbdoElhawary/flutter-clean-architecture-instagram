import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/child_classes_with_entities/notification.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/get_post_info.dart';

class NotificationCardInfo extends StatelessWidget {
  final CustomNotification notificationInfo;
  const NotificationCardInfo({Key? key, required this.notificationInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String reformatDate = DateOfNow.commentsDateOfNow(notificationInfo.time);
    List<String> hashOfUserName = hashUserName(notificationInfo.text);

    return InkWell(
      onTap: () async {
        await pushToPage(context,
            page: WhichProfilePage(userId: notificationInfo.senderId),
            withoutRoot: false);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            start: 15, top: 15, end: 15, bottom: !isThatMobile ? 5 : 0),
        child: Row(children: [
          CircleAvatar(
            backgroundColor: ColorManager.customGrey,
            backgroundImage: CachedNetworkImageProvider(
                notificationInfo.personalProfileImageUrl),
            child: null,
            radius: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${notificationInfo.personalUserName} ",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  if (hashOfUserName.isNotEmpty) ...[
                    TextSpan(
                      text: "${hashOfUserName[0]} ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text: "${hashOfUserName[1]} ",
                      style: getNormalStyle(color: ColorManager.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          String userName =
                              hashOfUserName[1].replaceAll('@', '');
                          await pushToPage(context,
                              page: WhichProfilePage(userName: userName));
                        },
                    ),
                    TextSpan(
                      text: "${hashOfUserName[2]} ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ] else ...[
                    TextSpan(
                      text: "${notificationInfo.text} ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  TextSpan(
                    text: reformatDate,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (notificationInfo.isThatPost &&
              notificationInfo.postImageUrl.isNotEmpty)
            GestureDetector(
              onTap: () {
                String appBarText;
                if (notificationInfo.isThatPost &&
                    notificationInfo.isThatLike) {
                  appBarText = StringsManager.post.tr;
                } else {
                  appBarText = StringsManager.comments.tr;
                }
                if (isThatMobile) {
                  pushToPage(context,
                      page: GetsPostInfoAndDisplay(
                        postId: notificationInfo.postId,
                        appBarText: appBarText,
                      ),
                      withoutRoot: false);
                } else {
                  Navigator.of(context).push(HeroDialogRoute(
                    builder: (context) => GetsPostInfoAndDisplay(
                      postId: notificationInfo.postId,
                      appBarText: appBarText,
                      fromHeroRoute: true,
                    ),
                  ));
                }
              },
              child: Image.network(notificationInfo.postImageUrl,
                  height: 45, width: 45),
            ),
        ]),
      ),
    );
  }

  List<String> hashUserName(String text) {
    List<String> splitText = text.split(":");
    if (splitText.length > 1 && splitText[1][1] == "@") {
      List<String> hashName = splitText[1].split(" ");
      if (hashName.isNotEmpty) {
        return ["${splitText[0]}:", hashName[1], hashName[2]];
      }
    }
    return [];
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/notification.dart';
import 'package:instagram/presentation/pages/profile/widgets/which_profile_page.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/get_post_info.dart';

class NotificationCardInfo extends StatefulWidget {
  final CustomNotification notificationInfo;
  const NotificationCardInfo({Key? key, required this.notificationInfo})
      : super(key: key);

  @override
  State<NotificationCardInfo> createState() => _NotificationCardInfoState();
}

class _NotificationCardInfoState extends State<NotificationCardInfo> {
  late String profileImage;

  @override
  void initState() {
    profileImage = widget.notificationInfo.personalProfileImageUrl;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (profileImage.isNotEmpty) {
      precacheImage(NetworkImage(profileImage), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String reformatDate =
        DateReformat.oneDigitFormat(widget.notificationInfo.time);
    List<String> hashOfUserName = hashUserName(widget.notificationInfo.text);
    return InkWell(
      onTap: () async {
        await Go(context).push(
            page: WhichProfilePage(userId: widget.notificationInfo.senderId),
            withoutRoot: false);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            start: 15, top: 15, end: 15, bottom: !isThatMobile ? 5 : 0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: ColorManager.customGrey,
              backgroundImage: profileImage.isNotEmpty
                  ? CachedNetworkImageProvider(profileImage,
                      maxWidth: 165, maxHeight: 165)
                  : null,
              radius: 25,
              child: profileImage.isEmpty
                  ? Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                      size: 25,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "${widget.notificationInfo.personalUserName} ",
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
                            await Go(context).push(
                                page: WhichProfilePage(userName: userName));
                          },
                      ),
                      TextSpan(
                        text: "${hashOfUserName[2]} ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ] else ...[
                      TextSpan(
                        text: "${widget.notificationInfo.text} ",
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
            if (widget.notificationInfo.isThatPost &&
                widget.notificationInfo.postImageUrl.isNotEmpty)
              GestureDetector(
                onTap: () {
                  String appBarText;
                  if (widget.notificationInfo.isThatPost &&
                      widget.notificationInfo.isThatLike) {
                    appBarText = StringsManager.post.tr;
                  } else {
                    appBarText = StringsManager.comments.tr;
                  }
                  if (isThatMobile) {
                    Go(context).push(
                        page: GetsPostInfoAndDisplay(
                          postId: widget.notificationInfo.postId,
                          appBarText: appBarText,
                        ));
                  } else {
                    Navigator.of(context).push(HeroDialogRoute(
                      builder: (context) => GetsPostInfoAndDisplay(
                        postId: widget.notificationInfo.postId,
                        appBarText: appBarText,
                        fromHeroRoute: true,
                      ),
                    ));
                  }
                },
                child: NetworkDisplay(
                  url: widget.notificationInfo.postImageUrl,
                  height: 45,
                  width: 45,
                  cachingHeight: 90,
                  cachingWidth: 90,
                ),
              ),
          ],
        ),
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

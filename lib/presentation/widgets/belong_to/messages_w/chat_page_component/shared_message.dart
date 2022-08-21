import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/translations/app_lang.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/get_post_info.dart';

class SharedMessage extends StatelessWidget {
  final Message messageInfo;
  final bool isThatMine;
  const SharedMessage({
    Key? key,
    required this.messageInfo,
    required this.isThatMine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sharedMessage(context);
  }

  Widget sharedMessage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushToPage(context,
            page: GetsPostInfoAndDisplay(
              postId: messageInfo.postId,
              appBarText: StringsManager.post.tr,
            ),
            withoutRoot: false);
      },
      child: SizedBox(
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _createPhotoTitle(context),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  color: Theme.of(context).textTheme.subtitle2!.color,
                  width: double.infinity,
                  child: NetworkImageDisplay(
                    blurHash: messageInfo.blurHash,
                    imageUrl: messageInfo.imageUrl,
                    height: 270,
                  ),
                ),
                if (messageInfo.multiImages)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.collections_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (messageInfo.isThatVideo)
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Icon(
                        Icons.slow_motion_video_sharp,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            _createActionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _createPhotoTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(
          bottom: 5, top: 5, end: 10, start: 15),
      height: 50,
      width: double.infinity,
      color: Theme.of(context).textTheme.subtitle2!.color,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorManager.customGrey,
            backgroundImage: messageInfo.imageUrl.isNotEmpty
                ? CachedNetworkImageProvider(messageInfo.profileImageUrl)
                : null,
            radius: 15,
            child: messageInfo.imageUrl.isEmpty
                ? Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 15,
                  )
                : null,
          ),
          const SizedBox(width: 7),
          Text(
            messageInfo.userNameOfSharedPost,
            style: getBoldStyle(
              color: Theme.of(context).focusColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createActionBar(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(bottom: 5, top: 5, start: 15),
      color: Theme.of(context).textTheme.subtitle2!.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<AppLanguage>(
              init: AppLanguage(),
              builder: (controller) {
                return Text(
                  controller.appLocale == 'en'
                      ? "${messageInfo.userNameOfSharedPost} ${messageInfo.message}"
                      : "${messageInfo.message} ${messageInfo.userNameOfSharedPost}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getNormalStyle(color: Theme.of(context).focusColor),
                );
              }),
        ],
      ),
    );
  }
}

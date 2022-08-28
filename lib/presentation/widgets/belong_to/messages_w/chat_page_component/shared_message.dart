import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/translations/app_lang.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/get_post_info.dart';

class SharedMessage extends StatelessWidget {
  final Message messageInfo;
  final bool isThatMe;
  const SharedMessage({
    Key? key,
    required this.messageInfo,
    required this.isThatMe,
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
              postId: messageInfo.sharedPostId,
              appBarText: StringsManager.post.tr,
            ),
            withoutRoot: false);
      },
      child: SizedBox(
        width: 240,
        child: BlocBuilder<UserInfoCubit, UserInfoState>(
            buildWhen: (previous, current) =>
                previous != current && current is CubitUserLoaded,
            bloc: UserInfoCubit.get(context)
              ..getUserInfo(messageInfo.senderId, isThatMyPersonalId: false),
            builder: (context, state) {
              UserPersonalInfo? userInfo;
              if (state is CubitUserLoaded) userInfo = state.userPersonalInfo;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _createPhotoTitle(context, userInfo),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        color: Theme.of(context).textTheme.titleSmall!.color,
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
                  _createActionBar(context, userInfo),
                ],
              );
            }),
      ),
    );
  }

  Widget _createPhotoTitle(BuildContext context, UserPersonalInfo? userInfo) {
    return Container(
      padding: const EdgeInsetsDirectional.only(
          bottom: 5, top: 5, end: 10, start: 15),
      height: 50,
      width: double.infinity,
      color: Theme.of(context).textTheme.titleSmall!.color,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorManager.customGrey,
            backgroundImage: messageInfo.imageUrl.isNotEmpty && userInfo != null
                ? CachedNetworkImageProvider(userInfo.profileImageUrl)
                : null,
            radius: 15,
            child: messageInfo.imageUrl.isEmpty && userInfo == null
                ? Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 15,
                  )
                : null,
          ),
          const SizedBox(width: 7),
          Text(
            userInfo?.name ?? "",
            style: getBoldStyle(
              color: Theme.of(context).focusColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createActionBar(BuildContext context, UserPersonalInfo? userInfo) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(bottom: 5, top: 5, start: 15),
      color: Theme.of(context).textTheme.titleSmall!.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<AppLanguage>(
              init: AppLanguage(),
              builder: (controller) {
                return Text(
                  controller.appLocale == 'en'
                      ? "${userInfo?.name} ${messageInfo.message}"
                      : "${messageInfo.message} ${userInfo?.name}",
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

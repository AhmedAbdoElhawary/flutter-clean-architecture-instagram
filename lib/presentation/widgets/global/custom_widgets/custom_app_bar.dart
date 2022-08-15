import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/widgets/svg_pictures.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/myPersonalInfo/my_personal_info_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/pages/activity/activity_for_mobile.dart';
import 'package:instagram/presentation/pages/messages/messages_page_for_mobile.dart';
import 'package:instagram/presentation/pages/messages/wait_call_page.dart';
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
        _addList(context),
        _favoriteButton(context),
        _messengerButton(context),
        const SizedBox(width: 5),
      ],
    );
  }

  static Widget _messengerButton(BuildContext context) {
    return BlocBuilder<MyPersonalInfoBloc, MyPersonalInfoState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 5.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  IconsAssets.messengerIcon,
                  color: Theme.of(context).focusColor,
                  height: 22.5,
                ),
                if (state is MyPersonalInfoLoaded &&
                    state.myPersonalInfoInReelTime.numberOfNewMessages > 0)
                  _redPoint(),
              ],
            ),
            onTap: () {
              pushToPage(context,
                  page: BlocProvider<UsersInfoCubit>(
                    create: (context) => injector<UsersInfoCubit>(),
                    child: const MessagesPageForMobile(),
                  ));
            },
          ),
        );
      },
    );
  }

  static Positioned _redPoint() {
    return Positioned(
      right: 1.5,
      top: 15,
      child: Container(
        width: 10,
        height: 10,
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      ),
    );
  }

  static Widget _favoriteButton(BuildContext context) {
    return BlocBuilder<MyPersonalInfoBloc, MyPersonalInfoState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 13.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  IconsAssets.favorite,
                  color: Theme.of(context).focusColor,
                  height: 30,
                ),
                if (state is MyPersonalInfoLoaded &&
                    state.myPersonalInfoInReelTime.numberOfNewNotifications > 0)
                  _redPoint(),
              ],
            ),
            onTap: () {
              pushToPage(context,
                  page: const ActivityPage(), withoutRoot: false);
            },
          ),
        );
      },
    );
  }

  static Padding _addList(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 13.0),
      child: PopupMenuButton<int>(
        position: PopupMenuPosition.under,
        elevation: 20,
        color: Theme.of(context).splashColor,
        offset: const Offset(90, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SvgPicture.asset(
          IconsAssets.add2Icon,
          color: Theme.of(context).focusColor,
          height: 22.5,
        ),
        onSelected: (item) => onSelected(context, item),
        itemBuilder: (context) => [
          PopupMenuItem<int>(
            value: 0,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    StringsManager.post.tr(),
                    style: getMediumStyle(color: Theme.of(context).focusColor),
                  ),
                ),
                const SizedBox(width: 25),
                const Icon(Icons.grid_on_sharp),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    StringsManager.story.tr(),
                    style: getMediumStyle(color: Theme.of(context).focusColor),
                  ),
                ),
                SvgPicture.asset(
                  IconsAssets.addInstagramStoryIcon,
                  color: Theme.of(context).focusColor,
                  height: 25,
                ),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    StringsManager.reel.tr(),
                    style: getMediumStyle(color: Theme.of(context).focusColor),
                  ),
                ),
                SvgPicture.asset(
                  IconsAssets.videoIcon,
                  color: Theme.of(context).focusColor,
                  height: 25,
                ),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    StringsManager.live.tr(),
                    style: getMediumStyle(color: Theme.of(context).focusColor),
                  ),
                ),
                SvgPicture.asset(
                  IconsAssets.instagramHighlightStoryIcon,
                  color: Theme.of(context).focusColor,
                  height: 25,
                ),
              ],
            ),
          ),
        ],
      ),
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
            radius: 17,
            child: ClipOval(
              child: NetworkImageDisplay(
                imageUrl: userInfo.profileImageUrl,
              ),
            ),
          ),
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
        GestureDetector(
          child: SvgPicture.asset(
            IconsAssets.phone,
            height: 27,
            color: Theme.of(context).focusColor,
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () async {
            UserPersonalInfo myPersonalInfo =
                UserInfoCubit.getMyPersonalInfo(context);
            amICalling = true;
              pushToPage(context,
                  page: VideoCallPage(
                      userInfo: userInfo, myPersonalInfo: myPersonalInfo),
                  withoutRoot: false,
                  withoutPageTransition: true);
          },
          child: SvgPicture.asset(
            IconsAssets.videoPoint,
            height: 25,
            color: Theme.of(context).focusColor,
          ),
        ),
        const SizedBox(width: 15),
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

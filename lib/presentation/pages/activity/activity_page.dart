import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/notification.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/notification/notification_cubit.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/show_me_the_users.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/get_post_info.dart';

class ActivityPage extends StatelessWidget {
  final ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);
  final UserPersonalInfo myPersonalInfo;
  ActivityPage({Key? key, required this.myPersonalInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:isThatMobile? AppBar(
        title: const Text('Activity'),
      ):null,
      body: BlocBuilder<FirestoreUserInfoCubit, FirestoreUserInfoState>(
        bloc: FirestoreUserInfoCubit.get(context)
          ..getAllUnFollowersUsers(myPersonalInfo),
        buildWhen: (previous, current) =>
            (previous != current && current is CubitAllUnFollowersUserLoaded),
        builder: (context, unFollowersState) {
          return SingleChildScrollView(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              bloc: NotificationCubit.get(context)
                ..getNotifications(userId: myPersonalId),
              buildWhen: (previous, current) =>
                  (previous != current && current is NotificationLoaded),
              builder: (context, notificationState) {
                if (unFollowersState is CubitAllUnFollowersUserLoaded &&
                    notificationState is NotificationLoaded) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (notificationState.notifications.isNotEmpty)
                        _ShowNotifications(
                          notifications: notificationState.notifications,
                        ),
                      if (unFollowersState.usersInfo.isNotEmpty) ...[
                        suggestionForYouText(context),
                        ShowMeTheUsers(
                          usersInfo: unFollowersState.usersInfo,
                          userInfo: ValueNotifier(myPersonalInfo),
                          showColorfulCircle: false,
                          emptyText: StringsManager.noActivity.tr(),
                        ),
                      ],
                    ],
                  );
                } else if (notificationState is NotificationFailed &&
                    unFollowersState is CubitAllUnFollowersUserLoaded) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      suggestionForYouText(context),
                      ShowMeTheUsers(
                        usersInfo: unFollowersState.usersInfo,
                        userInfo: ValueNotifier(myPersonalInfo),
                        showColorfulCircle: false,
                        emptyText: StringsManager.noActivity.tr(),
                      ),
                    ],
                  );
                } else if (unFollowersState is CubitGetUserInfoFailed &&
                    notificationState is NotificationLoaded) {
                  return _ShowNotifications(
                    notifications: notificationState.notifications,
                  );
                } else if (notificationState is NotificationFailed &&
                    unFollowersState is CubitGetUserInfoFailed) {
                  ToastShow.toast(notificationState.error);
                  return Center(
                    child: Text(
                      StringsManager.somethingWrong.tr(),
                      style:
                          getNormalStyle(color: Theme.of(context).focusColor),
                    ),
                  );
                }
                return const ThineCircularProgress();
              },
            ),
          );
        },
      ),
    );
  }

  Padding suggestionForYouText(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(15),
      child: Text(
        StringsManager.suggestionsForYou.tr(),
        style:
            getMediumStyle(color: Theme.of(context).focusColor, fontSize: 16),
      ),
    );
  }
}

class _ShowNotifications extends StatefulWidget {
  final List<CustomNotification> notifications;

  const _ShowNotifications({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  @override
  State<_ShowNotifications> createState() => _ShowNotificationsState();
}

class _ShowNotificationsState extends State<_ShowNotifications> {
  late UserPersonalInfo myPersonalInfo;
  @override
  initState() {
    myPersonalInfo = FirestoreUserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notifications.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
          return containerOfUserInfo(widget.notifications[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: widget.notifications.length,
      );
    } else {
      return Center(
        child: Text(
          StringsManager.noActivity.tr(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }
  }

  List<String> hashUserName(String text) {
    List<String> splitText = text.split(":");
    if (splitText.length > 1 && splitText[1][1] == "@") {
      List<String> hashName = splitText[1].split(" ");
      if (hashName.isNotEmpty) {
        return [splitText[0] + ":", hashName[1], hashName[2]];
      }
    }
    return [];
  }

  Widget containerOfUserInfo(CustomNotification notificationInfo) {
    double bodyHeight = MediaQuery.of(context).size.height;
    String reformatDate = DateOfNow.commentsDateOfNow(notificationInfo.time);
    List<String> hashOfUserName = hashUserName(notificationInfo.text);

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WhichProfilePage(
              userId: notificationInfo.senderId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 15, top: 15, end: 15),
        child: Row(children: [
          CircleAvatar(
            backgroundColor: ColorManager.customGrey,
            backgroundImage: CachedNetworkImageProvider(
                notificationInfo.personalProfileImageUrl),
            child: null,
            radius: bodyHeight * .040,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${notificationInfo.personalUserName} ",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  if (hashOfUserName.isNotEmpty) ...[
                    TextSpan(
                      text: "${hashOfUserName[0]} ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    TextSpan(
                      text: "${hashOfUserName[1]} ",
                      style: getNormalStyle(color: ColorManager.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          String userName =
                              hashOfUserName[1].replaceAll('@', '');
                          await Navigator.of(
                            context,
                          ).push(CupertinoPageRoute(
                              builder: (context) => WhichProfilePage(
                                    userName: userName,
                                  ),
                              maintainState: false));
                        },
                    ),
                    TextSpan(
                      text: "${hashOfUserName[2]} ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ] else ...[
                    TextSpan(
                      text: "${notificationInfo.text} ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                  TextSpan(
                    text: reformatDate,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (notificationInfo.isThatPost)
            GestureDetector(
              onTap: () {
                String appBarText;
               if (notificationInfo.isThatPost&&notificationInfo.isThatLike){
                  appBarText=StringsManager.post.tr();
                }else{
                 appBarText=StringsManager.comments.tr();

               }
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => GetsPostInfoAndDisplay(
                    postId: notificationInfo.postId,
                    appBarText: appBarText,
                  ),
                ));
              },
              child: Image.network(notificationInfo.postImageUrl,
                  height: 45, width: 45),
            ),
        ]),
      ),
    );
  }
}

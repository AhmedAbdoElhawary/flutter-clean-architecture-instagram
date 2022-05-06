import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import '../cubit/followCubit/follow_cubit.dart';
import 'circle_avatar_of_profile_image.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/presentation/pages/which_profile_page.dart';

class ShowMeTheUsers extends StatefulWidget {
  final List<UserPersonalInfo> usersInfo;
  final bool isThatFollower;
  final UserPersonalInfo? userInfo;
  final ValueChanged<bool> rebuildVariable;
  final bool showSearchBar;

  const ShowMeTheUsers(
      {Key? key,
      required this.usersInfo,
      required this.isThatFollower,
      required this.showSearchBar,
      this.userInfo,
      required this.rebuildVariable})
      : super(key: key);

  @override
  State<ShowMeTheUsers> createState() => _ShowMeTheUsersState();
}

class _ShowMeTheUsersState extends State<ShowMeTheUsers> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          widget.usersInfo.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return containerOfUserInfo(
                        widget.usersInfo[index], widget.isThatFollower);
                  },
                  itemCount: widget.usersInfo.length)
              : Container(),
        ],
      ),
    );
  }

  Widget containerOfUserInfo(UserPersonalInfo userInfo, bool isThatFollower) {
    String hash = "${userInfo.userId.hashCode}userInfo";
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WhichProfilePage(
                  userId: userInfo.userId,
                )));
      },
      child: Row(children: [
        Hero(
          tag: hash,
          child: CircleAvatarOfProfileImage(
            bodyHeight: 600,
            hashTag: hash,
            userInfo: userInfo,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo.userName,
                style:  Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 5),
              Text(
                userInfo.name,
                style: Theme.of(context).textTheme.headline1,
              )
            ],
          ),
        ),
        followButton(userInfo, isThatFollower),
      ]),
    );
  }

  Widget followButton(UserPersonalInfo userInfo, bool isThatFollower) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (followContext, stateOfFollow) {
        return Expanded(
          child: Builder(builder: (userContext) {
            if (myPersonalId == userInfo.userId) {
              return Container();
            } else {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 15.0),
                child: InkWell(
                    onTap: () async {
                      widget.rebuildVariable(false);

                      if (userInfo.followerPeople.contains(myPersonalId)) {
                        BlocProvider.of<FollowCubit>(followContext)
                            .removeThisFollower(
                                followingUserId: userInfo.userId,
                                myPersonalId: myPersonalId);
                        // TODO it's not prefect (not listing in all behind pages when you push to several pages) try to solve it
                        // TODO here ============================================================================================
                        if (widget.userInfo != null) {
                          if (myPersonalId == widget.userInfo!.userId) {
                            setState(() {
                              if (isThatFollower) {
                                widget.userInfo!.followerPeople
                                    .remove(userInfo.userId);
                              } else {
                                widget.userInfo!.followedPeople
                                    .remove(userInfo.userId);
                              }
                            });
                          }
                        }
                      } else {
                        BlocProvider.of<FollowCubit>(followContext)
                            .followThisUser(
                                followingUserId: userInfo.userId,
                                myPersonalId: myPersonalId);
                      }
                      widget.rebuildVariable(true);
                    },
                    child: whichContainerOfText(stateOfFollow, userInfo)),
              );
            }
          }),
        );
      },
    );
  }

  Widget whichContainerOfText(
      FollowState stateOfFollow, UserPersonalInfo userInfo) {
    bool isFollowLoading = stateOfFollow is CubitFollowThisUserLoading;

    if (stateOfFollow is CubitFollowThisUserFailed) {
      ToastShow.toastStateError(stateOfFollow);
    }
    return !userInfo.followerPeople.contains(myPersonalId)
        ? containerOfFollowText(
            text: StringsManager.follow.tr(),
            isThatFollower: false,
            isItLoading: isFollowLoading)
        : containerOfFollowText(
            text: StringsManager.following.tr(),
            isThatFollower: true,
            isItLoading: isFollowLoading);
  }

  Container containerOfFollowText(
      {required String text,
      required bool isThatFollower,
      required bool isItLoading}) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: isThatFollower ?  Theme.of(context).primaryColor : ColorManager.blue,
        border:
            Border.all(color: Theme.of(context).cardColor, width: isThatFollower ? 1.0 : 0),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: isItLoading
            ? CircularProgressIndicator(
                color: isThatFollower ? Theme.of(context).focusColor :Theme.of(context).primaryColor,
                strokeWidth: 1,
              )
            : Text(
                text,
                style: TextStyle(
                    fontSize: 17.0,
                    color: isThatFollower ? Theme.of(context).focusColor : ColorManager.white,
                    fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}

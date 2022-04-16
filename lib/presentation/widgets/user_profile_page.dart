import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/injector.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/massage/massage_cubit.dart';
import 'package:instegram/presentation/cubit/followCubit/follow_cubit.dart';
import 'package:instegram/presentation/pages/texting_page.dart';
import 'package:instegram/presentation/widgets/profile_page.dart';
import 'package:instegram/presentation/widgets/recommendation_people.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import '../../core/constant.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final String userName;

  const UserProfilePage({Key? key, required this.userId, this.userName = ''})
      : super(key: key);

  @override
  State<UserProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage>
    with AutomaticKeepAliveClientMixin {
  bool rebuildUserInfo = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return scaffold();
  }

  Widget scaffold() {
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
      bloc: widget.userName.isNotEmpty
          ? (BlocProvider.of<FirestoreUserInfoCubit>(context)
            ..getUserFromUserName(widget.userName))
          : (BlocProvider.of<FirestoreUserInfoCubit>(context)
            ..getUserInfo(widget.userId, false)),
      buildWhen: (previous, current) {
        if (previous != current && current is CubitUserLoaded) {
          return true;
        }
        if (rebuildUserInfo && current is CubitUserLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CubitUserLoaded) {
          return Scaffold(
            appBar: appBar(state.userPersonalInfo.userName),
            body: ProfilePage(
              isThatMyPersonalId: false,
              userId: widget.userId,
              userInfo: state.userPersonalInfo,
              widgetsAboveTapBars:
                  widgetsAboveTapBars(state.userPersonalInfo, state),
            ),
          );
        } else if (state is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(state);
          return const Text("Something Wrong");
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 1, color: Colors.black54),
          );
        }
      },
    );
  }

  AppBar appBar(String userName) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(userName),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/menu_horizontal.svg",
              color: Colors.black,
              height: 22.5,
            ),
            onPressed: () => bottomSheetOfAdd(),
          ),
          const SizedBox(width: 5)
        ]);
  }

  Future<void> bottomSheetOfAdd() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: listOfAddPost(),
        );
      },
    );
  }

  Column listOfAddPost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SvgPicture.asset(
          "assets/icons/minus.svg",
          color: Colors.black54,
          height: 40,
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textOfBottomSheet('Report...'),
              const SizedBox(height: 15),
              textOfBottomSheet('Block'),
              const SizedBox(height: 15),
              textOfBottomSheet('About this account'),
              const SizedBox(height: 15),
              textOfBottomSheet('Restrict'),
              const SizedBox(height: 15),
              textOfBottomSheet('Hide your story'),
              const SizedBox(height: 15),
              textOfBottomSheet('Copy profile URL'),
              const SizedBox(height: 15),
              textOfBottomSheet('Share this profile'),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }

  Text textOfBottomSheet(String text) {
    return Text(text, style: const TextStyle(fontSize: 15));
  }

  List<Widget> widgetsAboveTapBars(
      UserPersonalInfo userInfo, FirestoreGetUserInfoState userInfoState) {
    return [
      followButton(userInfo, userInfoState),
      const SizedBox(width: 5),
      massageButton(userInfo),
      const SizedBox(width: 5),
      const RecommendationPeople(),
      const SizedBox(width: 10),
    ];
  }

  Widget followButton(
      UserPersonalInfo userInfo, FirestoreGetUserInfoState userInfoState) {
    return BlocBuilder<FollowCubit, FollowState>(
      // buildWhen: ,
      builder: (context, stateOfFollow) {
        return Expanded(
          child: InkWell(
              onTap: () async {
                setState(() {
                  rebuildUserInfo = false;
                });
                if (userInfo.followerPeople.contains(myPersonalId)) {
                  BlocProvider.of<FollowCubit>(context).removeThisFollower(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);
                } else {
                  BlocProvider.of<FollowCubit>(context).followThisUser(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);
                }

                setState(() {
                  rebuildUserInfo = true;
                });
              },
              child: whichContainerOfText(stateOfFollow, userInfo)),
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
            text: 'Follow', isThatFollower: false, isItLoading: isFollowLoading)
        : containerOfFollowText(
            text: 'Following',
            isThatFollower: true,
            isItLoading: isFollowLoading);
  }

  Expanded massageButton(UserPersonalInfo userInfo) {
    return Expanded(
      child: BlocProvider<MassageCubit>(
        create: (context) => injector<MassageCubit>(),
        child: GestureDetector(
          onTap: () async {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(
              builder: (context) => TextingPage(
                userInfo: userInfo,
              ),
              maintainState: false,
            ));
          },
          child: containerOfFollowText(
              text: 'Massage', isThatFollower: true, isItLoading: false),
        ),
      ),
    );
  }

  Container containerOfFollowText(
      {required String text,
      required bool isThatFollower,
      required bool isItLoading}) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: isThatFollower ? Colors.white : Colors.blue,
        border:
            Border.all(color: Colors.black26, width: isThatFollower ? 1.0 : 0),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: isItLoading
            ? CircularProgressIndicator(
                color: isThatFollower ? Colors.black : Colors.white,
                strokeWidth: 1,
              )
            : Text(
                text,
                style: TextStyle(
                    fontSize: 17.0,
                    color: isThatFollower ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

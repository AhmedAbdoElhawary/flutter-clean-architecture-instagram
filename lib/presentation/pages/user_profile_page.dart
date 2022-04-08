import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/presentation/widgets/profile_page.dart';
import 'package:instegram/presentation/widgets/recommendation_people.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  const UserProfilePage(this.userId, {Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return scaffold();
  }

  Widget scaffold() {
    return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
      bloc: BlocProvider.of<FirestoreUserInfoCubit>(context)
        ..getUserInfo(widget.userId, false),
      buildWhen: (previous, current) =>
          previous != current && current is CubitUserLoaded,
      builder: (context, state) {
        if (state is CubitUserLoaded) {
          return Scaffold(
            appBar: appBar(state.userPersonalInfo.userName),
            body: ProfilePage(
              isThatMyPersonalId: false,
              userId: widget.userId,
              userInfo: state.userPersonalInfo,
              widgetsAboveTapBars: widgetsAboveTapBars(state.userPersonalInfo),
            ),
          );
        } else if (state is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(state);
          return const Text("there is no posts...");
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

  List<Widget> widgetsAboveTapBars(UserPersonalInfo userInfo) {
    return [
      followButton(userInfo),
      const SizedBox(width: 5),
      massageButton(userInfo),
      const SizedBox(width: 5),
      const RecommendationPeople(),
      const SizedBox(width: 10),
    ];
  }
bool isIFollowed=false;
  Expanded followButton(UserPersonalInfo userInfo) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          setState(() {
            isIFollowed=!isIFollowed;
          });
        },
        child:isIFollowed? containerOfWhiteText('Following'):containerOfBlueText('Follow'),
      ),
    );
  }

  Container containerOfBlueText(String text) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: Colors.blue,
        // border: Border.all(color: Colors.black26, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child:  Center(
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Expanded massageButton(UserPersonalInfo userInfo) {
    return Expanded(
      child: InkWell(
        onTap: () async {},
        child: containerOfWhiteText('Massage'),
      ),
    );
  }

  Container containerOfWhiteText(String text) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/entities/calling_status.dart';
import 'package:instagram/flutter_try.dart';
import 'package:instagram/presentation/cubit/callingRooms/calling_rooms_cubit.dart';

class VideoCallPage extends StatelessWidget {
  final UserPersonalInfo userInfo;
  final UserPersonalInfo myPersonalInfo;

  const VideoCallPage({
    Key? key,
    required this.userInfo,
    required this.myPersonalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorManager.lowOpacityGrey,
      body: SafeArea(
        child: BlocBuilder<CallingRoomsCubit, CallingRoomsState>(
          bloc: CallingRoomsCubit.get(context)
            ..createCallingRoom(
                myPersonalInfo: myPersonalInfo,
                callToThisUserId: userInfo.userId)
            ..getCallingStatus(userId: userInfo.userId)
            ..stream,
          builder: (context, state) {
            if (state is CallingStatusCanceled) {
              return const Center(
                  child: Text("Canceled",
                      style: TextStyle(fontSize: 20, color: Colors.black87)));
            } else if (state is CallingRoomsFailed) {
              if (state.error == "Busy") {
                return Center(child: Text('${userInfo.name} is Busy...'));
              } else {
                return Center(
                  child: Text(StringsManager.somethingWrong.tr()),
                );
              }
            } else if (state is CallingRoomsLoaded) {
              return CallPage(
                channelName: state.channelId,
                role: ClientRole.Broadcaster,
                userInfo: UserInfoInCallingRoom(
                  userId: userInfo.userId,
                  name: userInfo.name,
                  profileImageUrl: userInfo.profileImageUrl,
                ),
              );
            } else {
              return callingLoadingPage(size);
            }
          },
        ),
      ),
    );
  }

  Widget callingLoadingPage(Size size) {
    return Center(
      child: Text("Connecting...",
          style: getNormalStyle(color: ColorManager.black, fontSize: 25)),
    );
  }
}

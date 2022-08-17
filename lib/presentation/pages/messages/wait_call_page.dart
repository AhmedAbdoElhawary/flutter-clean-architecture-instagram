import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/entities/calling_status.dart';
import 'package:instagram/presentation/cubit/callingRooms/bloc/calling_status_bloc.dart';
import 'package:instagram/presentation/pages/messages/video_call_page.dart';
import 'package:instagram/presentation/cubit/callingRooms/calling_rooms_cubit.dart';

/// Not clean enough
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
                callToThisUserId: userInfo.userId),
          builder: (callingRoomContext, callingRoomState) {
            return BlocBuilder<CallingStatusBloc, CallingStatusState>(
              bloc: CallingStatusBloc.get(context)
                ..add(LoadCallingStatus(userInfo.userId)),
              builder: (context, state) {
                if (state is CallingStatusLoaded &&
                    state.callingStatus == false &&
                    callingRoomState is CallingRoomsLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    CallingRoomsCubit.get(context).deleteTheRoom(
                        channelId: callingRoomState.channelId,
                        userId: userInfo.userId);

                    await Future.delayed(const Duration(seconds: 2))
                        .then((value) {
                      Navigator.of(callingRoomContext).maybePop();
                    });
                  });
                  return const Center(
                      child: Text("Canceled",
                          style:
                              TextStyle(fontSize: 20, color: Colors.black87)));
                } else if (callingRoomState is CallingRoomsFailed) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await Future.delayed(const Duration(seconds: 1))
                        .then((value) {
                      Navigator.of(callingRoomContext).maybePop();
                    });
                  });
                  if (callingRoomState.error == "Busy") {
                    return Center(child: Text('${userInfo.name} is Busy...'));
                  } else {
                    return Center(
                      child: Text(StringsManager.somethingWrong.tr()),
                    );
                  }
                } else if (callingRoomState is CallingRoomsLoaded) {
                  return CallPage(
                    channelName: callingRoomState.channelId,
                    role: ClientRole.Broadcaster,
                    userCallingType: UserCallingType.sender,
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
            );
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

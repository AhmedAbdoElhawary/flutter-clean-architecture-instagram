import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:instagram/presentation/pages/messages/ringing_page.dart';
import 'package:instagram/presentation/screens/mobile_screen_layout.dart';

class PopupCalling extends StatefulWidget {
  final String userId;

  const PopupCalling(this.userId, {Key? key}) : super(key: key);

  @override
  State<PopupCalling> createState() => _PopupCallingState();
}

class _PopupCallingState extends State<PopupCalling> {
  bool isHeMoved = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
      bloc: UsersInfoReelTimeBloc.get(context)..add(LoadMyPersonalInfo()),
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is MyPersonalInfoLoaded &&
              !amICalling &&
              state.myPersonalInfoInReelTime.channelId.isNotEmpty) {
            if (!isHeMoved) {
              isHeMoved = true;
              Go(context).push(
                  page: CallingRingingPage(
                      channelId: state.myPersonalInfoInReelTime.channelId,
                      clearMoving: clearMoving),
                  withoutRoot: false);
            }
          }
        });
        return MobileScreenLayout(widget.userId);
      },
    );
  }

  clearMoving() {
    isHeMoved = false;
  }
}

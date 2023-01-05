import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/screens/responsive_layout.dart';
import 'package:instagram/presentation/screens/web_screen_layout.dart';
import 'package:instagram/presentation/pages/register/widgets/popup_calling.dart';

class GetMyPersonalInfo extends StatefulWidget {
  final String myPersonalId;
  const GetMyPersonalInfo({Key? key, required this.myPersonalId})
      : super(key: key);

  @override
  State<GetMyPersonalInfo> createState() => _GetMyPersonalInfoState();
}

class _GetMyPersonalInfoState extends State<GetMyPersonalInfo> {
  bool isHeMovedToHome = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoCubit, UserInfoState>(
      bloc: UserInfoCubit.get(context)
        ..getUserInfo(widget.myPersonalId, getDeviceToken: true),
      listenWhen: (previous, current) => previous != current,
      listener: (context, userState) {
        if (!isHeMovedToHome) {
          setState(() => isHeMovedToHome = true);

          if (userState is CubitMyPersonalInfoLoaded) {
            myPersonalId = widget.myPersonalId;
            Get.offAll(
              ResponsiveLayout(
                mobileScreenLayout: PopupCalling(myPersonalId),
                webScreenLayout: const WebScreenLayout(),
              ),
            );
          } else if (userState is CubitGetUserInfoFailed) {
            ToastShow.toastStateError(userState);
          }
        }
      },
      child: Container(color: Theme.of(context).primaryColor),
    );
  }
}

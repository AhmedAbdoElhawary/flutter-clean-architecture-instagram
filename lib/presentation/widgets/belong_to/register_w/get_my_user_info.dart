import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:instagram/core/app_prefs.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/screens/mobile_screen_layout.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/presentation/screens/responsive_layout.dart';
import 'package:instagram/presentation/screens/web_screen_layout.dart';

class GetMyPersonalInfo extends StatefulWidget {
  final String myPersonalId;
  const GetMyPersonalInfo({Key? key, required this.myPersonalId})
      : super(key: key);

  @override
  State<GetMyPersonalInfo> createState() => _GetMyPersonalInfoState();
}

class _GetMyPersonalInfoState extends State<GetMyPersonalInfo> {
  bool isHeMovedToHome = false;
  final AppPreferences _appPreferences = injector<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, FirestoreUserInfoState>(
      bloc: UserInfoCubit.get(context)
        ..getUserInfo(widget.myPersonalId,getDeviceToken: true),
      builder: (context, userState) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (userState is CubitMyPersonalInfoLoaded) {
            if (!isHeMovedToHome) {
              myPersonalId = widget.myPersonalId;
              Get.offAll(
                ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(myPersonalId),
                  webScreenLayout: const WebScreenLayout(),
                ),
              );
            }
            isHeMovedToHome = true;
          } else if (userState is CubitGetUserInfoFailed) {
            ToastShow.toastStateError(userState);
          }
        });
        return Container(
          color: Theme.of(context).primaryColor,
        );
      },
    );
  }
}

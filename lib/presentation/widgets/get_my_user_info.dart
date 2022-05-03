import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/app_prefs.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/injector.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/screens/main_screen.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

class GetMyPersonalId extends StatefulWidget {
  final String myPersonalId;
  const GetMyPersonalId({Key? key, required this.myPersonalId})
      : super(key: key);

  @override
  State<GetMyPersonalId> createState() => _GetMyPersonalIdState();
}

class _GetMyPersonalIdState extends State<GetMyPersonalId> {
  bool isHeMovedToHome = false;
  final AppPreferences _appPreferences = injector<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocBuilder<FirestoreUserInfoCubit, FirestoreGetUserInfoState>(
        bloc: FirestoreUserInfoCubit.get(context)
          ..getUserInfo(widget.myPersonalId, true),
        builder: (context, userState) {
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            if (userState is CubitMyPersonalInfoLoaded) {
              if (!isHeMovedToHome) {
                myPersonalId = widget.myPersonalId;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MainScreen(myPersonalId)));
              }
              isHeMovedToHome = true;
            } else if (userState is CubitGetUserInfoFailed) {
              ToastShow.toastStateError(userState);
            }
          });
          return Container(color: ColorManager.white,);
        },
      );
    });
  }
}

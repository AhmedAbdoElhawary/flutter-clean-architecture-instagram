import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/core/functions/toast_show.dart';

class MassagesPage extends StatelessWidget {
  const MassagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Theme.of(context).focusColor,
                size: 30,
              ))
        ],
      ),
      body: BlocBuilder<UsersInfoCubit, UsersInfoState>(
        bloc: UsersInfoCubit.get(context)
          ..getChatUsersInfo(userId: myPersonalId),
        builder: (context, state) {
          if (state is CubitGettingChatUsersInfoLoaded) {
            List<UserPersonalInfo> usersInfo=state.usersInfo;
            return ListView.separated(
                itemBuilder: (context, index) {
                  String hash = "${usersInfo[index].userId.hashCode}";

                  return ListTile(
                    title: Text(
                      usersInfo[index].name,
                      style:
                          getNormalStyle(color: Theme.of(context).focusColor),
                    ),
                    leading: Hero(
                      tag: hash,
                      child: CircleAvatarOfProfileImage(
                        bodyHeight: bodyHeight * 0.85,
                        hashTag: hash,
                        userInfo: usersInfo[index],
                      ),
                    ),
                    onTap: () {

                    },
                  );
                },
                itemCount: usersInfo.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider());
          } else if (state is CubitGettingSpecificUsersFailed) {
            ToastShow.toastStateError(state);
            return Text(
              StringsManager.somethingWrong,
              style: getNormalStyle(color: Theme.of(context).focusColor),
            );
          } else {
            return const ThineCircularProgress();
          }
        },
      ),
    );
  }
}

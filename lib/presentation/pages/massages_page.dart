import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instegram/presentation/widgets/custom_circular_progress.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

class MassagesPage extends StatelessWidget {
  final String userId;
  const MassagesPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        builder: (context, state) {
          if (state is CubitGettingSpecificUsersLoaded) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      StringsManager.theName,
                      style:
                          getNormalStyle(color: Theme.of(context).focusColor),
                    ),
                    leading: CircleAvatar(
                        child: Icon(Icons.person,
                            color: Theme.of(context).primaryColor, size: 50),
                        radius: 30),
                    onTap: () {},
                  );
                },
                itemCount: 5,
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

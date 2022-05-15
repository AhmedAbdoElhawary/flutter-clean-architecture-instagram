import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/sender_info.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/pages/messages/chatting_page.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/core/functions/toast_show.dart';

class messagesPage extends StatelessWidget {
  const messagesPage({Key? key}) : super(key: key);

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
            List<SenderInfo> usersInfo = state.usersInfo;
            return ListView.separated(
                itemBuilder: (context, index) {
                  String hash = "${usersInfo[index].userInfo!.userId.hashCode}";
                  Message theLastMessage = usersInfo[index].lastMessage;

                  return ListTile(
                    title: Text(
                      usersInfo[index].userInfo!.name,
                      style:
                          getNormalStyle(color: Theme.of(context).focusColor),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                              theLastMessage.message.isEmpty
                                  ? (theLastMessage.imageUrl.isEmpty
                                      ? "recorded sent"
                                      : "photo sent")
                                  : theLastMessage.message,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                        ),
                        const SizedBox(width: 5),
                        Text(DateOfNow.commentsDateOfNow(
                            theLastMessage.datePublished)),
                      ],
                    ),
                    leading: Hero(
                      tag: hash,
                      child: CircleAvatarOfProfileImage(
                        bodyHeight: bodyHeight * 0.85,
                        hashTag: hash,
                        userInfo: usersInfo[index].userInfo!,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push(CupertinoPageRoute(
                        builder: (context) => BlocProvider<messageBloc>(
                          create: (context) => injector<messageBloc>(),
                          child: ChattingPage(
                            userInfo: usersInfo[index].userInfo!,
                          ),
                        ),
                        maintainState: false,
                      ));
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/belong_to/messages_w/chat_messages.dart';
import 'package:instagram/presentation/widgets/belong_to/messages_w/list_of_messages.dart';

class MessagesForWeb extends StatefulWidget {
  const MessagesForWeb({Key? key}) : super(key: key);

  @override
  State<MessagesForWeb> createState() => _MessagesForWebState();
}

class _MessagesForWebState extends State<MessagesForWeb> {
  late UserPersonalInfo myPersonalInfo;
  UserPersonalInfo? selectedTextingUser;

  @override
  initState() {
    myPersonalInfo = FirestoreUserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 950,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorManager.white,
              border: Border.all(
                color: ColorManager.lowOpacityGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              children: [
                messages(),
                chatting(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatting() {
    return selectedTextingUser == null
        ? Center(
            child: Text(
              "There is no selected massage",
              style: getMediumStyle(color: ColorManager.black),
            ),
          )
        : Expanded(
            child: Column(
              children: [
                appBarOfChatting(),
                Expanded(child: chatMessages()),
              ],
            ),
          );
  }

  Widget chatMessages() {
    return BlocProvider<MessageBloc>(
      create: (context) => injector<MessageBloc>(),
      child: ChatMessages(userInfo: selectedTextingUser!),
    );
  }

  Container appBarOfChatting() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorManager.lowOpacityGrey,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Container messages() {
    return Container(
      width: 350,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: ColorManager.lowOpacityGrey,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          appBarOfMessages(),
          SingleChildScrollView(
            child: ListOfMessages(userInfo: selectChatting),
          ),
        ],
      ),
    );
  }

  void selectChatting(UserPersonalInfo userInfo) {
    setState(() {
      selectedTextingUser = userInfo;
    });
  }

  Container appBarOfMessages() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorManager.lowOpacityGrey,
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Text(myPersonalInfo.userName,
            style: getMediumStyle(color: ColorManager.black, fontSize: 17)),
      ),
    );
  }
}

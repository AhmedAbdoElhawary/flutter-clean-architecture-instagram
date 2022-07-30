import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/belong_to/messages_w/chat_messages.dart';
import 'package:instagram/presentation/widgets/belong_to/messages_w/list_of_messages.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';

class MessagesForWeb extends StatefulWidget {
  UserPersonalInfo? selectedTextingUser;

  MessagesForWeb({Key? key, this.selectedTextingUser}) : super(key: key);

  @override
  State<MessagesForWeb> createState() => _MessagesForWebState();
}

class _MessagesForWebState extends State<MessagesForWeb> {
  late UserPersonalInfo myPersonalInfo;

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
    if (widget.selectedTextingUser == null) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "There is no selected massage",
              style: getMediumStyle(color: ColorManager.black),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Column(
          children: [
            appBarOfChatting(),
            Expanded(child: chatMessages()),
          ],
        ),
      );
    }
  }

  Widget chatMessages() {
    return BlocProvider<MessageBloc>(
      create: (context) => injector<MessageBloc>(),
      child: ChatMessages(userInfo: widget.selectedTextingUser!),
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
      child: widget.selectedTextingUser != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 25),
                    CircleAvatarOfProfileImage(
                      bodyHeight: 350,
                      userInfo: widget.selectedTextingUser!,
                      showColorfulCircle: false,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      widget.selectedTextingUser!.name,
                      style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      IconsAssets.phone,
                      height: 27,
                      color: Theme.of(context).focusColor,
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      IconsAssets.videoPoint,
                      height: 25,
                      color: Theme.of(context).focusColor,
                    ),
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            )
          : null,
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
            child: ListOfMessages(
              selectChatting: selectChatting,
              additionalUser: widget.selectedTextingUser,
              freezeListView: true,
            ),
          ),
        ],
      ),
    );
  }

  void selectChatting(UserPersonalInfo userInfo) {
    setState(() {
      widget.selectedTextingUser = null;
      widget.selectedTextingUser = userInfo;
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

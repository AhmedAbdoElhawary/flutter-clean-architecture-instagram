import 'package:flutter/material.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/entities/sender_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:instagram/presentation/pages/messages/chatting_page.dart';
import 'package:instagram/presentation/pages/messages/widgets/chat_messages.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_linears_progress.dart';

class SelectForGroupChat extends StatefulWidget {
  const SelectForGroupChat({Key? key}) : super(key: key);

  @override
  State<SelectForGroupChat> createState() => _SelectForGroupChatState();
}

class _SelectForGroupChatState extends State<SelectForGroupChat> {
  final selectedUsersInfo = ValueNotifier<List<UserPersonalInfo>>([]);
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To",
                  style: getMediumStyle(
                      color: Theme.of(context).focusColor, fontSize: 17),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  child: ValueListenableBuilder(
                    valueListenable: selectedUsersInfo,
                    builder: (context,
                        List<UserPersonalInfo> selectedUsersInfoValue, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedUsersInfoValue.isEmpty) ...[
                            emptyMessage(),
                          ] else ...[
                            ...List.generate(
                              selectedUsersInfoValue.length,
                              (index) {
                                return buildSelectedUser(
                                    selectedUsersInfoValue, index);
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          buildBlocBuilder(),
        ],
      ),
    );
  }

  Padding emptyMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 17),
      child: Text(
        "Select users",
        style: getNormalStyle(color: ColorManager.grey, fontSize: 15),
      ),
    );
  }

  Padding buildSelectedUser(
      List<UserPersonalInfo> selectedUsersInfoValue, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13.5),
        decoration: BoxDecoration(
            color: ColorManager.blue,
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.blue, Color.fromARGB(255, 121, 219, 236)]),
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            selectedUsersInfoValue[index].name,
            style: getNormalStyle(color: ColorManager.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("New message",
          style: getMediumStyle(
              color: Theme.of(context).focusColor, fontSize: 18)),
      actions: [
        ValueListenableBuilder(
          valueListenable: selectedUsersInfo,
          builder:
              (context, List<UserPersonalInfo> selectedUsersInfoValue, child) =>
                  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 18),
            child: GestureDetector(
              onTap: () {
                if (selectedUsersInfoValue.isEmpty) return;

                if (selectedUsersInfoValue.length > 1) {
                  Go(context).push(
                      page: GroupMessages(
                          selectedUsersInfoValue: selectedUsersInfoValue));
                } else {
                  Go(context).push(
                      page: BlocProvider<MessageBloc>(
                    create: (context) => injector<MessageBloc>(),
                    child: ChattingPage(
                        messageDetails:
                            SenderInfo(receiversInfo: selectedUsersInfoValue)),
                  ));
                }
              },
              child: Text("Chat",
                  style: getMediumStyle(
                      color: selectedUsersInfoValue.isNotEmpty
                          ? ColorManager.blue
                          : ColorManager.lightBlue,
                      fontSize: 18)),
            ),
          ),
        )
      ],
    );
  }

  BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>
      buildBlocBuilder() {
    return BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
      bloc: UsersInfoReelTimeBloc.get(context)..add(LoadAllUsersInfoInfo()),
      buildWhen: (previous, current) =>
          previous != current && current is AllUsersInfoLoaded,
      builder: (context, state) {
        if (state is AllUsersInfoLoaded) {
          List<UserPersonalInfo> usersInfo = state.allUsersInfoInReelTime;
          return buildUsers(usersInfo);
        }
        if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Text(StringsManager.somethingWrong.tr);
        } else {
          return isThatMobile
              ? const ThineLinearProgress()
              : const Scaffold(
                  body: SizedBox(height: 1, child: ThineLinearProgress()),
                );
        }
      },
    );
  }

  Padding buildUsers(List<UserPersonalInfo> usersInfo) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 15, start: 15, top: 80.0),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        addAutomaticKeepAlives: false,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text("Suggestions",
                style: getMediumStyle(
                    color: Theme.of(context).focusColor, fontSize: 18));
          } else {
            return buildUserInfo(context, usersInfo[index]);
          }
        },
        itemCount: usersInfo.length,
        separatorBuilder: (context, _) => const SizedBox(height: 15),
      ),
    );
  }

  Widget buildUserInfo(BuildContext context, UserPersonalInfo userInfo) {
    return ValueListenableBuilder(
      valueListenable: selectedUsersInfo,
      builder: (context, List<UserPersonalInfo> selectedUsersInfoValue, child) {
        bool isUserSelected = selectedUsersInfoValue.contains(userInfo);

        return GestureDetector(
          onTap: () async {
            setState(() {
              if (!isUserSelected) {
                selectedUsersInfo.value.add(userInfo);
              } else {
                selectedUsersInfo.value.remove(userInfo);
              }
            });
            scrollController.animateTo(0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutQuart);
          },
          child: Container(
            color: ColorManager.transparent,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorManager.customGrey,
                  backgroundImage: userInfo.profileImageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(userInfo.profileImageUrl,
                          maxWidth: 120, maxHeight: 120)
                      : null,
                  radius: 30,
                  child: userInfo.profileImageUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        )
                      : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userInfo.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        userInfo.userName,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
                checkBox(context, isUserSelected),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget checkBox(BuildContext context, bool isUserSelected) {
    return Container(
      height: 25,
      width: 25,
      padding: const EdgeInsetsDirectional.all(2),
      decoration: BoxDecoration(
        color: !isUserSelected
            ? Theme.of(context).primaryColor
            : ColorManager.blue,
        border: Border.all(
            color: !isUserSelected
                ? ColorManager.darkGray
                : ColorManager.transparent,
            width: 2),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: isUserSelected
          ? const Center(
              child: Icon(Icons.check_rounded,
                  color: ColorManager.white, size: 17))
          : null,
    );
  }
}

class GroupMessages extends StatefulWidget {
  final List<UserPersonalInfo> selectedUsersInfoValue;
  const GroupMessages({Key? key, required this.selectedUsersInfoValue})
      : super(key: key);

  @override
  State<GroupMessages> createState() => _GroupMessagesState();
}

class _GroupMessagesState extends State<GroupMessages> {
  late SenderInfo messageDetails;
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GroupMessages oldWidget) {
    init();
    super.didUpdateWidget(oldWidget);
  }

  init() {
    List ids = [];
    for (final userInfo in widget.selectedUsersInfoValue) {
      ids.add(userInfo.userId);
    }
    messageDetails = SenderInfo(
      receiversInfo: widget.selectedUsersInfoValue,
      isThatGroupChat: true,
      receiversIds: ids,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar.chattingAppBar(widget.selectedUsersInfoValue, context),
      body: BlocProvider<MessageBloc>(
        create: (context) => injector<MessageBloc>(),
        child: ChatMessages(messageDetails: messageDetails),
      ),
    );
  }
}

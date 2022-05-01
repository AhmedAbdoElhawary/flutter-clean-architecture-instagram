import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:instegram/presentation/pages/which_profile_page.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';

class SearchAboutUserPage extends StatefulWidget {
  SearchAboutUserPage({Key? key}) : super(key: key);

  @override
  State<SearchAboutUserPage> createState() => _SearchAboutUserPageState();
}

class _SearchAboutUserPageState extends State<SearchAboutUserPage> {
  final TextEditingController _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Container(
          width: double.infinity,
          height: 35,
          decoration: BoxDecoration(
              color: ColorManager.veryLowOpacityGrey,
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            controller: _textController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
                hintText: 'Search', border: InputBorder.none),
          ),
        ),
      ),
      body: BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
        bloc: BlocProvider.of<SearchAboutUserBloc>(context)
          ..add(FindSpecificUser(_textController.text)),
        buildWhen: (previous, current) {
          if (previous != current && (current is SearchAboutUserBlocLoaded)) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is SearchAboutUserBlocLoaded) {
            List<UserPersonalInfo> stateUsersInfo = state.users;

            return ListView.separated(
                itemBuilder: (context, index) {
                  String hash = "${stateUsersInfo[index].userId.hashCode}";

                  return ListTile(
                    title: Text(stateUsersInfo[index].userName,
                        style: getNormalStyle(fontSize: 15)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stateUsersInfo[index].name,
                            style: getNormalStyle(
                                fontSize: 13, color: ColorManager.grey)),
                        if (stateUsersInfo[index]
                            .followerPeople
                            .contains(myPersonalId)) ...[
                          Text("You follow him",
                              style: getNormalStyle(
                                  fontSize: 10, color: ColorManager.grey)),
                        ] else if (stateUsersInfo[index]
                            .followedPeople
                            .contains(myPersonalId)) ...[
                          Text("Follower",
                              style: getNormalStyle(
                                  fontSize: 10, color: ColorManager.grey)),
                        ],
                      ],
                    ),
                    leading: Hero(
                      tag: hash,
                      child: CircleAvatarOfProfileImage(
                        bodyHeight: bodyHeight * 0.85,
                        hashTag: hash,
                        userInfo: stateUsersInfo[index],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => WhichProfilePage(
                              userId: stateUsersInfo[index].userId)));
                    },
                  );
                },
                itemCount:
                    //  _textController.text.isEmpty?0:
                    stateUsersInfo.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      height: 10,
                    ));
          } else {
            return buildCircularProgress();
          }
        },
      ),
    );
  }

  Center buildCircularProgress() => const Center(
          child: CircularProgressIndicator(
        color: ColorManager.black54,
        strokeWidth: 1.3,
      ));
}

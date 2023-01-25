import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:instagram/presentation/pages/profile/widgets/which_profile_page.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

class SearchAboutUserPage extends StatefulWidget {
  const SearchAboutUserPage({Key? key}) : super(key: key);

  @override
  State<SearchAboutUserPage> createState() => _SearchAboutUserPageState();
}

class _SearchAboutUserPageState extends State<SearchAboutUserPage> {
  final ValueNotifier<TextEditingController> _textController =
      ValueNotifier(TextEditingController());

  @override
  void dispose() {
    _textController.value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: isThatMobile ? buildAppBar(context) : null,
      body: BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
        bloc: BlocProvider.of<SearchAboutUserBloc>(context)
          ..add(FindSpecificUser(_textController.value.text)),
        buildWhen: (previous, current) =>
            previous != current && (current is SearchAboutUserBlocLoaded),
        builder: (context, state) {
          if (state is SearchAboutUserBlocLoaded) {
            List<UserPersonalInfo> stateUsersInfo = state.users;

            return ListView.separated(
                itemBuilder: (context, index) {
                  String hash = "${stateUsersInfo[index].userId.hashCode}";

                  return ListTile(
                    title: Text(stateUsersInfo[index].userName,
                        style: getNormalStyle(
                            fontSize: 15, color: Theme.of(context).focusColor)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stateUsersInfo[index].name,
                            style: getNormalStyle(
                                fontSize: 13,
                                color: Theme.of(context).disabledColor)),
                        if (stateUsersInfo[index]
                            .followerPeople
                            .contains(myPersonalId)) ...[
                          Text(StringsManager.youFollowHim.tr,
                              style: getNormalStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).disabledColor)),
                        ] else if (stateUsersInfo[index]
                            .followedPeople
                            .contains(myPersonalId)) ...[
                          Text(StringsManager.followers.tr,
                              style: getNormalStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).disabledColor)),
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
                      Go(context).push(
                          page: WhichProfilePage(
                              userId: stateUsersInfo[index].userId),
                          withoutRoot: false);
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyLarge,
          controller: _textController.value,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
              contentPadding: const EdgeInsetsDirectional.all(12.5),
              hintText: StringsManager.search.tr,
              hintStyle: Theme.of(context).textTheme.displayLarge,
              border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Widget buildCircularProgress() => const ThineCircularProgress();
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/pages/profile/users_who_likes.dart';

class UsersWhoLikesForMobile extends StatelessWidget {
  final List<dynamic> usersIds;
  final bool showSearchBar;
  final bool isThatMyPersonalId;

  const UsersWhoLikesForMobile({
    Key? key,
    required this.showSearchBar,
    required this.usersIds,
    required this.isThatMyPersonalId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: isThatMobile ? buildAppBar(context) : null,
        body: UsersWhoLikes(
          usersIds: usersIds,
          showSearchBar: showSearchBar,
          isThatMyPersonalId: isThatMyPersonalId,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(StringsManager.likes.tr,
          style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/pages/profile/users_who_likes.dart';

class UsersWhoLikesForMobile extends StatefulWidget {
  final List<dynamic> usersIds;
  final bool showSearchBar;

  const UsersWhoLikesForMobile(
      {Key? key, required this.showSearchBar, required this.usersIds})
      : super(key: key);

  @override
  State<UsersWhoLikesForMobile> createState() => _UsersWhoLikesForMobileState();
}

class _UsersWhoLikesForMobileState extends State<UsersWhoLikesForMobile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: isThatMobile ? buildAppBar(context) : null,
        body: UsersWhoLikes(
          usersIds: widget.usersIds,
          showSearchBar: widget.showSearchBar,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(StringsManager.likes.tr(),
          style: Theme.of(context).textTheme.bodyText1),
    );
  }
}

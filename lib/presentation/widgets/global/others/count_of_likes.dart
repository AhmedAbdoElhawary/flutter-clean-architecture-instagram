import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/pages/profile/users_who_likes_for_mobile.dart';
import 'package:instagram/presentation/pages/profile/users_who_likes_for_web.dart';
class CountOfLikes extends StatelessWidget {
  final Post postInfo;
  const CountOfLikes({Key? key, required this.postInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int likes = postInfo.likes.length;

    return InkWell(
      onTap: () {
        if (isThatMobile) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => UsersWhoLikesForMobile(
                showSearchBar: true,
                usersIds: postInfo.likes,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) =>
                  UsersWhoLikesForWeb(usersIds: postInfo.likes),
            ),
          );
        }
      },
      child: Text(
          '$likes ${likes > 1 ? StringsManager.likes.tr() : StringsManager.like.tr()}',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline2),
    );
  }
}

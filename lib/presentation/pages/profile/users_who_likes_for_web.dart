import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/presentation/pages/profile/users_who_likes.dart';

class UsersWhoLikesForWeb extends StatelessWidget {
  final List<dynamic> usersIds;

  const UsersWhoLikesForWeb({Key? key, required this.usersIds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool minimumOfWidth = MediaQuery.of(context).size.width > 600;
    return Center(
      child: SizedBox(
        width: minimumOfWidth ? 420 : 330,
        height: 450,
        child: Material(
          color: ColorManager.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                _TheHeadWidgets(text: StringsManager.likes.tr()),
                customDivider(),
                Expanded(
                  child: UsersWhoLikes(
                    showSearchBar: false,
                    usersIds: usersIds,
                    showColorfulCircle: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customDivider() =>
      Container(color: ColorManager.grey, height: 1, width: double.infinity);
}

class _TheHeadWidgets extends StatelessWidget {
  final String text;
  const _TheHeadWidgets({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                text,
                style: getBoldStyle(color: ColorManager.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(
              Icons.close_rounded,
              color: ColorManager.black,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/pages/profile/users_who_likes.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/common/head_of_popup_widget.dart';

class UsersWhoLikesForWeb extends StatelessWidget {
  final List<dynamic> usersIds;
  final bool isThatMyPersonalId;

  const UsersWhoLikesForWeb({
    Key? key,
    required this.usersIds,
    required this.isThatMyPersonalId,
  }) : super(key: key);

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
                TheHeadWidgets(text: StringsManager.likes.tr),
                customDivider(),
                Expanded(
                  child: UsersWhoLikes(
                    showSearchBar: false,
                    usersIds: usersIds,
                    showColorfulCircle: false,
                    isThatMyPersonalId: isThatMyPersonalId,
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
      Container(color: ColorManager.grey, height: 0.5, width: double.infinity);
}

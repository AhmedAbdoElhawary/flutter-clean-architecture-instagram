import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/common/get_users_info.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/common/head_of_popup_widget.dart';

class PopupFollowCard extends StatelessWidget {
  final bool isThatFollower;
  final List<dynamic> usersIds;
  final bool isThatMyPersonalId;

  const PopupFollowCard({
    Key? key,
    required this.isThatMyPersonalId,
    this.isThatFollower = true,
    required this.usersIds,
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
                TheHeadWidgets(
                    text: isThatFollower
                        ? StringsManager.followers.tr
                        : StringsManager.following.tr),
                customDivider(),
                Expanded(
                  child: GetUsersInfo(
                      usersIds: usersIds,
                      isThatFollowers: isThatFollower,
                      isThatMyPersonalId: isThatMyPersonalId),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customDivider() =>
      const Divider(color: ColorManager.grey, thickness: 0.2);
}

import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/data/models/user_personal_info.dart';

import 'circle_avatar_name.dart';

class CircleAvatarOfProfileImage extends StatelessWidget {
  final double bodyHeight;
  final bool thisForStoriesLine;
  final UserPersonalInfo userInfo;
  const CircleAvatarOfProfileImage({
    required this.userInfo,
    required this.bodyHeight,
    this.thisForStoriesLine = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String profileImage=userInfo.profileImageUrl;
    return SizedBox(
      height: bodyHeight * 0.14,
      width: bodyHeight * 0.145 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (userInfo.stories.isNotEmpty) ...[
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        ColorManager.blackRed,
                        ColorManager.redAccent,
                        ColorManager.yellow,
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: bodyHeight * .0505,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                CircleAvatar(
                  radius: bodyHeight * .0485,
                  backgroundColor: ColorManager.white,
                ),
              ],
              CircleAvatar(
                backgroundColor: ColorManager.lowOpacityGrey,
                backgroundImage:
                profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
                child: profileImage.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: ColorManager.white,
                        size: 80,
                      )
                    : null,
                radius: bodyHeight * .046,
              ),
            ],
          ),
          if (thisForStoriesLine) ...[
            SizedBox(height: bodyHeight * 0.004),
            NameOfCircleAvatar(userInfo.name, thisForStoriesLine),
          ]
        ],
      ),
    );
  }
}

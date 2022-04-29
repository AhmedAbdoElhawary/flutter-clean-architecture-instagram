import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';

import 'circle_avatar_name.dart';

class CircleAvatarOfProfileImage extends StatelessWidget {
  final String circleAvatarName;
  final double bodyHeight;
  final bool thisForStoriesLine;
  final String imageUrl;
  final bool bigCircleColor;
  const CircleAvatarOfProfileImage({
    required this.imageUrl,
    required this.bodyHeight,
    this.circleAvatarName = '',
    this.thisForStoriesLine = false,
    this.bigCircleColor = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bodyHeight * 0.14,
      width: bodyHeight * 0.145 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (bigCircleColor) ...[
                CircleAvatar(
                  radius: bodyHeight * .054,
                  backgroundColor: ColorManager.redAccent,
                ),
                CircleAvatar(
                  radius: bodyHeight * .051,
                  backgroundColor: ColorManager.white,
                ),
              ],
              CircleAvatar(
                child: ClipOval(
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person, color: ColorManager.white)
                      : CustomFadeInImage(imageUrl: imageUrl),
                ),
                radius: bodyHeight * .046,
                backgroundColor: ColorManager.black,
              ),
            ],
          ),
          if (thisForStoriesLine) ...[
            const SizedBox(height: 5),
            NameOfCircleAvatar(circleAvatarName, thisForStoriesLine),
          ]
        ],
      ),
    );
  }
}

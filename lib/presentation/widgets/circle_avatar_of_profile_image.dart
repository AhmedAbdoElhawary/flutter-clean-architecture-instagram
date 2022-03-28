import 'package:flutter/material.dart';

import 'circle_avatar_name.dart';

class CircleAvatarOfProfileImage extends StatelessWidget {
  final String circleAvatarName;
  final double bodyHeight;
  final bool thisForStoriesLine;
  final String imageUrl;
  const CircleAvatarOfProfileImage({
    required this.imageUrl,
    required this.circleAvatarName,
    required this.bodyHeight,
    required this.thisForStoriesLine,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onLongPress: () {},
      child: SizedBox(
        height: bodyHeight * 0.14,
        width: bodyHeight * 0.145 - 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: bodyHeight * .054,
              backgroundColor: Colors.redAccent,
              child: CircleAvatar(
                radius: bodyHeight * .051,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  child: ClipOval(
                    child: imageUrl.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : Image.network(imageUrl),
                  ),
                  radius: bodyHeight * .046,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            if (thisForStoriesLine) const SizedBox(height: 5),
            if (thisForStoriesLine)
              NameOfCircleAvatar(circleAvatarName, thisForStoriesLine),
          ],
        ),
      ),
    );
  }
}

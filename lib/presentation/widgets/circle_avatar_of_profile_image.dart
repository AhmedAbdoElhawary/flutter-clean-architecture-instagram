import 'package:flutter/material.dart';

import 'circle_avatar_name.dart';

class CircleAvatarOfProfileImage extends StatelessWidget {
  String circleAvatarName;
  double bodyHeight;
  bool thisForStoriesLine;
  CircleAvatarOfProfileImage(
    this.circleAvatarName,
    this.bodyHeight,
    this.thisForStoriesLine, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: SizedBox(
          height: bodyHeight * 0.14,
          width: bodyHeight * 0.145 - 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: bodyHeight * .046,
                backgroundColor: Colors.redAccent,
                child: CircleAvatar(
                  radius: bodyHeight * .044,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                          "assets/3d_caractars/caractars/doctor.png"),
                    ),
                    radius: bodyHeight * .042,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
              if (thisForStoriesLine)
                NameOfCircleAvatar(circleAvatarName, thisForStoriesLine),
            ],
          ),
        ),
      ),
    );
  }
}

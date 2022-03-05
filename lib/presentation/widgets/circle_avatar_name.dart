import 'package:flutter/material.dart';

class NameOfCircleAvatar extends StatelessWidget {
  String circleAvatarName;
  bool isForStoriesLine;

  NameOfCircleAvatar(
    this.circleAvatarName,
    this.isForStoriesLine, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      circleAvatarName,
      maxLines: 1,
      style: TextStyle(
          fontWeight: isForStoriesLine ? FontWeight.normal : FontWeight.bold),
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }
}

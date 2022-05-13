import 'package:flutter/material.dart';
import 'package:instagram/core/resources/styles_manager.dart';

class NameOfCircleAvatar extends StatelessWidget {
  final String circleAvatarName;
  final bool isForStoriesLine;

  const NameOfCircleAvatar(
    this.circleAvatarName,
    this.isForStoriesLine, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: isForStoriesLine ? 0 : 5),
      child: Text(
        circleAvatarName,
        maxLines: 1,
        style: isForStoriesLine
            ? getNormalStyle(fontSize: 12, color: Theme.of(context).focusColor)
            : getMediumStyle(color: Theme.of(context).focusColor),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}

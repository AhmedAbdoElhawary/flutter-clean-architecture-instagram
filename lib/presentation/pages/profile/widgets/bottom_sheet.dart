import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget headIcon;
  final Widget bodyText;
  const CustomBottomSheet({
    Key? key,
    required this.headIcon,
    required this.bodyText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: _ListOfBodyWidgets(bodyText: bodyText, headIcon: headIcon),
    );
  }
}

class _ListOfBodyWidgets extends StatelessWidget {
  final Widget headIcon;
  final Widget bodyText;
  const _ListOfBodyWidgets({
    Key? key,
    required this.headIcon,
    required this.bodyText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            IconsAssets.minusIcon,
            colorFilter: ColorFilter.mode(
                Theme.of(context).highlightColor, BlendMode.srcIn),
            height: 40,
          ),
          headIcon,
          const Divider(color: ColorManager.grey),
          bodyText,
        ],
      ),
    );
  }
}

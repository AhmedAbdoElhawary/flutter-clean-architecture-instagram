import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';

class CustomBottomSheet {
  static Future<void> bottomSheet(BuildContext context,
      {required Widget headIcon, required Widget bodyText}) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).splashColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: listOfBodyWidgets(context,
              bodyText: bodyText, headIcon: headIcon),
        );
      },
    );
  }

  static Widget listOfBodyWidgets(BuildContext context,
      {required Widget headIcon, required Widget bodyText}) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            IconsAssets.minusIcon,
            color: Theme.of(context).errorColor,
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

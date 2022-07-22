import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';

class TheHeadWidgets extends StatelessWidget {
  final String text;
  final bool makeIconsBigger;
  const TheHeadWidgets(
      {Key? key, required this.text, this.makeIconsBigger = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                text,
                style: makeIconsBigger
                    ? getNormalStyle(color: ColorManager.black, fontSize: 20)
                    : getBoldStyle(color: ColorManager.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            child: Icon(
              Icons.close_rounded,
              color: ColorManager.black,
              size: makeIconsBigger ? 35 : null,
            ),
          )
        ],
      ),
    );
  }
}

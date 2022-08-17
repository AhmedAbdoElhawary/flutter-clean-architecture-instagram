import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';

class PopupMenuCard extends StatelessWidget {
  const PopupMenuCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool minimumOfWidth = MediaQuery.of(context).size.width > 600;
    return Center(
      child: SizedBox(
        width: minimumOfWidth ? 420 : 250,
        child: Material(
          color: ColorManager.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildRedContainer("Report", makeColorRed: true),
                customDivider(),
                buildRedContainer("Unfollow", makeColorRed: true),
                customDivider(),
                buildRedContainer("Go to post"),
                customDivider(),
                buildRedContainer("Share to..."),
                customDivider(),
                buildRedContainer("Copy link"),
                customDivider(),
                buildRedContainer("Embed"),
                customDivider(),
                GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: buildRedContainer("Cancel")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Divider customDivider() =>
      const Divider(color: ColorManager.grey, thickness: 0.5);

  Container buildRedContainer(String text, {bool makeColorRed = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: makeColorRed
            ? getBoldStyle(color: ColorManager.red)
            : getNormalStyle(color: ColorManager.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}

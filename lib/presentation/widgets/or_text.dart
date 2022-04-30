import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';

class OrText extends StatelessWidget{
  const OrText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        const Expanded(
            child: Divider(
              indent: 20,
              endIndent: 5,
              thickness: 1,
            )),
        Text(
          StringsManager.or.tr(),
          style:const TextStyle(color: ColorManager.black54, fontWeight: FontWeight.bold),
        ),
        const  Expanded(
            child: Divider(
              indent: 5,
              endIndent: 20,
              thickness: 1,
            )),
      ],
    );
  }

}
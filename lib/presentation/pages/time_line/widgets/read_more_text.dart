import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:readmore/readmore.dart';

class ReadMore extends StatelessWidget {
  final String text;
  final int timeLines;
  const ReadMore(this.text, this.timeLines, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimLines: timeLines,
      colorClickableText: ColorManager.grey,
      trimMode: TrimMode.Line,
      trimCollapsedText: StringsManager.more.tr,
      trimExpandedText: StringsManager.less.tr,
      style: TextStyle(color: Theme.of(context).focusColor),
      moreStyle: const TextStyle(fontSize: 14, color: ColorManager.grey),
    );
  }
}

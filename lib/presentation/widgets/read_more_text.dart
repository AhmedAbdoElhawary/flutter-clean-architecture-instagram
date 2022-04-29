
import 'package:flutter/material.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:readmore/readmore.dart';

class ReadMore extends StatelessWidget{
  final String text;
  final int timeLines;
  const ReadMore(this.text,this.timeLines,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      return ReadMoreText(
        text,
        trimLines: timeLines,
        colorClickableText: Colors.grey,
        trimMode: TrimMode.Line,
        trimCollapsedText: StringsManager.more,
        trimExpandedText: StringsManager.less,
        style: const TextStyle(color: Colors.black),
        moreStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      );
  }

}
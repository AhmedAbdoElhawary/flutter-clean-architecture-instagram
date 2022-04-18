import 'package:flutter/material.dart';
import 'package:instegram/presentation/widgets/custom_app_bar.dart';
import 'package:instegram/presentation/widgets/post_list_view.dart';

class CustomPostsDisplay extends StatelessWidget{
  final List postsInfo;

  const CustomPostsDisplay(this.postsInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:SingleChildScrollView(
      child: ImageList(
        postsInfo: postsInfo,
      ),
    ) ,
        appBar: customAppBar());
  }

}
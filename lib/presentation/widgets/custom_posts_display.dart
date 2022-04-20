import 'package:flutter/material.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/widgets/custom_app_bar.dart';
import 'package:instegram/presentation/widgets/post_list_view.dart';

class CustomPostsDisplay extends StatelessWidget{
  final Post postInfo;

  const CustomPostsDisplay(this.postInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:SingleChildScrollView(
      child: ImageList(
        postInfo: postInfo,
          isVideoInView: (){return false;}
      ),
    ) ,
        appBar: customAppBar());
  }

}
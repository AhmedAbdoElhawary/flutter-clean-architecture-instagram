import 'package:flutter/material.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/widgets/custom_app_bar.dart';
import 'package:instegram/presentation/widgets/post_list_view.dart';

class CustomPostsDisplay extends StatelessWidget {
  final Post postClickedInfo;
  final List<Post> postsInfo;
  final int index;

  const CustomPostsDisplay(
      {required this.postsInfo,
      required this.postClickedInfo,
      required this.index,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
          itemCount: postsInfo.length,
          itemBuilder: (context, indexOfList) {
            return ImageList(
              postInfo: postsInfo[indexOfList],
              // isVideoInView: (){return false;}
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
        appBar: customAppBar());
  }
}

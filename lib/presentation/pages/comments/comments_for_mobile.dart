import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/presentation/pages/comments/widgets/comment_of_post.dart';

class CommentsPageForMobile extends StatefulWidget {
  final ValueNotifier<Post> postInfo;

  const CommentsPageForMobile({Key? key, required this.postInfo})
      : super(key: key);

  @override
  State<CommentsPageForMobile> createState() => _CommentsPageForMobileState();
}

class _CommentsPageForMobileState extends State<CommentsPageForMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isThatMobile ? appBar(context) : null,
      body: CommentsOfPost(
        postInfo: widget.postInfo,
        selectedCommentInfo: ValueNotifier(null),
        textController: ValueNotifier(TextEditingController()),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        StringsManager.comments.tr,
        style: getNormalStyle(color: Theme.of(context).focusColor),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/widgets/belong_to/comments_w/build_comments.dart';

class CommentsPage extends StatefulWidget {
  final Post postInfo;

  const CommentsPage({Key? key, required this.postInfo}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: appBar(context),
        body: BuildComments(postInfo: widget.postInfo),
      );
    });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        StringsManager.comments.tr(),
        style: getNormalStyle(color: Theme.of(context).focusColor),
      ),
    );
  }

}

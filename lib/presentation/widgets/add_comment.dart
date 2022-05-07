import 'package:flutter/material.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/widgets/comment_box.dart';

class AddComment extends StatefulWidget {
  const AddComment({
    Key? key,
    // required this.showCommentBox,
    required this.postsInfo,
    required this.textController,


  }) : super(key: key);

  final Post postsInfo;
  // final ValueNotifier<FocusNode> showCommentBox;
  final TextEditingController textController;
  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<AddComment>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          visibility = false;
        });
      } else {
        setState(() {
          visibility = true;
        });
      }
    });
    // widget.showCommentBox.addListener(_showHideCommentBox);
  }
  //
  // void _showHideCommentBox() {
  //   if (widget.showCommentBox.value.hasFocus) {
  //     _controller.forward();
  //   } else {
  //     _controller.reverse();
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: visibility,
      child: FadeTransition(
        opacity: _animation,
        child: Builder(builder: (context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child:  CommentBox(
              postId: widget.postsInfo.postUid,
              textController:  widget.textController,
            userPersonalInfo:  widget.postsInfo.publisherInfo!,
              makeSelectedCommentNullable: () {
                setState(() {
                  widget.textController.text = '';
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
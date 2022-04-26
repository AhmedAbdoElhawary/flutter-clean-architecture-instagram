import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/globall.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/comments_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/repliesInfo/reply_info_cubit.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';

class AddComment extends StatefulWidget {
  final TextEditingController textController;
  final Comment? selectedCommentInfo;
  final VoidCallback makeSelectedCommentNullable;
  final UserPersonalInfo userPersonalInfo;
  final String postId;
  const AddComment(
      {Key? key,
      required this.textController,
      required this.userPersonalInfo,
      required this.makeSelectedCommentNullable,
      required this.postId,
      required this.selectedCommentInfo})
      : super(key: key);

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Row(
          crossAxisAlignment: widget.textController.text.length < 70
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {},
              child: CircleAvatarOfProfileImage(
                imageUrl: widget.userPersonalInfo.profileImageUrl,
                bodyHeight: 330,
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                cursorColor: ColorManager.teal,
                maxLines: null,
                decoration: const InputDecoration.collapsed(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(color: ColorManager.black26)),
                autofocus: false,
                controller: widget.textController,
                onChanged: (e) => setState(() {}),
              ),
            ),
            if (widget.textController.text.isEmpty) ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.textController.text = '❤';
                  });
                },
                child: const Text('❤'),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.textController.text = '🙌';
                  });
                },
                child: const Text('🙌'),
              ),
            ] else ...[
              BlocBuilder<CommentsInfoCubit, CommentsInfoState>(
                  builder: (context1, state) {
                //TODO here we want to make comment loading when he loading
                return InkWell(
                  onTap: () {
                    if (widget.textController.text.isNotEmpty) {
                      postTheComment(widget.userPersonalInfo);
                    }
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(
                        color: widget.textController.text.isNotEmpty
                            ? ColorManager.blue
                            : ColorManager.lightBlue),
                  ),
                );
              })
            ],
          ],
        ),
      ],
    );
  }

  Future<void> postTheComment(UserPersonalInfo myPersonalInfo) async {
    if (widget.selectedCommentInfo == null) {
      CommentsInfoCubit commentsInfoCubit =
          BlocProvider.of<CommentsInfoCubit>(context);
      await commentsInfoCubit.addComment(
          commentInfo: newCommentInfo(myPersonalInfo, DateOfNow.dateOfNow()));
    } else {
      Comment replyInfo = newReplyInfo(DateOfNow.dateOfNow(),
          widget.selectedCommentInfo!, myPersonalInfo.userId);

      await ReplyInfoCubit.get(context)
          .replyOnThisComment(replyInfo: replyInfo);
    }
    widget.makeSelectedCommentNullable();

    // setState(() {
    //   widget.selectedCommentInfo = null;
    //   widget.textController.text = '';
    // });
  }
  Widget textOfEmoji(String emoji) {
    return GestureDetector(
      onTap: () {
        // focusNode.requestFocus();
        setState(() {
          widget.textController.text = widget.textController.text + emoji;
          widget.textController.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.textController.text.length));
        });
      },
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
  Comment newCommentInfo(
      UserPersonalInfo myPersonalInfo, String formattedDate) {
    final _whitespaceRE = RegExp(r"\s+");
    String textWithOneSpaces =
        widget.textController.text.replaceAll(_whitespaceRE, " ");
    return Comment(
        theComment: textWithOneSpaces,
        whoCommentId: myPersonalInfo.userId,
        datePublished: formattedDate,
        postId: widget.postId,
        likes: [],
        replies: []);
  }

  Comment newReplyInfo(
      String formattedDate, Comment commentInfo, String myPersonalId) {
    final _whitespaceRE = RegExp(r"\s+");
    String textWithOneSpaces =
        widget.textController.text.replaceAll(_whitespaceRE, " ");
    return Comment(
        datePublished: formattedDate,
        parentCommentId: commentInfo.parentCommentId,
        postId: commentInfo.postId,
        theComment: textWithOneSpaces,
        whoCommentId: myPersonalId,
        likes: []);
  }
}

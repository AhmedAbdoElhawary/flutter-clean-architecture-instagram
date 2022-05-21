import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/comment.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';

class CommentBox extends StatefulWidget {
  final TextEditingController textController;
  final Comment? selectedCommentInfo;
  final FocusNode? focusNode;
  final VoidCallback makeSelectedCommentNullable;
  final UserPersonalInfo userPersonalInfo;
  final String postId;
  const CommentBox(
      {Key? key,
      required this.textController,
      this.focusNode,
      required this.userPersonalInfo,
      required this.makeSelectedCommentNullable,
      required this.postId,
      this.selectedCommentInfo})
      : super(key: key);

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            textOfEmoji('❤'),
            textOfEmoji('🙌'),
            textOfEmoji('🔥'),
            textOfEmoji('👏🏻'),
            textOfEmoji('😢'),
            textOfEmoji('😍'),
            textOfEmoji('😮'),
            textOfEmoji('😂'),
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
          child: Row(
            crossAxisAlignment: widget.textController.text.length < 70
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end,
            children: [
              CircleAvatarOfProfileImage(
                userInfo: widget.userPersonalInfo,
                bodyHeight: 330,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  cursorColor: ColorManager.teal,
                  focusNode:
                      widget.focusNode == null ? null : FocusNode()
                        ?..requestFocus(),
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: null,
                  decoration: InputDecoration.collapsed(
                      hintText: StringsManager.addComment.tr(),
                      hintStyle: TextStyle(color: Theme.of(context).cardColor)),
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
                const SizedBox(
                  width: 8,
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
                  return InkWell(
                    onTap: () {
                      if (widget.textController.text.isNotEmpty) {
                        postTheComment(widget.userPersonalInfo);
                      }
                    },
                    child: Text(
                      StringsManager.post.tr(),
                      style: getNormalStyle(
                          color: widget.textController.text.isNotEmpty
                              ? ColorManager.blue
                              : ColorManager.lightBlue),
                    ),
                  );
                })
              ],
            ],
          ),
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
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: Colors.grey,
      width: double.infinity,
      height: 0.2);

  Widget textOfEmoji(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.textController.text = widget.textController.text + emoji;
          widget.textController.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.textController.text.length));
        });
      },
      child: Text(
        emoji,
        style:
            getNormalStyle(fontSize: 24, color: Theme.of(context).focusColor),
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

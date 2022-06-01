import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/comment.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comment_likes/comment_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/replyLikes/reply_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:instagram/presentation/pages/profile/show_me_who_are_like.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/core/functions/toast_show.dart';

// ignore: must_be_immutable
class CommentInfo extends StatefulWidget {
  final Comment commentInfo;
  TextEditingController textController;
  ValueChanged<Comment>? selectedCommentInfo;
  UserPersonalInfo myPersonalInfo;
  int index;
  bool isThatReply;
  final ValueNotifier<bool> rebuildComments;
  bool addReply;
  Map<int, bool> showMeReplies;

  CommentInfo(
      {Key? key,
      required this.commentInfo,
      this.selectedCommentInfo,
      required this.index,
      this.isThatReply = false,
      required this.myPersonalInfo,
      required this.showMeReplies,
      required this.rebuildComments,
      required this.addReply,
      required this.textController})
      : super(key: key);

  @override
  State<CommentInfo> createState() => _CommentInfoState();
}

class _CommentInfoState extends State<CommentInfo> {
  @override
  Widget build(BuildContext context) {
    bool isLiked = widget.commentInfo.likes.contains(myPersonalId);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10.0),
      child: Column(
        children: [
          rowOfCommentator(context, isLiked, widget.commentInfo.theComment),
          if (!widget.isThatReply && widget.commentInfo.replies!.isNotEmpty)
            widget.showMeReplies[widget.index] == false
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(start: 50.0),
                    child: Row(
                      children: [
                        Container(
                            color: Theme.of(context).dividerColor,
                            height: 1,
                            width: 40),
                        const SizedBox(width: 10),
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.showMeReplies
                                        .update(widget.index, (value) => true);
                                  });
                                },
                                child: Text(
                                    "${StringsManager.view.tr()} ${widget.commentInfo.replies!.length} ${StringsManager.more.tr()} ${widget.commentInfo.replies!.length > 1 ? StringsManager.replies.tr() : StringsManager.reply.tr()}",
                                    style: getNormalStyle(
                                        color:
                                            Theme.of(context).indicatorColor))))
                      ],
                    ),
                  )
                : ValueListenableBuilder(
                    builder: (context, bool value, child) {
                      return BlocBuilder<ReplyInfoCubit, ReplyInfoState>(
                          bloc: BlocProvider.of<ReplyInfoCubit>(context)
                            ..getRepliesOfThisComment(
                                commentId: widget.commentInfo.commentUid),
                          buildWhen: (previous, current) {
                            if (previous != current &&
                                (current is CubitReplyInfoLoaded)) {
                              return true;
                            }
                            if (value) {
                              widget.rebuildComments.value = false;
                              return true;
                            }
                            return false;
                          },
                          builder: (context, state) {
                            if (state is CubitReplyInfoLoaded) {
                              List<Comment> repliesInfo =
                                  BlocProvider.of<ReplyInfoCubit>(context)
                                      .repliesOnComment;
                              return Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 40.0),
                                child: ListView.separated(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder: (context, index) {
                                      return CommentInfo(
                                        showMeReplies: widget.showMeReplies,
                                        commentInfo: repliesInfo[index],
                                        textController: widget.textController,
                                        rebuildComments: widget.rebuildComments,
                                        index: index,
                                        selectedCommentInfo:
                                            widget.selectedCommentInfo,
                                        myPersonalInfo: widget.myPersonalInfo,
                                        addReply: widget.addReply,
                                        isThatReply: true,
                                      );
                                    },
                                    itemCount: repliesInfo.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(
                                              height: 20,
                                            )),
                              );
                            } else if (state is CubitReplyInfoFailed) {
                              ToastShow.toastStateError(state);
                              return Text(state.toString(),
                                  style: Theme.of(context).textTheme.bodyText1);
                            } else {
                              return Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 50.0),
                                child: Row(
                                  children: [
                                    Container(
                                        color: Theme.of(context).dividerColor,
                                        height: 1,
                                        width: 40),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text(StringsManager.loading.tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1))
                                  ],
                                ),
                              );
                            }
                          });
                    },
                    valueListenable: widget.rebuildComments,
                  ),
        ],
      ),
    );
  }

  Row rowOfCommentator(
      BuildContext context, bool isLiked, String hashTageOfUserName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(CupertinoPageRoute(
              builder: (context) => WhichProfilePage(
                  userId: widget.commentInfo.whoCommentInfo!.userId),
            ));
          },
          child: CircleAvatarOfProfileImage(
            userInfo: widget.commentInfo.whoCommentInfo!,
            bodyHeight: widget.isThatReply ? 280 : 400,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 3.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(CupertinoPageRoute(
                        builder: (context) => WhichProfilePage(
                            userId: widget.commentInfo.whoCommentInfo!.userId),
                      ));
                    },
                    child: Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.commentInfo.whoCommentInfo!.userName,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const TextSpan(
                            text: '  ',
                          ),
                          if (widget.isThatReply)
                            TextSpan(
                              text: hashTageOfUserName.split(" ")[0],
                              style:
                                  getNormalStyle(color: ColorManager.lightBlue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  List<String> hashTagName =
                                      hashTageOfUserName.split(" ");
                                  String userName =
                                      hashTagName[0].replaceAll('@', '');
                                  await Navigator.of(
                                    context,
                                  ).push(CupertinoPageRoute(
                                      builder: (context) => WhichProfilePage(
                                            userName: userName,
                                          ),
                                      maintainState: false));
                                },
                            ),
                          TextSpan(
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
                            text:
                                " ${widget.isThatReply ? hashTageOfUserName.split(" ")[1] : hashTageOfUserName}",
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                          DateOfNow.commentsDateOfNow(
                              widget.commentInfo.datePublished),
                          style: Theme.of(context).textTheme.headline1),
                      if (widget.commentInfo.likes.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => UsersWhoLikesOnPostPage(
                                        showSearchBar: false,
                                        usersIds: widget.commentInfo.likes,
                                      )));
                            },
                            child: Text(
                              "${widget.commentInfo.likes.length} ${widget.commentInfo.likes.length == 1 ? StringsManager.like.tr() : StringsManager.likes.tr()}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () async {
                          String hashTag =
                              "@${widget.commentInfo.whoCommentInfo!.userName} ";

                          widget.textController.text = hashTag;

                          widget.textController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: widget.textController.text.length));
                          Comment commentInfo = widget.commentInfo;
                          if (widget.commentInfo.parentCommentId.isEmpty) {
                            commentInfo.parentCommentId =
                                commentInfo.commentUid;
                          }
                          setState(() {
                            widget.selectedCommentInfo!(commentInfo);
                          });
                        },
                        child: Text(
                          StringsManager.reply.tr(),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ]),
          ),
        ),
        IconButton(
          icon: !isLiked
              ? const Icon(
                  Icons.favorite_border,
                  size: 15,
                  color: Colors.grey,
                )
              : const Icon(
                  Icons.favorite,
                  size: 15,
                  color: Colors.red,
                ),
          onPressed: () {
            setState(() {
              if (widget.isThatReply) {
                if (isLiked) {
                  BlocProvider.of<ReplyLikesCubit>(context)
                      .removeLikeOnThisReply(
                          replyId: widget.commentInfo.commentUid,
                          myPersonalId: myPersonalId);
                  widget.commentInfo.likes.remove(myPersonalId);
                } else {
                  BlocProvider.of<ReplyLikesCubit>(context).putLikeOnThisReply(
                      replyId: widget.commentInfo.commentUid,
                      myPersonalId: myPersonalId);
                  widget.commentInfo.likes.add(myPersonalId);
                }
              } else {
                if (isLiked) {
                  BlocProvider.of<CommentLikesCubit>(context)
                      .removeLikeOnThisComment(
                          postId: widget.commentInfo.postId,
                          commentId: widget.commentInfo.commentUid,
                          myPersonalId: myPersonalId);
                  widget.commentInfo.likes.remove(myPersonalId);
                } else {
                  BlocProvider.of<CommentLikesCubit>(context)
                      .putLikeOnThisComment(
                          postId: widget.commentInfo.postId,
                          commentId: widget.commentInfo.commentUid,
                          myPersonalId: myPersonalId);
                  widget.commentInfo.likes.add(myPersonalId);
                }
              }
            });
          },
        )
      ],
    );
  }
}

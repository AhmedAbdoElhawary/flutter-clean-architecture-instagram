import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/globall.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/comment_likes/comment_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/repliesInfo/replyLikes/reply_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/repliesInfo/reply_info_cubit.dart';
import 'package:instegram/presentation/pages/show_me_who_are_like.dart';
import 'package:instegram/presentation/pages/which_profile_page.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
class CommentInfo extends StatefulWidget {
  final Comment commentInfo;
  TextEditingController textController;
  ValueChanged<Comment>? selectedCommentInfo;
  UserPersonalInfo myPersonalInfo;
  bool isThatReply;
  bool showMeReplies = false;
  bool addReply;

  CommentInfo(
      {Key? key,
      required this.commentInfo,
      this.selectedCommentInfo,
      this.isThatReply = false,
      required this.myPersonalInfo,
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
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        children: [
          rowOfCommentator(context, isLiked, splitTheComment()),
          if (!widget.isThatReply && widget.commentInfo.replies!.isNotEmpty)
            !widget.showMeReplies
                ? Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Row(
                      children: [
                        Container(color: Colors.black12, height: 1, width: 40),
                        const SizedBox(width: 10),
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.showMeReplies = true;
                                  });
                                },
                                child: Text(
                                    "View ${widget.commentInfo.replies!.length} more ${widget.commentInfo.replies!.length > 1 ? 'replies' : 'reply'}",
                                    style: const TextStyle(
                                        color: Colors.black45))))
                      ],
                    ),
                  )
                : BlocBuilder<ReplyInfoCubit, ReplyInfoState>(
                    bloc: BlocProvider.of<ReplyInfoCubit>(context)
                      ..getRepliesOfThisComment(
                          commentId: widget.commentInfo.commentUid),
                    buildWhen: (previous, current) {
                      if (previous != current &&
                          (current is CubitReplyInfoLoaded)) {
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
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Scrollbar(
                            child: ListView.separated(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return CommentInfo(
                                    commentInfo: repliesInfo[index],
                                    textController: widget.textController,
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
                          ),
                        );
                      } else if (state is CubitReplyInfoFailed) {
                        ToastShow.toastStateError(state);
                        return Text(state.toString());
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Row(
                            children: [
                              // const Divider(thickness: 30,color: Colors.black,indent: 10,endIndent: 60),
                              Container(
                                  color: Colors.black12, height: 1, width: 40),
                              const SizedBox(width: 10),
                              const Expanded(
                                  child: Text("Loading...",
                                      style: TextStyle(color: Colors.black45)))
                            ],
                          ),
                        );
                      }
                    }),
        ],
      ),
    );
  }

  String splitTheComment() {
    String theComment = widget.commentInfo.theComment;
    List<String> f = theComment.split(" ");
    if (theComment[0] == '@' && f[0].length > 1) {
      String hashTageOfUserName = f[0];
      f.removeAt(0);
      widget.commentInfo.theComment = f.join(" ");
      return hashTageOfUserName;
    }
    return '';
  }

  Row rowOfCommentator(
      BuildContext context, bool isLiked, String hashTageOfUserName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatarOfProfileImage(
            imageUrl: widget.commentInfo.whoCommentInfo!.profileImageUrl,
            bodyHeight: widget.isThatReply ? 280 : 400,),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.commentInfo.whoCommentInfo!.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: '  ',
                          ),
                          if (hashTageOfUserName.isNotEmpty)
                            TextSpan(
                              text: hashTageOfUserName,
                              style: const TextStyle(
                                  color: Color.fromARGB(232, 20, 44, 116)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  String userName =
                                      hashTageOfUserName.replaceAll('@', '');
                                  await Navigator.of(
                                    context,
                                  ).push(MaterialPageRoute(
                                      builder: (context) => WhichProfilePage(
                                            userName: userName,
                                          ),
                                      maintainState: false));
                                },
                            ),
                          TextSpan(
                            style: const TextStyle(color: Colors.black),
                            text: " ${widget.commentInfo.theComment}",
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(DateOfNow.differenceDateOfNow(widget.commentInfo.datePublished),
                          style: const TextStyle(color: Colors.grey)),
                      if (widget.commentInfo.likes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UsersWhoLikesOnPostPage(
                                        showSearchBar: false,
                                        usersIds: widget.commentInfo.likes,
                                      )));
                            },
                            child: Text(
                              "${widget.commentInfo.likes.length} ${widget.commentInfo.likes.length == 1 ? 'Like' : 'Likes'}",
                              style: const TextStyle(color: Colors.grey),
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
                        child: const Text(
                          "Reply",
                          style: TextStyle(color: Colors.grey),
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

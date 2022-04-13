import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/constant.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/comment_likes/comment_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/repliesInfo/replyLikes/reply_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/repliesInfo/reply_info_cubit.dart';
import 'package:instegram/presentation/pages/show_me_who_are_like.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import 'package:intl/intl.dart';

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
      required this.addReply ,
      required this.textController})
      : super(key: key);

  @override
  State<CommentInfo> createState() => _CommentInfoState();
}

class _CommentInfoState extends State<CommentInfo> {
  @override
  Widget build(BuildContext context) {
    bool isLiked = widget.commentInfo.likes.contains(myPersonalId);

    // if(widget.addReply){
    //   getData();
    // }
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        children: [
          rowOfCommentator(context, isLiked),
          if (!widget.isThatReply && widget.commentInfo.replies!.isNotEmpty)
            !widget.showMeReplies
                ? Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Row(
                      children: [
                        // const Divider(thickness: 30,color: Colors.black,indent: 10,endIndent: 60),
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
                      print(
                          "aaaaaaaawwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww $previous");
                      print(
                          "aaaaaaaawwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww $current");
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
                          child: ListView.separated(
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
                        );
                      } else if (state is CubitReplyInfoFailed) {
                        ToastShow.toastStateError(state);
                        return Text(state.toString());
                      } else {
                        return Row(
                          children: [
                            // const Divider(thickness: 30,color: Colors.black,indent: 10,endIndent: 60),
                            Container(
                                color: Colors.black12, height: 1, width: 40),
                            const SizedBox(width: 10),
                            const Expanded(
                                child: Text("Loading...",
                                    style: TextStyle(color: Colors.black45)))
                          ],
                        );
                      }
                    }),
        ],
      ),
    );
  }

  getData() async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    String formattedDate = formatter.format(now);
    formattedDate += "/${now.hour}/${now.minute}";

    Comment replyInfo = newReplyInfo(
        formattedDate, widget.commentInfo, widget.myPersonalInfo.userId);

    await ReplyInfoCubit.get(context).replyOnThisComment(replyInfo: replyInfo);
  }

  Comment newReplyInfo(
      String formattedDate, Comment commentInfo, String myPersonalId) {
    final _whitespaceRE = RegExp(r"\s+");
    String textWithOneSpaces =
        widget.textController.text.replaceAll(_whitespaceRE, " ");
    return Comment(
        datePublished: formattedDate,
        parentCommentId: commentInfo.commentUid,
        postId: commentInfo.postId,
        theComment: textWithOneSpaces,
        whoCommentId: myPersonalId,
        likes: []);
  }

  Row rowOfCommentator(BuildContext context, bool isLiked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatarOfProfileImage(
            imageUrl: widget.commentInfo.whoCommentInfo!.profileImageUrl,
            circleAvatarName: '',
            bodyHeight: widget.isThatReply ? 280 : 400,
            thisForStoriesLine: false),
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
                          TextSpan(
                            text: widget.commentInfo.theComment,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(widget.commentInfo.datePublished,
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
                          setState(() {
                            widget.selectedCommentInfo!(widget.commentInfo);
                          });
                          if (widget.selectedCommentInfo != null) {
                            print(
                                "==========================${widget.commentInfo.whoCommentInfo!.userName}");
                          }

                          //TODO replay on this guy
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
//
// class ReplyInfo extends StatefulWidget {
//   final Comment replyInfo;
//   TextEditingController controller;
//   ValueChanged<Comment>? selectedReplyInfo;
//
//   ReplyInfo(
//       {Key? key,
//         required this.replyInfo,
//         this.selectedReplyInfo,
//         required this.controller})
//       : super(key: key);
//
//   @override
//   State<ReplyInfo> createState() => _ReplyInfoState();
// }
//
// class _ReplyInfoState extends State<ReplyInfo> {
//   @override
//   Widget build(BuildContext context) {
//     bool isLiked = widget.replyInfo.likes.contains(myPersonalId);
//
//
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CircleAvatarOfProfileImage(
//                   imageUrl: widget.replyInfo.whoReplyInfo!.profileImageUrl,
//                   circleAvatarName: '',
//                   bodyHeight:
//                   // widget.isThatReply?250:
//                   330,
//                   thisForStoriesLine: false),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 3.0),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () {},
//                           child: Text.rich(
//                             TextSpan(
//                               children: <TextSpan>[
//                                 TextSpan(
//                                   text: widget
//                                       .replyInfo.whoReplyInfo!.userName,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const TextSpan(
//                                   text: '  ',
//                                 ),
//                                 TextSpan(
//                                   text: widget.replyInfo.theReply,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Text(widget.replyInfo.datePublished,
//                                 style: const TextStyle(color: Colors.grey)),
//                             if (widget.replyInfo.likes.isNotEmpty)
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 20.0),
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 UsersWhoLikesOnPostPage(
//                                                   showSearchBar: false,
//                                                   usersIds:
//                                                   widget.replyInfo.likes,
//                                                 )));
//                                   },
//                                   child: Text(
//                                     "${widget.replyInfo.likes.length} ${widget.replyInfo.likes.length == 1 ? 'Like' : 'Likes'}",
//                                     style: const TextStyle(color: Colors.grey),
//                                   ),
//                                 ),
//                               ),
//                             const SizedBox(width: 20),
//                             InkWell(
//                               onTap: () async {
//                                 String hashTag =
//                                     "@${widget.replyInfo.whoReplyInfo!.userName} ";
//                                 widget.controller.text = hashTag;
//
//                                 widget.controller.selection =
//                                     TextSelection.fromPosition(TextPosition(
//                                         offset: widget.controller.text.length));
//                                 setState(() {
//                                   widget.selectedReplyInfo!(widget.replyInfo);
//                                 });
//                                 if(widget.selectedReplyInfo!=null){
//                                   print("==========================${widget.replyInfo.whoReplyInfo!.userName}");
//                                 }
//
//                                 //TODO replay on this guy
//                               },
//                               child: const Text(
//                                 "Reply",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),
//                       ]),
//                 ),
//               ),
//               IconButton(
//                 icon: !isLiked
//                     ? const Icon(
//                   Icons.favorite_border,
//                   size: 15,
//                   color: Colors.grey,
//                 )
//                     : const Icon(
//                   Icons.favorite,
//                   size: 15,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     if (isLiked) {
//                       BlocProvider.of<ReplyLikesCubit>(context)
//                           .removeLikeOnThisReply(
//                         replyId: widget.replyInfo.replyUid ,
//                           myPersonalId: myPersonalId);
//                       widget.replyInfo.likes.remove(myPersonalId);
//                     } else {
//                       BlocProvider.of<ReplyLikesCubit>(context)
//                           .putLikeOnThisReply(
//                           replyId: widget.replyInfo.replyUid ,
//                           myPersonalId: myPersonalId);
//                       widget.replyInfo.likes.remove(myPersonalId);
//                       widget.replyInfo.likes.add(myPersonalId);
//                     }
//                   });
//                 },
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

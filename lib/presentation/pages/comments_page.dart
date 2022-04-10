import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/constant.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/commentsInfo/comments_info_cubit.dart';
import 'package:instegram/presentation/cubit/commentsInfo/post_likes/comment_likes_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/pages/show_me_who_are_like.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:intl/intl.dart';

import '../widgets/toast_show.dart';

class CommentsPage extends StatefulWidget {
  final String postId;

  const CommentsPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _newMediaLinkAddressController =
      TextEditingController();
  bool rebuildComments = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Comments'),
      ),
      body: BlocBuilder(
          bloc: CommentsInfoCubit.get(context)
            ..getCommentsOfThisPost(postId: widget.postId),
          buildWhen: (previous, current) {
            if (previous != current && (current is CubitCommentsInfoLoaded)) {
              return true;
            }
            // if (rebuildUsersInfo &&
            //     (current is CubitCommentsInfoLoaded)) {
            //   return true;
            // }
            return false;
          },
          builder: (context, state) {
            if (state is CubitCommentsInfoLoaded) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return theComment(state.commentsOfThePost[index]);
                  },
                  itemCount: state.commentsOfThePost.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                        height: 20,
                      ));
            } else if (state is CubitCommentsInfoFailed) {
              ToastShow.toastStateError(state);
              return const Text("Something Wrong");
            } else {
              return const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 1, color: Colors.black54),
              );
            }
          }),
      bottomSheet: addCommentBottomSheet(),
    );
  }

  SingleChildScrollView addCommentBottomSheet() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'put emoticons here',
                // style: TextStyles.textBody2
              ),
              const Divider(),
              Builder(builder: (context) {
                UserPersonalInfo? myPersonalInfo =
                    FirestoreUserInfoCubit.get(context).myPersonalInfo;
                return Row(
                  crossAxisAlignment:
                      _newMediaLinkAddressController.text.length < 70
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: CircleAvatarOfProfileImage(
                          imageUrl: myPersonalInfo!.profileImageUrl,
                          circleAvatarName: '',
                          bodyHeight: 330,
                          // isForCommentSection: true,
                          thisForStoriesLine: false),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(color: Colors.black26)),
                        autofocus: true,
                        controller: _newMediaLinkAddressController,
                        onChanged: (_) {
                          setState(() {
                            _newMediaLinkAddressController;
                          });
                        },
                      ),
                    ),
                    BlocBuilder<CommentsInfoCubit, CommentsInfoState>(
                        builder: (context, state) {
                      // if(state is CubitCommentsInfoLoading){
                      //   return Transform.scale(
                      //       scale: 0.50
                      //       ,child: const CircularProgressIndicator(color: Colors.blue,strokeWidth: 2,));
                      // }else if(state is CubitCommentsInfoFailed){
                      //   ToastShow.toastStateError(state);
                      // }
                      //TODO here we want to make comment loading when he loading
                      return InkWell(
                        onTap: () async {
                          DateTime now = DateTime.now();
                          DateFormat formatter = DateFormat('yyyy-MM-dd');
                          String formattedDate = formatter.format(now);

                          await CommentsInfoCubit.get(context).addComment(
                              commentInfo:
                                  commentInfo(myPersonalInfo, formattedDate));
                          setState(() {
                            _newMediaLinkAddressController.text = '';
                          });
                        },
                        child: const Text(
                          'Post',
                          style: TextStyle(color: Colors.blue),
                        ),
                      );
                    })
                  ],
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Comment commentInfo(UserPersonalInfo myPersonalInfo, String formattedDate) =>
      Comment(
          theComment: _newMediaLinkAddressController.text,
          commentatorId: myPersonalInfo.userId,
          datePublished: formattedDate,
          postId: widget.postId,
          likes: [],
          repliesIds: []);

  Widget theComment(Comment commentInfo) {
    bool isLiked = commentInfo.likes!.contains(myPersonalId);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatarOfProfileImage(
              imageUrl: commentInfo.commentatorInfo!.profileImageUrl,
              circleAvatarName: '',
              bodyHeight: 330,
              thisForStoriesLine: false),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //TODO This rather than inkWell
                  GestureDetector(
                    onTap: () {},
                    child: Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: commentInfo.commentatorInfo!.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: '  ',
                          ),
                          TextSpan(
                            text: commentInfo.theComment,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(commentInfo.datePublished,
                          style: const TextStyle(color: Colors.grey)),
                      if (commentInfo.likes!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UsersWhoLikesOnPostPage(
                                        showSearchBar: false,
                                        usersIds: commentInfo.likes!,
                                      )));
                            },
                            child: Text(
                              "${commentInfo.likes!.length} ${commentInfo.likes!.length == 1 ? 'Like' : 'Likes'}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          //TODO replay on this guy
                        },
                        child: const Text(
                          "Reply",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ]),
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
                if (isLiked) {
                  BlocProvider.of<CommentLikesCubit>(context)
                      .removeLikeOnThisComment(
                          postId: commentInfo.postId,
                          commentId: commentInfo.commentUid,
                          myPersonalId: myPersonalId);
                  commentInfo.likes!.remove(myPersonalId);
                } else {
                  BlocProvider.of<CommentLikesCubit>(context)
                      .putLikeOnThisComment(
                          postId: commentInfo.postId,
                          commentId: commentInfo.commentUid,
                          myPersonalId: myPersonalId);
                  commentInfo.likes!.add(myPersonalId);
                }
              });

              // setState(() {
              //
              // if(isLiked){
              // BlocProvider.of<PostLikesCubit>(context)
              //     .removeTheLikeOnThisPost(postId: postInfo.postUid, userId: myPersonalId);
              // postInfo.likes.remove(myPersonalId);
              //
              // }else{
              // BlocProvider.of<PostLikesCubit>(context)
              //     .putLikeOnThisPost(postId: postInfo.postUid, userId: myPersonalId);
              // postInfo.likes.add(myPersonalId);
              // }
              // // isLiked = isLiked ? false : true;
              // });
            },
          )
        ],
      ),
    );
  }
}

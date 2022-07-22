import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/comment.dart';
import 'package:instagram/data/models/notification.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/notification/notification_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:instagram/presentation/pages/comments/comments_for_mobile.dart';
import 'package:instagram/presentation/widgets/belong_to/comments_w/comment_box.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_post_display.dart';

class PostOfTimeLine extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final bool playTheVideo;
  final VoidCallback reLoadData;
  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;

  const PostOfTimeLine({
    Key? key,
    required this.postInfo,
    required this.reLoadData,
    required this.indexOfPost,
    required this.playTheVideo,
    required this.postsInfo,
  }) : super(key: key);

  @override
  State<PostOfTimeLine> createState() => _PostOfTimeLineState();
}

class _PostOfTimeLineState extends State<PostOfTimeLine>
    with TickerProviderStateMixin {
  final ValueNotifier<TextEditingController> commentTextController =
      ValueNotifier(TextEditingController());
  @override
  dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return thePostsOfHomePage(bodyHeight: 700);
  }

  Widget thePostsOfHomePage({required double bodyHeight}) {
    return Container(
      width: double.infinity,
      color:isThatMobile?null:ColorManager.white,
      child: ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPostDisplay(
              postInfo: widget.postInfo,
              postsInfo: widget.postsInfo,
              indexOfPost: widget.indexOfPost,
              playTheVideo: widget.playTheVideo,
              reLoadData: widget.reLoadData,
              textController: commentTextController,
              selectedCommentInfo: ValueNotifier(null),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (postInfoValue.comments.isNotEmpty) ...[
                    numberOfComment(postInfoValue),
                    const SizedBox(height: 8),
                  ],
                  if (isThatMobile) ...[
                    buildCommentBox(bodyHeight),
                    buildPublishingDate(postInfoValue, context),
                  ] else ...[
                    buildPublishingDate(postInfoValue, context),
                    const Divider(),
                    buildCommentBox(bodyHeight),
                  ],
                ]),
          ],
        ),
      ),
    );
  }

  Padding buildPublishingDate(Post postInfoValue, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5,top: 5.0),
      child: Text(
        DateOfNow.chattingDateOfNow(
            postInfoValue.datePublished, postInfoValue.datePublished),
        style: getNormalStyle(color: Theme.of(context).bottomAppBarColor),
      ),
    );
  }

  void _showAddCommentModal() {
    if (isThatMobile) {
      double media = MediaQuery.of(context).viewInsets.bottom;
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.only(bottom: media),
              child: ValueListenableBuilder(
                valueListenable: commentTextController,
                builder: (context, TextEditingController textValue, child) =>
                    CommentBox(
                  isThatCommentScreen: false,
                  postInfo: widget.postInfo.value,
                  textController: textValue,
                  userPersonalInfo: widget.postInfo.value.publisherInfo!,
                  currentFocus: ValueNotifier(FocusScopeNode()),
                  makeSelectedCommentNullable: makeSelectedCommentNullable,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  makeSelectedCommentNullable(bool isThatComment) {
    widget.postInfo.value.comments.add(" ");
    commentTextController.value.text = '';
    Navigator.maybePop(context);
  }

  Widget buildCommentBox(double bodyHeight) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: GestureDetector(
        onTap: _showAddCommentModal,
        child: ValueListenableBuilder(
          valueListenable: commentTextController,
          builder: (context, TextEditingController textValue, child) => Row(
            crossAxisAlignment: textValue.text.length < 70
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end,
            children: [
              CircleAvatarOfProfileImage(
                userInfo: widget.postInfo.value.publisherInfo!,
                bodyHeight: bodyHeight * .5,
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: commentTextController.value,
                  cursorColor: ColorManager.teal,
                  decoration: InputDecoration(
                    hintText: StringsManager.addComment.tr(),
                    hintStyle: TextStyle(
                        color: Theme.of(context).bottomAppBarColor, fontSize: 14),
                    fillColor: ColorManager.black,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  enabled: !isThatMobile,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (isThatMobile) ...[
                GestureDetector(
                  onTap: () {
                    commentTextController.value.text += '❤';
                    _showAddCommentModal();
                  },
                  child: const Text('❤'),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    commentTextController.value.text += '🙌';
                    _showAddCommentModal();
                  },
                  child: const Text('🙌'),
                ),
                const SizedBox(width: 8),
              ] else ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: InkWell(
                    onTap: () {
                      if (commentTextController.value.text.isNotEmpty) {
                        postTheComment(widget.postInfo.value.publisherInfo!);
                      }
                    },
                    child: Text(
                      StringsManager.post.tr(),
                      style: getNormalStyle(
                          color: commentTextController.value.text.isNotEmpty
                              ? ColorManager.blue
                              : ColorManager.lightBlue),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postTheComment(UserPersonalInfo userInfo) async {
    final _whitespaceRE = RegExp(r"\s+");
    String textWithOneSpaces =
        commentTextController.value.text.replaceAll(_whitespaceRE, " ");

    CommentsInfoCubit commentsInfoCubit =
        BlocProvider.of<CommentsInfoCubit>(context);
    await commentsInfoCubit.addComment(
        commentInfo: newCommentInfo(userInfo, textWithOneSpaces));
    makeSelectedCommentNullable(true);

    BlocProvider.of<NotificationCubit>(context).createNotification(
        newNotification: createNotification(textWithOneSpaces, userInfo));
    // To rebuild number of comments
    widget.postInfo.value.comments
        .add(newCommentInfo(userInfo, textWithOneSpaces));
  }

  CustomNotification createNotification(
      String textWithOneSpaces, UserPersonalInfo myPersonalInfo) {
    return CustomNotification(
      text: "commented: $textWithOneSpaces",
      postId: widget.postInfo.value.postUid,
      postImageUrl: widget.postInfo.value.postUrl,
      time: DateOfNow.dateOfNow(),
      senderId: myPersonalId,
      receiverId: widget.postInfo.value.publisherId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      isThatLike: false,
    );
  }

  Comment newCommentInfo(
      UserPersonalInfo myPersonalInfo, String textWithOneSpaces) {
    return Comment(
      theComment: textWithOneSpaces,
      whoCommentId: myPersonalInfo.userId,
      datePublished: DateOfNow.dateOfNow(),
      postId: widget.postInfo.value.postUid,
      likes: [],
      replies: [],
    );
  }

  Widget numberOfComment(Post postInfo) {
    int commentsLength = postInfo.comments.length;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(
            builder: (context) => CommentsPageForMobile(postInfo: postInfo),
          ));
        },
        child: Text(
          "${StringsManager.viewAll.tr()} $commentsLength ${commentsLength > 1 ? StringsManager.comments.tr() : StringsManager.comment.tr()}",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}

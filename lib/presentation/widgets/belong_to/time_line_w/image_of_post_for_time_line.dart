import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/pages/comments/comments_page.dart';
import 'package:instagram/presentation/widgets/belong_to/comments_w/comment_box.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_post_display.dart';

class ImageOfPostForTimeLine extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final bool playTheVideo;
  final VoidCallback reLoadData;
  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;

  const ImageOfPostForTimeLine({
    Key? key,
    required this.postInfo,
    required this.reLoadData,
    required this.indexOfPost,
    required this.playTheVideo,
    required this.postsInfo,
  }) : super(key: key);

  @override
  State<ImageOfPostForTimeLine> createState() => _ImageOfPostForTimeLineState();
}

class _ImageOfPostForTimeLineState extends State<ImageOfPostForTimeLine>
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
    return SizedBox(
      width: double.infinity,
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
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 11.5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    if (postInfoValue.comments.isNotEmpty) ...[
                      numberOfComment(postInfoValue),
                      const SizedBox(height: 8),
                    ],
                    buildCommentBox(bodyHeight),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 5.0),
                      child: Text(
                        DateOfNow.chattingDateOfNow(postInfoValue.datePublished,
                            postInfoValue.datePublished),
                        style: getNormalStyle(
                            color: Theme.of(context).bottomAppBarColor),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCommentModal() {
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
                focusNode: FocusNode(),
                userPersonalInfo: widget.postInfo.value.publisherInfo!,
                makeSelectedCommentNullable: makeSelectedCommentNullable,
              ),
            ),
          ),
        );
      },
    );
  }

  makeSelectedCommentNullable(bool isThatComment) {
    widget.postInfo.value.comments.add(" ");
    commentTextController.value.text = '';
    Navigator.maybePop(context);
  }

  Widget buildCommentBox(double bodyHeight) {
    return GestureDetector(
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
              child: GestureDetector(
                child: Text(
                  StringsManager.addComment.tr(),
                  style: TextStyle(
                      color: Theme.of(context).bottomAppBarColor, fontSize: 14),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                commentTextController.value.text = '❤';
                _showAddCommentModal();
              },
              child: const Text('❤'),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                commentTextController.value.text = '🙌';
                _showAddCommentModal();
              },
              child: const Text('🙌'),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget numberOfComment(Post postInfo) {
    int commentsLength = postInfo.comments.length;
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(
          builder: (context) => CommentsPage(postInfo: postInfo),
        ));
      },
      child: Text(
        "${StringsManager.viewAll.tr()} $commentsLength ${commentsLength > 1 ? StringsManager.comments.tr() : StringsManager.comment.tr()}",
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

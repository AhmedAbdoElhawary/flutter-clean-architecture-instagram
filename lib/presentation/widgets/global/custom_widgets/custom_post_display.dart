import 'package:flutter/material.dart';
import 'package:instagram/core/translations/app_lang.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instagram/presentation/pages/time_line/widgets/read_more_text.dart';
import 'package:instagram/presentation/widgets/global/others/count_of_likes.dart';
import 'package:instagram/presentation/widgets/global/others/image_of_post.dart';

class CustomPostDisplay extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final bool playTheVideo;
  final VoidCallback? reLoadData;
  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;
  final ValueNotifier<TextEditingController> textController;
  final ValueNotifier<Comment?> selectedCommentInfo;
  final ValueChanged<int>? removeThisPost;

  const CustomPostDisplay({
    Key? key,
    this.reLoadData,
    required this.textController,
    required this.selectedCommentInfo,
    required this.postInfo,
    required this.indexOfPost,
    required this.playTheVideo,
    required this.postsInfo,
    this.removeThisPost,
  }) : super(key: key);

  @override
  State<CustomPostDisplay> createState() => _CustomPostDisplayState();
}

class _CustomPostDisplayState extends State<CustomPostDisplay>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return thePostsOfHomePage(bodyHeight: bodyHeight);
  }

  Widget thePostsOfHomePage({required double bodyHeight}) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImageOfPost(
              postInfo: widget.postInfo,
              playTheVideo: widget.playTheVideo,
              reLoadData: widget.reLoadData,
              indexOfPost: widget.indexOfPost,
              postsInfo: widget.postsInfo,
              removeThisPost: widget.removeThisPost,
              textController: widget.textController,
              selectedCommentInfo: widget.selectedCommentInfo,
              rebuildPreviousWidget: () => setState(() {}),
            ),
            imageCaption(postInfoValue, bodyHeight, context)
          ],
        ),
      ),
    );
  }

  Padding imageCaption(
      Post postInfoValue, double bodyHeight, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (postInfoValue.likes.isNotEmpty)
            CountOfLikes(postInfo: postInfoValue),
          const SizedBox(height: 5),
          if (AppLanguage.getInstance().isLangEnglish) ...[
            ReadMore(
                "${postInfoValue.publisherInfo!.name} ${postInfoValue.caption}",
                2),
          ] else ...[
            ReadMore(
                "${postInfoValue.caption} ${postInfoValue.publisherInfo!.name}",
                2),
          ],
        ],
      ),
    );
  }
}

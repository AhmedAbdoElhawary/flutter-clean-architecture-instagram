import 'package:flutter/material.dart';
import 'package:instegram/data/models/post.dart';
import 'package:story_view/story_view.dart';
import 'package:instegram/presentation/widgets/instagram_story_swipe.dart';

class StoryPage extends StatefulWidget {
 final Post postInfo;
  const StoryPage({Key? key,required this.postInfo}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InstagramStorySwipe(

          children: [
            MoreStories(postInfo: widget.postInfo),
          ],
        ),
      ),
    );
  }
}


class MoreStories extends StatefulWidget {
  Post postInfo;
  MoreStories({Key? key,required this.postInfo}) : super(key: key);

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: [
          StoryItem.pageImage(
            url: widget.postInfo.postUrl,
            caption: widget.postInfo.caption,
            controller: storyController,
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          Navigator.maybePop(context);
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,inline: true,
        onVerticalSwipeComplete: (d) {
          Navigator.maybePop(context);
        },
        controller: storyController,
      ),
    );
  }
}

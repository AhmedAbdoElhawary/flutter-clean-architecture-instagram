import 'package:flutter/material.dart';
import 'package:instegram/data/models/story.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:story_view/story_view.dart';
import 'package:instegram/presentation/widgets/instagram_story_swipe.dart';

class StoryPage extends StatefulWidget {
 final UserPersonalInfo publisherInfo;
  const StoryPage({Key? key,required this.publisherInfo}) : super(key: key);

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
            MoreStories(storyInfo: widget.publisherInfo.storiesInfo!),
          ],
        ),
      ),
    );
  }
}


class MoreStories extends StatefulWidget {
  final List<Story> storyInfo;
  const MoreStories({Key? key,required this.storyInfo}) : super(key: key);

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
            url: widget.storyInfo[0].storyUrl,
            caption:widget.storyInfo[0].caption,
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
        repeat: true,inline: true,
        onVerticalSwipeComplete: (d) {
          Navigator.maybePop(context);
        },
        controller: storyController,
      ),
    );
  }
}

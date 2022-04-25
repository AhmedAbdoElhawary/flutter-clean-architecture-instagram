import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/globall.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/data/models/story.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/customPackages/story_view/sory_controller.dart';
import 'package:instegram/presentation/customPackages/story_view/story_view.dart';
import 'package:instegram/presentation/customPackages/story_view/utils.dart';

import 'package:instegram/presentation/widgets/instagram_story_swipe.dart';
class StoryPage extends StatefulWidget {
  final UserPersonalInfo user;
  final List<UserPersonalInfo> storiesOwnersInfo;

  const StoryPage({
    required this.user,
    required this.storiesOwnersInfo,
    Key? key,
  }) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late PageController controller;

  @override
  void initState() {
    super.initState();

    final initialPage = widget.storiesOwnersInfo.indexOf(widget.user);
    controller = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: InstagramStorySwipe(
            controller: controller,
            children: widget.storiesOwnersInfo
                .map((user) => StoryWidget(
                      storiesOwnersInfo: widget.storiesOwnersInfo,
                      user: user,
                      controller: controller,
                    ))
                .toList(),
          ),
        ),
      );
}

class StoryWidget extends StatefulWidget {
  final UserPersonalInfo user;
  final PageController controller;
  final List<UserPersonalInfo> storiesOwnersInfo;

  const StoryWidget({
    Key? key,
    required this.user,
    required this.storiesOwnersInfo,
    required this.controller,
  }) : super(key: key);

  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  bool shownThem=true;
  final storyItems = <StoryItem>[];
  late StoryController controller;
  double opacityLevel = 1.0;
  Story? date;

  void addStoryItems() {
    for (final story in widget.user.storiesInfo!) {
      switch (story.isThatImage) {
        case true:
          storyItems.add(StoryItem.inlineImage(
            roundedBottom: false,
            roundedTop: false,
            url: story.storyUrl,
            controller: controller,
            caption: Text(story.caption),
            duration: const Duration(
              milliseconds: 5000,
            ),
          ));
          break;
        case false:
          storyItems.add(
            StoryItem.text(
              title: story.caption,
              // TODO here -------------------------------------------->
              backgroundColor: Colors.black,
              duration: const Duration(
                milliseconds: 5000,
              ),
            ),
          );
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    controller = StoryController();
    addStoryItems();
    date = widget.user.storiesInfo![0];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleCompleted() {
    widget.controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    final currentIndex = widget.storiesOwnersInfo.indexOf(widget.user);
    final isLastPage = widget.storiesOwnersInfo.length - 1 == currentIndex;

    if (isLastPage) {
      Navigator.of(context).pop();
    }

  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onLongPressStart: (e){
                  setState(() {
                    // shownThem=false;
                    controller.pause();
                    opacityLevel=0;
                  });
                },
                onLongPressEnd: (e){
                  setState(() {
                    // shownThem=true;
                    opacityLevel=1;
                    controller.play();
                  });
                },
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Material(
                      type: MaterialType.transparency,
                      child: StoryView(
                        inline: true,
                        opacityLevel: opacityLevel,
                        progressPosition:ProgressPosition.top ,
                        storyItems: storyItems,
                        controller: controller,
                        onComplete: handleCompleted,
                        onVerticalSwipeComplete: (direction) {
                          if (direction == Direction.down||direction == Direction.up) {
                            Navigator.maybePop(context);
                          }
                        },
                        onStoryShow: (storyItem) {
                          final index = storyItems.indexOf(storyItem);

                          if (index > 0) {
                            setState(() {
                              date = widget.user.storiesInfo![index];
                            });
                          }
                        },
                      ),
                    ),
                    AnimatedOpacity(
                      opacity:opacityLevel ,
                      duration: const Duration(milliseconds: 250),

                      child: ProfileWidget(
                        user: widget.user,
                        storyInfo: date!,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity:opacityLevel ,
                      duration: const Duration(milliseconds: 250),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(
                                    color: Colors
                                        .white, //                   <--- border color
                                    width: 0.5,
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: 40,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, right: 20),
                                  child: Center(
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      cursorColor: Colors.teal,
                                      onTap: (){
                                        setState(() {
                                          controller.pause();
                                        });
                                      },
                                      showCursor: true,

                                      maxLines: null,
                                      decoration: const InputDecoration.collapsed(
                                          hintText: 'Send message',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Colors.grey)),
                                      autofocus: false,
                                      // controller: _textController,
                                      cursorWidth: 1.5,
                                      // onChanged: (e) {
                                      // setState(() {
                                      // _textController;
                                      // });
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            SvgPicture.asset(
                              IconsAssets.loveIcon,
                              width: .5,
                              color: Colors.white,
                              height: 25,
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            SvgPicture.asset(
                              IconsAssets.send2Icon,
                              color: Colors.white,
                              height: 23,
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class ProfileWidget extends StatelessWidget {
  final UserPersonalInfo user;
  final Story storyInfo;

  const ProfileWidget({
    required this.user,
    required this.storyInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                child: ClipOval(child: Image.network(user.profileImageUrl)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateOfNow.commentsDateOfNow(storyInfo.datePublished),
                      style: const TextStyle(color: Colors.white38),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
}

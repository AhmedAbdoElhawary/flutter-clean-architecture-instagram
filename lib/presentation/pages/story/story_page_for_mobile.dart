import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/child_classes/post/story.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/customPackages/story_view/story_controller.dart';
import 'package:instagram/presentation/customPackages/story_view/story_view.dart';
import 'package:instagram/presentation/customPackages/story_view/utils.dart';
import 'package:instagram/presentation/pages/story/widgets/story_swipe.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryPageForMobile extends StatefulWidget {
  final UserPersonalInfo user;
  final List<UserPersonalInfo> storiesOwnersInfo;
  final String hashTag;

  const StoryPageForMobile({
    required this.user,
    required this.storiesOwnersInfo,
    this.hashTag = "",
    Key? key,
  }) : super(key: key);

  @override
  StoryPageForMobileState createState() => StoryPageForMobileState();
}

class StoryPageForMobileState extends State<StoryPageForMobile> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: SafeArea(
        child: StorySwipe(
          controller: controller,
          children: widget.storiesOwnersInfo
              .map((user) => StoryWidget(
                    storiesOwnersInfo: widget.storiesOwnersInfo,
                    user: user,
                    controller: controller,
                    hashTag: widget.hashTag,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class StoryWidget extends StatefulWidget {
  final UserPersonalInfo user;
  final PageController controller;
  final List<UserPersonalInfo> storiesOwnersInfo;
  final String hashTag;

  const StoryWidget({
    Key? key,
    required this.user,
    required this.storiesOwnersInfo,
    required this.controller,
    required this.hashTag,
  }) : super(key: key);

  @override
  StoryWidgetState createState() => StoryWidgetState();
}

class StoryWidgetState extends State<StoryWidget> {
  final SharedPreferences _sharePrefs = injector<SharedPreferences>();

  bool shownThem = true;
  final storyItems = <StoryItem>[];
  ValueNotifier<StoryController> controller = ValueNotifier(StoryController());
  ValueNotifier<double> opacityLevel = ValueNotifier(1.0);
  ValueNotifier<Story?> date = ValueNotifier(null);

  void addStoryItems() {
    for (final story in widget.user.storiesInfo!) {
      storyItems.add(
        StoryItem.inlineImage(
          roundedBottom: false,
          roundedTop: false,
          isThatImage: story.isThatImage,
          blurHash: story.blurHash,
          url: story.storyUrl,
          controller: controller.value,
          imageFit: BoxFit.fitWidth,
          caption: Text(story.caption),
          duration: const Duration(milliseconds: 5000),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    addStoryItems();
    date.value = widget.user.storiesInfo![0];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleCompleted() async {
    _sharePrefs.setBool(widget.user.userId, true);

    widget.controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    final currentIndex = widget.storiesOwnersInfo.indexOf(widget.user);
    final isLastPage = widget.storiesOwnersInfo.length - 1 == currentIndex;

    if (isLastPage) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onLongPressStart: (e) {
                controller.value.pause();
                opacityLevel.value = 0;
              },
              onLongPressEnd: (e) {
                opacityLevel.value = 1;
                controller.value.play();
              },
              child: ValueListenableBuilder(
                valueListenable: opacityLevel,
                builder: (context, double opacityLevelValue, child) => Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Material(
                      type: MaterialType.transparency,
                      child: ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (context, StoryController storyControllerValue,
                                child) =>
                            StoryView(
                          inline: true,
                          opacityLevel: opacityLevelValue,
                          progressPosition: ProgressPosition.top,
                          storyItems: storyItems,
                          controller: storyControllerValue,
                          onComplete: handleCompleted,
                          onVerticalSwipeComplete: (direction) {
                            if (direction == Direction.down ||
                                direction == Direction.up) {
                              Navigator.of(context).maybePop();
                            }
                          },
                          onStoryShow: (storyItem) {
                            final index = storyItems.indexOf(storyItem);
                            final isLastPage = storyItems.length - 1 == index;
                            if (isLastPage) {
                              _sharePrefs.setBool(widget.user.userId, true);
                            }
                            if (index > 0) {
                              date.value = widget.user.storiesInfo![index];
                            }
                          },
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: opacityLevelValue,
                      duration: const Duration(milliseconds: 250),
                      child: ValueListenableBuilder(
                        valueListenable: date,
                        builder: (context, Story? value, child) =>
                            ProfileWidget(
                          user: widget.user,
                          storyInfo: value!,
                          hashTag: widget.hashTag,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: opacityLevelValue,
                      duration: const Duration(milliseconds: 250),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.all(15.0),
                          child: widget.user.userId == myPersonalId
                              ? const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                  size: 25,
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          border: Border.all(
                                            color: Colors
                                                .white, //                   <--- border color
                                            width: 0.5,
                                          ),
                                        ),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        height: 40,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 8.0, end: 20),
                                          child: Center(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              cursorColor: Colors.teal,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              onTap: () {
                                                controller.value.pause();
                                              },
                                              showCursor: true,
                                              maxLines: null,
                                              decoration: const InputDecoration
                                                  .collapsed(
                                                hintText:
                                                    StringsManager.sendMessage,
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              autofocus: false,
                                              cursorWidth: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    SvgPicture.asset(
                                      IconsAssets.loveIcon,
                                      width: .5,
                                      colorFilter: const ColorFilter.mode(
                                          ColorManager.white, BlendMode.srcIn),
                                      height: 25,
                                    ),
                                    const SizedBox(width: 25),
                                    SvgPicture.asset(
                                      IconsAssets.send2Icon,
                                      colorFilter: const ColorFilter.mode(
                                          ColorManager.white, BlendMode.srcIn),
                                      height: 23,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final UserPersonalInfo user;
  final Story storyInfo;
  final String hashTag;

  const ProfileWidget({
    required this.user,
    required this.storyInfo,
    required this.hashTag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsetsDirectional.only(
              start: 16, end: 16, top: 20, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (hashTag.isEmpty) ...[
                buildCircleAvatar()
              ] else ...[
                Hero(
                  tag: hashTag,
                  child: buildCircleAvatar(),
                ),
              ],
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
                      DateReformat.oneDigitFormat(storyInfo.datePublished),
                      style: const TextStyle(color: Colors.white38),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget buildCircleAvatar() {
    return CircleAvatarOfProfileImage(
      bodyHeight: 500,
      userInfo: user,
      showColorfulCircle: false,
      disablePressed: true,
    );
  }
}

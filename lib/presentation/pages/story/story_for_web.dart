import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/core/widgets/svg_pictures.dart';
import 'package:instagram/data/models/child_classes/post/story.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/customPackages/story_view/story_controller.dart';
import 'package:instagram/presentation/customPackages/story_view/story_view.dart';
import 'package:instagram/presentation/customPackages/story_view/utils.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/common/jump_arrow.dart';
import 'package:instagram/presentation/customPackages/snapping.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryPageForWeb extends StatefulWidget {
  final UserPersonalInfo user;
  final List<UserPersonalInfo> storiesOwnersInfo;
  final String hashTag;

  const StoryPageForWeb({
    Key? key,
    this.hashTag = "",
    required this.user,
    required this.storiesOwnersInfo,
  }) : super(key: key);

  @override
  StoryPageForWebState createState() => StoryPageForWebState();
}

class StoryPageForWebState extends State<StoryPageForWeb> {
  int currentPage = 0;
  late ScrollController _scrollPageController;
  double initialPage = 0;
  @override
  void initState() {
    super.initState();
    currentPage = widget.storiesOwnersInfo.indexOf(widget.user);
    initialPage = currentPage.toDouble();
    _scrollPageController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widthOfScreen = size.width;
    double heightOfStory = size.height < 600 ? 600 : size.height - 100;
    double widthOfStory = widthOfScreen < 900 ? 463 : 560;

    return Scaffold(
      backgroundColor: ColorManager.veryDarkGray,
      appBar: AppBar(
        backgroundColor: ColorManager.transparent,
        title: const InstagramLogo(
            color: ColorManager.white, enableOnTapForWeb: true),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: ColorManager.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: buildColumn(widthOfStory, heightOfStory),
    );
  }

  Column buildColumn(double widthOfStory, double heightOfStory) {
    return Column(
      children: [
        Expanded(
          child: ScrollSnapList(
            itemBuilder: (_, index) {
              if (index == widget.storiesOwnersInfo.length) {
                return const ThineCircularProgress();
              }
              return SizedBox(
                width: widthOfStory,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: heightOfStory,
                        width: widthOfStory,
                        child: StoryWidget(
                          allMainStoriesOwnersInfo: widget.storiesOwnersInfo,
                          user: widget.storiesOwnersInfo[index],
                          scrollControl: _scrollPageController,
                          currentPage: ValueNotifier(currentPage),
                          onItemFocus: onItemFocus,
                          itemSize: widthOfStory,
                          indexOfPage: ValueNotifier(index),
                          hashTag: "${widget.hashTag} , $index",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onItemFocus: onItemFocus,
            itemSize: widthOfStory,
            listController: _scrollPageController,
            initialIndex: initialPage,
            dynamicItemSize: true,
            scrollDirection: Axis.horizontal,
            onReachEnd: () {
              if (kDebugMode) {
                print('Done!');
              }
            },
            itemCount: widget.storiesOwnersInfo.length,
          ),
        ),
      ],
    );
  }

  void onItemFocus(pos) {
    setState(() => currentPage = pos);
    if (kDebugMode) {
      print('Done! $pos');
    }
  }
}

class StoryWidget extends StatefulWidget {
  final UserPersonalInfo user;
  final ScrollController scrollControl;
  final ValueNotifier<int> currentPage;
  final ValueNotifier<int> indexOfPage;
  final List<UserPersonalInfo> allMainStoriesOwnersInfo;
  final String hashTag;
  final void Function(int) onItemFocus;
  final double itemSize;

  const StoryWidget({
    Key? key,
    required this.user,
    required this.currentPage,
    required this.indexOfPage,
    required this.allMainStoriesOwnersInfo,
    required this.scrollControl,
    required this.hashTag,
    required this.onItemFocus,
    required this.itemSize,
  }) : super(key: key);

  @override
  StoryWidgetState createState() => StoryWidgetState();
}

class StoryWidgetState extends State<StoryWidget> {
  final SharedPreferences _sharePrefs = injector<SharedPreferences>();

  final storyItems = <StoryItem>[];
  ValueNotifier<Story?> date = ValueNotifier(null);
  final storyController = ValueNotifier(StoryController());
  final opacityLevel = ValueNotifier(1.0);
  final isFirstStory = ValueNotifier(true);
  final isLastStory = ValueNotifier(true);

  void addStoryItems() {
    for (final story in widget.user.storiesInfo!) {
      storyItems.add(StoryItem.inlineImage(
        roundedBottom: false,
        roundedTop: false,
        isThatImage: story.isThatImage,
        blurHash: story.blurHash,
        imageFit: BoxFit.fitWidth,
        url: story.storyUrl,
        controller: storyController.value,
        caption: Text(story.caption),
        duration: const Duration(
          milliseconds: 5000,
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    addStoryItems();
    date.value = widget.user.storiesInfo![0];
  }

  void handleCompleted() async {
    _sharePrefs.setBool(widget.user.userId, true);
    focusToItem(widget.indexOfPage.value + 1);
    int currentIndex = widget.allMainStoriesOwnersInfo.indexOf(widget.user);
    bool isLastPage =
        widget.allMainStoriesOwnersInfo.length - 1 == currentIndex;
    if (isLastPage) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentPage.value == widget.indexOfPage.value) {
      opacityLevel.value = 1;
      return buildFullStory();
    } else {
      storyController.value.pause();
      return ClipRRect(
          borderRadius: BorderRadius.circular(10), child: storyItems[0].view);
    }
  }

  Widget buildFullStory() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onLongPressStart: (e) {
              storyController.value.pause();
              opacityLevel.value = 0;
            },
            onLongPressEnd: (e) {
              opacityLevel.value = 1;
              storyController.value.play();
            },
            child: ValueListenableBuilder(
              valueListenable: opacityLevel,
              builder: (context, double opacityLevelValue, child) => Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Material(
                    type: MaterialType.transparency,
                    child: ValueListenableBuilder(
                      valueListenable: storyController,
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
                          if (isThatMobile &&
                              (direction == Direction.down ||
                                  direction == Direction.up)) {
                            Navigator.of(context).maybePop();
                          }
                        },
                        onStoryShow: (storyItem) {
                          final currentIndexOfOfStory =
                              storyItems.indexOf(storyItem);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              isFirstStory.value = 0 == currentIndexOfOfStory;
                              isLastStory.value = storyItems.length - 1 ==
                                  currentIndexOfOfStory;
                            });
                          });

                          if (isLastStory.value) {
                            _sharePrefs.setBool(widget.user.userId, true);
                          }
                          if (currentIndexOfOfStory > 0) {
                            date.value =
                                widget.user.storiesInfo![currentIndexOfOfStory];
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
                      builder: (context, Story? value, child) => ProfileWidget(
                        storyController: storyController,
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
                            : Row(children: [
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
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 8.0, end: 20),
                                      child: Center(
                                        child: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          cursorColor: Colors.teal,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          onTap: () {
                                            storyController.value.pause();
                                          },
                                          showCursor: true,
                                          maxLines: null,
                                          decoration:
                                              const InputDecoration.collapsed(
                                                  hintText: StringsManager
                                                      .sendMessage,
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey)),
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
                                      Colors.white, BlendMode.srcIn),
                                  height: 25,
                                ),
                                const SizedBox(width: 25),
                                SvgPicture.asset(
                                  IconsAssets.send2Icon,
                                  colorFilter: const ColorFilter.mode(
                                      ColorManager.white, BlendMode.srcIn),
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
        if (widget.currentPage.value == widget.indexOfPage.value) ...[
          if (!(widget.currentPage.value == 0 && isFirstStory.value))
            buildJumpArrow(),
          if (!(widget.currentPage.value >=
                  widget.allMainStoriesOwnersInfo.length - 1 &&
              isLastStory.value))
            buildJumpArrow(isThatBack: false),
        ],
      ],
    );
  }

  Widget buildJumpArrow({bool isThatBack = true}) {
    return GestureDetector(
      onTap: () async {
        if (!isThatBack) {
          storyController.value.next();
          return;
        }
        if (isFirstStory.value) {
          focusToItem(widget.indexOfPage.value - 1);
          return;
        }
        storyController.value.previous();
      },
      child: SizedBox(
          // width: widthOfStory + 100,
          child: ArrowJump(isThatBack: isThatBack)),
    );
  }

  double _calcCardLocation(int cardIndex) {
    int lengthOfStory = widget.allMainStoriesOwnersInfo.length;

    if (cardIndex < 0) {
      cardIndex = 0;
    } else if (cardIndex > lengthOfStory - 1) {
      cardIndex = lengthOfStory - 1;
    }
    widget.onItemFocus(cardIndex);
    return (cardIndex * widget.itemSize);
  }

  void _animateScroll(double location) {
    Future.delayed(Duration.zero, () {
      widget.scrollControl.animateTo(
        location,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void focusToItem(int index) {
    double targetLoc = _calcCardLocation(index);
    _animateScroll(targetLoc);
  }
}

class ProfileWidget extends StatelessWidget {
  final UserPersonalInfo user;
  final Story storyInfo;
  final String hashTag;
  final ValueNotifier<StoryController> storyController;

  ProfileWidget({
    required this.user,
    required this.storyInfo,
    required this.storyController,
    required this.hashTag,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<bool> isPlaying = ValueNotifier(true);

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
              ),
              ValueListenableBuilder(
                valueListenable: isPlaying,
                builder: (context, bool isPlayingValue, child) =>
                    GestureDetector(
                  onTap: () {
                    if (isPlaying.value) {
                      storyController.value.pause();
                      isPlaying.value = false;
                    } else {
                      storyController.value.play();
                      isPlaying.value = true;
                    }
                  },
                  child: Icon(
                      isPlayingValue
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white),
                ),
              ),
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

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/customPackages/story_view/story_image_for_web.dart';
import 'package:instagram/presentation/widgets/global/others/play_this_video.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'story_video.dart';
import 'story_controller.dart';
import 'utils.dart';

/// Indicates where the progress indicators should be placed.
enum ProgressPosition { top, bottom }

/// This is used to specify the height of the progress indicator. Inline stories
/// should use [small]
enum IndicatorHeight { small, large }

/// This is a representation of a story item (or page).
class StoryItem {
  /// Specifies how long the page should be displayed. It should be a reasonable
  /// amount of time greater than 0 milliseconds.
  final Duration duration;

  /// Has this page been shown already? This is used to indicate that the page
  /// has been displayed. If some pages are supposed to be skipped in a story,
  /// mark them as shown `shown = true`.
  ///
  /// However, during initialization of the story view, all pages after the
  /// last unshown page will have their `shown` attribute altered to false. This
  /// is because the next item to be displayed is taken by the last unshown
  /// story item.
  bool shown;

  String blurHashBackground;

  /// The page content
  final Widget view;
  StoryItem(
    this.view, {
    this.blurHashBackground = '',
    required this.duration,
    this.shown = false,
  });

  /// Short hand to create text-only page.
  ///
  /// [title] is the text to be displayed on [backgroundColor]. The text color
  /// alternates between [Colors.black] and [Colors.white] depending on the
  /// calculated contrast. This is to ensure readability of text.
  ///
  /// Works for inline and full-page stories. See [StoryView.inline] for more on
  /// what inline/full-page means.
  static StoryItem text({
    required String title,
    required Color backgroundColor,
    Key? key,
    TextStyle? textStyle,
    bool shown = false,
    bool roundedTop = false,
    bool roundedBottom = false,
    Duration? duration,
  }) {
    double contrast = ContrastHelper.contrast([
      backgroundColor.red,
      backgroundColor.green,
      backgroundColor.blue,
    ], [
      255,
      255,
      255
    ] /** white text */);

    return StoryItem(
      Container(
        key: key,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(roundedTop ? 8 : 0),
            bottom: Radius.circular(roundedBottom ? 8 : 0),
          ),
        ),
        padding: const EdgeInsetsDirectional.only(
            start: 24, end: 24, top: 16, bottom: 16),
        child: Center(
          child: Text(
            title,
            style: textStyle?.copyWith(
                  color: contrast > 1.8 ? Colors.white : Colors.black,
                ) ??
                TextStyle(
                  color: contrast > 1.8 ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        //color: backgroundColor,
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Factory constructor for page images. [controller] should be same instance as
  /// one passed to the `StoryView`
  factory StoryItem.pageImage({
    required String url,
    required StoryController controller,
    required String blurHash,
    required bool isThatImage,
    Key? key,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    Map<String, dynamic>? requestHeaders,
    Duration? duration,
  }) {
    return StoryItem(
      Container(
        key: key,
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            if (isThatMobile) ...[
              Align(
                  alignment: Alignment.center,
                  child: NetworkDisplay(
                      url: url, isThatImage: isThatImage, blurHash: blurHash)),
            ] else ...[
              StoryImageForWeb(url,
                  controller: controller,
                  isThatImage: isThatImage,
                  fit: imageFit,
                  key: key)
            ],
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.only(
                    bottom: 24,
                  ),
                  padding: const EdgeInsetsDirectional.only(
                      start: 24, end: 24, bottom: 8, top: 8),
                  color: caption != null
                      ? ColorManager.black54
                      : ColorManager.transparent,
                  child: caption != null
                      ? Text(
                          caption,
                          style: const TextStyle(
                            fontSize: 15,
                            color: ColorManager.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(),
                ),
              ),
            )
          ],
        ),
      ),
      blurHashBackground: blurHash,
      shown: shown,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Shorthand for creating inline image. [controller] should be same instance as
  /// one passed to the `StoryView`
  factory StoryItem.inlineImage({
    required String url,
    required bool isThatImage,
    Text? caption,
    required StoryController controller,
    required String blurHash,
    Key? key,
    BoxFit imageFit = BoxFit.cover,
    Map<String, dynamic>? requestHeaders,
    bool shown = false,
    bool roundedTop = true,
    bool roundedBottom = false,
    Duration? duration,
  }) {
    return StoryItem(
      ClipRRect(
        key: key,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(roundedTop ? 8 : 0),
          bottom: Radius.circular(roundedBottom ? 8 : 0),
        ),
        child: Container(
          color: ColorManager.black,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                color: blurHash.isEmpty ? ColorManager.black : null,
                child: blurHash.isNotEmpty ? BlurHash(hash: blurHash) : null,
              ),
              if (isThatMobile) ...[
                Align(
                  alignment: Alignment.center,
                  child: !isThatImage
                      ? PlayThisVideo(
                          play: true,
                          videoUrl: url,
                          blurHash: blurHash,
                        )
                      : NetworkDisplay(
                          url: url,
                          isThatImage: isThatImage,
                          blurHash: blurHash),
                ), // StoryImage.url(
              ] else ...[
                StoryImageForWeb(url,
                    controller: controller,
                    isThatImage: isThatImage,
                    fit: imageFit,
                    key: key)
              ],
              Container(
                margin: const EdgeInsetsDirectional.only(bottom: 16),
                padding: const EdgeInsetsDirectional.only(
                    start: 24, end: 24, top: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: double.infinity,
                    child: caption ?? const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      blurHashBackground: blurHash,
      shown: shown,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Shorthand for creating page video. [controller] should be same instance as
  /// one passed to the `StoryView`
  factory StoryItem.pageVideo(
    String url, {
    required StoryController controller,
    required String blurHash,
    Key? key,
    Duration? duration,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    Map<String, dynamic>? requestHeaders,
  }) {
    return StoryItem(
        Container(
          key: key,
          color: ColorManager.black,
          child: Stack(
            children: <Widget>[
              StoryVideo.url(
                url,
                controller: controller,
                requestHeaders: requestHeaders,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsetsDirectional.only(bottom: 24),
                    padding: const EdgeInsetsDirectional.only(
                        start: 24, end: 24, bottom: 8, top: 8),
                    color: caption != null
                        ? ColorManager.black54
                        : ColorManager.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                                fontSize: 15, color: ColorManager.white),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              )
            ],
          ),
        ),
        blurHashBackground: blurHash,
        shown: shown,
        duration: duration ?? const Duration(seconds: 10));
  }

  /// Shorthand for creating a story item from an image provider such as `AssetImage`
  /// or `NetworkImage`. However, the story continues to play while the image loads
  /// up.
  factory StoryItem.pageProviderImage(
    ImageProvider image, {
    Key? key,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    Duration? duration,
  }) {
    return StoryItem(
        Container(
          key: key,
          color: ColorManager.black,
          child: Stack(
            children: <Widget>[
              Center(
                child: Image(
                  image: image,
                  height: double.infinity,
                  width: double.infinity,
                  fit: imageFit,
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsetsDirectional.only(bottom: 24),
                    padding: const EdgeInsetsDirectional.only(
                        start: 24, end: 24, bottom: 8, top: 8),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              )
            ],
          ),
        ),
        shown: shown,
        duration: duration ?? const Duration(seconds: 3));
  }

  /// Shorthand for creating an inline story item from an image provider such as `AssetImage`
  /// or `NetworkImage`. However, the story continues to play while the image loads
  /// up.
  factory StoryItem.inlineProviderImage(
    ImageProvider image, {
    Key? key,
    Text? caption,
    bool shown = false,
    bool roundedTop = true,
    bool roundedBottom = false,
    Duration? duration,
  }) {
    return StoryItem(
      Container(
        key: key,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(roundedTop ? 8 : 0),
              bottom: Radius.circular(roundedBottom ? 8 : 0),
            ),
            image: DecorationImage(image: image, fit: BoxFit.cover)),
        child: Container(
          margin: const EdgeInsetsDirectional.only(bottom: 16),
          padding: const EdgeInsetsDirectional.only(
              start: 24, end: 24, bottom: 8, top: 8),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: double.infinity,
              child: caption ?? const SizedBox(),
            ),
          ),
        ),
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}

/// Widget to display stories just like Whatsapp and Instagram. Can also be used
/// inline/inside [ListView] or [Column] just like Google News app. Comes with
/// gestures to pause, forward and go to previous page.
class StoryView extends StatefulWidget {
  /// The pages to displayed.
  final List<StoryItem?> storyItems;

  /// Callback for when a full cycle of story is shown. This will be called
  /// each time the full story completes when [repeat] is set to `true`.
  final VoidCallback? onComplete;

  /// Callback for when a vertical swipe gesture is detected. If you do not
  /// want to listen to such event, do not provide it. For instance,
  /// for inline stories inside ListViews, it is preferrable to not to
  /// provide this callback so as to enable scroll events on the list view.
  final Function(Direction?)? onVerticalSwipeComplete;

  /// Callback for when a story is currently being shown.
  final ValueChanged<StoryItem>? onStoryShow;

  /// Where the progress indicator should be placed.
  final ProgressPosition progressPosition;

  /// Should the story be repeated forever?
  final bool repeat;

  /// If you would like to display the story as full-page, then set this to
  /// `false`. But in case you would display this as part of a page (eg. in
  /// a [ListView] or [Column]) then set this to `true`.
  final bool inline;

  // Controls the playback of the stories
  final StoryController controller;
  final double opacityLevel;

  const StoryView({
    Key? key,
    required this.storyItems,
    required this.controller,
    this.opacityLevel = 1,
    this.onComplete,
    this.onStoryShow,
    this.progressPosition = ProgressPosition.top,
    this.repeat = false,
    this.inline = false,
    this.onVerticalSwipeComplete,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StoryViewState();
  }
}

class StoryViewState extends State<StoryView> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _currentAnimation;
  Timer? _nextDebouncer;
  StreamSubscription<PlaybackState>? _playbackSubscription;

  VerticalDragInfo? verticalDragInfo;

  StoryItem? get _currentStory {
    return widget.storyItems.firstWhereOrNull((it) => !it!.shown);
  }

  Widget get _currentView {
    var item = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    item ??= widget.storyItems.last;
    return item?.view ?? Container();
  }

  @override
  void initState() {
    super.initState();

    // All pages after the first unshown page should have their shown value as
    // false
    final firstPage = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    if (firstPage == null) {
      for (var it2 in widget.storyItems) {
        it2!.shown = false;
      }
    } else {
      final lastShownPos = widget.storyItems.indexOf(firstPage);
      widget.storyItems.sublist(lastShownPos).forEach((it) {
        it!.shown = false;
      });
    }

    _playbackSubscription =
        widget.controller.playbackNotifier.listen((playbackStatus) {
      switch (playbackStatus) {
        case PlaybackState.play:
          _removeNextHold();
          _animationController?.forward();
          break;

        case PlaybackState.pause:
          _holdNext(); // then pause animation
          _animationController?.stop(canceled: false);
          break;

        case PlaybackState.next:
          _removeNextHold();
          _goForward();
          break;

        case PlaybackState.previous:
          _removeNextHold();
          _goBack();
          break;
      }
    });

    _play();
  }

  @override
  void dispose() {
    _clearDebouncer();

    _animationController?.dispose();
    _playbackSubscription?.cancel();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _play() {
    _animationController?.dispose();
    // get the next playing page
    final storyItem = widget.storyItems.firstWhere((it) {
      return !it!.shown;
    })!;

    if (widget.onStoryShow != null) {
      widget.onStoryShow!(storyItem);
    }

    _animationController =
        AnimationController(duration: storyItem.duration, vsync: this);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        storyItem.shown = true;
        if (widget.storyItems.last != storyItem) {
          _beginPlay();
        } else {
          // done playing
          _onComplete();
        }
      }
    });

    _currentAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!);

    widget.controller.play();
  }

  void _beginPlay() {
    setState(() {});
    _play();
  }

  void _onComplete() {
    if (widget.onComplete != null) {
      widget.controller.pause();
      widget.onComplete!();
    }

    if (widget.repeat) {
      for (var it in widget.storyItems) {
        it!.shown = false;
      }

      _beginPlay();
    }
  }

  void _goBack() {
    _animationController!.stop();

    if (_currentStory == null) {
      widget.storyItems.last!.shown = false;
    }

    if (_currentStory == widget.storyItems.first) {
      _beginPlay();
    } else {
      _currentStory!.shown = false;
      int lastPos = widget.storyItems.indexOf(_currentStory);
      final previous = widget.storyItems[lastPos - 1]!;

      previous.shown = false;

      _beginPlay();
    }
  }

  void _goForward() {
    if (_currentStory != widget.storyItems.last) {
      _animationController!.stop();

      // get last showing
      final last = _currentStory;

      if (last != null) {
        last.shown = true;
        if (last != widget.storyItems.last) {
          _beginPlay();
        }
      }
    } else {
      // this is the last page, progress animation should skip to end
      _animationController!
          .animateTo(1.0, duration: const Duration(milliseconds: 10));
    }
  }

  void _clearDebouncer() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _removeNextHold() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _holdNext() {
    _nextDebouncer?.cancel();
    _nextDebouncer = Timer(const Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          _currentView,
          AnimatedOpacity(
            opacity: widget.opacityLevel,
            duration: const Duration(milliseconds: 250),
            child: Align(
              alignment: widget.progressPosition == ProgressPosition.top
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: SafeArea(
                bottom: widget.inline ? false : true,
                // we use SafeArea here for notched and bezeles phones
                child: Container(
                  padding: const EdgeInsetsDirectional.only(
                      start: 16, end: 16, bottom: 8, top: 8),
                  child: PageBar(
                    widget.storyItems
                        .map((it) => PageData(it!.duration, it.shown))
                        .toList(),
                    _currentAnimation,
                    key: UniqueKey(),
                    indicatorHeight: widget.inline
                        ? IndicatorHeight.small
                        : IndicatorHeight.large,
                  ),
                ),
              ),
            ),
          ),
          if (isThatMobile) ...[
            Align(
              alignment: Alignment.centerRight,
              heightFactor: 1,
              child: GestureDetector(
                onTapDown: (details) {
                  widget.controller.pause();
                },
                onTapCancel: () {
                  widget.controller.play();
                },
                onTapUp: (details) {
                  // if debounce timed out (not active) then continue anim

                  if (_nextDebouncer?.isActive == false) {
                    widget.controller.play();
                  } else {
                    widget.controller.next();
                  }
                },
                onVerticalDragStart: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        widget.controller.pause();
                      },
                onVerticalDragCancel: widget.onVerticalSwipeComplete == null
                    ? null
                    : () {
                        widget.controller.play();
                      },
                onVerticalDragUpdate: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        verticalDragInfo ??= VerticalDragInfo();

                        verticalDragInfo!.update(details.primaryDelta!);
                      },
                onVerticalDragEnd: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        widget.controller.play();
                        // finish up drag cycle
                        if (!verticalDragInfo!.cancel &&
                            widget.onVerticalSwipeComplete != null) {
                          widget.onVerticalSwipeComplete!(
                              verticalDragInfo!.direction);
                        }

                        verticalDragInfo = null;
                      },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              heightFactor: 1,
              child: SizedBox(
                  width: 70,
                  child: GestureDetector(
                    onTap: () {
                      widget.controller.previous();
                    },
                  )),
            ),
          ],
        ],
      ),
    );
  }
}

/// Capsule holding the duration and shown property of each story. Passed down
/// to the pages bar to render the page indicators.
class PageData {
  Duration duration;
  bool shown;

  PageData(this.duration, this.shown);
}

/// Horizontal bar displaying a row of [StoryProgressIndicator] based on the
/// [pages] provided.
class PageBar extends StatefulWidget {
  final List<PageData> pages;
  final Animation<double>? animation;
  final IndicatorHeight indicatorHeight;

  const PageBar(
    this.pages,
    this.animation, {
    this.indicatorHeight = IndicatorHeight.large,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageBarState();
  }
}

class PageBarState extends State<PageBar> {
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.pages.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);

    widget.animation!.addListener(() {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isPlaying(PageData page) {
    return widget.pages.firstWhereOrNull((it) => !it.shown) == page;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.pages.map((it) {
        return Expanded(
          child: Container(
            padding: EdgeInsetsDirectional.only(
                end: widget.pages.last == it ? 0 : spacing),
            child: StoryProgressIndicator(
              isPlaying(it) ? widget.animation!.value : (it.shown ? 1 : 0),
              indicatorHeight:
                  widget.indicatorHeight == IndicatorHeight.large ? 3 : 1.3,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Custom progress bar. Supposed to be lighter than the
/// original [ProgressIndicator], and rounded at the sides.
class StoryProgressIndicator extends StatelessWidget {
  /// From `0.0` to `1.0`, determines the progress of the indicator
  final double value;
  final double indicatorHeight;

  const StoryProgressIndicator(
    this.value, {
    Key? key,
    this.indicatorHeight = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(
        indicatorHeight,
      ),
      foregroundPainter: IndicatorOval(
        Colors.white.withOpacity(0.8),
        value,
      ),
      painter: IndicatorOval(
        Colors.white.withOpacity(0.4),
        1.0,
      ),
    );
  }
}

class IndicatorOval extends CustomPainter {
  final Color color;
  final double widthFactor;

  IndicatorOval(this.color, this.widthFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width * widthFactor, size.height),
            const Radius.circular(3)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// Concept source: https://stackoverflow.com/a/9733420
class ContrastHelper {
  static double luminance(int? r, int? g, int? b) {
    final a = [r, g, b].map((it) {
      double value = it!.toDouble() / 255.0;
      return value <= 0.03928
          ? value / 12.92
          : pow((value + 0.055) / 1.055, 2.4);
    }).toList();

    return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
  }

  static double contrast(rgb1, rgb2) {
    return luminance(rgb2[0], rgb2[1], rgb2[2]) /
        luminance(rgb1[0], rgb1[1], rgb1[2]);
  }
}

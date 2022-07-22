import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/points_scroll_bar.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/common/jump_arrow.dart';

class ImagesSlider extends StatefulWidget {
  final List<dynamic> imagesUrls;
  final double aspectRatio;
  final String blurHash;
  final bool showPointsScrollBar;
  final Function(int, CarouselPageChangedReason) updateImageIndex;
  const ImagesSlider({
    Key? key,
    required this.imagesUrls,
    this.blurHash = "",
    required this.updateImageIndex,
    required this.aspectRatio,
    this.showPointsScrollBar = false,
  }) : super(key: key);

  @override
  State<ImagesSlider> createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  ValueNotifier<int> initPosition = ValueNotifier(0);
  ValueNotifier<double> countOpacity = ValueNotifier(0);
  final CarouselController _controller = CarouselController();
  @override
  void didChangeDependencies() {
    widget.imagesUrls.map((url) => precacheImage(NetworkImage(url), context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double withOfScreen = MediaQuery.of(context).size.width;
    bool minimumWidth = withOfScreen > 800;
    return Center(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: ValueListenableBuilder(
          valueListenable: initPosition,
          builder:
              (BuildContext context, int initPositionValue, Widget? child) =>
                  Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                carouselController: _controller,
                items: widget.imagesUrls.map((url) {
                  precacheImage(NetworkImage(url), context);
                  return Hero(
                    tag: url,
                    child: NetworkImageDisplay(
                      aspectRatio: widget.aspectRatio,
                      blurHash: widget.blurHash,
                      imageUrl: url,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  aspectRatio: widget.aspectRatio,
                  onPageChanged: (index, reason) {
                    countOpacity.value = 1;
                    initPosition.value = index;
                    widget.updateImageIndex(index, reason);
                  },
                ),
              ),
              if (widget.showPointsScrollBar && minimumWidth)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PointsScrollBar(
                      photoCount: widget.imagesUrls.length,
                      activePhotoIndex: initPositionValue,
                      makePointsWhite: true,
                    ),
                  ),
                ),
              if (initPositionValue != 0)
                GestureDetector(
                    onTap: () {
                      initPosition.value--;
                      _controller.animateToPage(initPosition.value,
                          curve: Curves.easeInOut);
                    },
                    child: const JumpArrow()),
              if (initPositionValue < widget.imagesUrls.length - 1)
                GestureDetector(
                  onTap: () {
                    initPosition.value++;
                    _controller.animateToPage(initPosition.value,
                        curve: Curves.easeInOut);
                  },
                  child: const JumpArrow(isThatBack: false),
                ),
              slideCount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget slideCount() {
    return ValueListenableBuilder(
      valueListenable: countOpacity,
      builder: (context, double countOpacityValue, child) {
        if (countOpacityValue == 1) {
          Future.delayed(const Duration(seconds: 5), () {
            countOpacity.value = 0;
          });
        }
        return AnimatedOpacity(
          opacity: countOpacityValue,
          duration: const Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsetsDirectional.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                height: 23,
                width: 35,
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: initPosition,
                    builder: (context, int initPositionValue, child) => Text(
                      '${initPositionValue + 1}/${widget.imagesUrls.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

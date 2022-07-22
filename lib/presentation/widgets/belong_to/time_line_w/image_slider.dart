import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';

class ImagesSlider extends StatefulWidget {
  final List<dynamic> imagesUrls;
  final double aspectRatio;
  final String blurHash;

  final Function(int, CarouselPageChangedReason) updateImageIndex;
  const ImagesSlider({
    Key? key,
    required this.imagesUrls,
    this.blurHash = "",
    required this.updateImageIndex,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  State<ImagesSlider> createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  ValueNotifier<int> initPosition = ValueNotifier(0);
  ValueNotifier<double> countOpacity = ValueNotifier(0);

  @override
  void didChangeDependencies() {
    widget.imagesUrls.map((url) => precacheImage(NetworkImage(url), context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: widget.imagesUrls.map((url) {
            precacheImage(NetworkImage(url), context);
            return Hero(
              tag: url,
              child: NetworkImageDisplay(
                  blurHash: widget.blurHash,
                  imageUrl: url,
                  aspectRatio: widget.aspectRatio),
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
        slideCount(),
      ],
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
                // color: Colors.teal,
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

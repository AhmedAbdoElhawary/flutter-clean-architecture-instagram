import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';

class ImageSlider extends StatefulWidget {
  final List<dynamic> imagesUrls;
  final double aspectRatio;
  final String blurHash;

  final Function(int, CarouselPageChangedReason) updateImageIndex;
  const ImageSlider({
    Key? key,
    required this.imagesUrls,
    this.blurHash = "",
    required this.updateImageIndex,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  void didChangeDependencies() {
    widget.imagesUrls.map((url) => precacheImage(NetworkImage(url), context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
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
        onPageChanged: widget.updateImageIndex,
      ),
    );
  }
}

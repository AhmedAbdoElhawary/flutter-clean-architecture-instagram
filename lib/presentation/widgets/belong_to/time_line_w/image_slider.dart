import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<dynamic> imagesUrls;
  final Function(int, CarouselPageChangedReason) updateImageIndex;
  const ImageSlider(
      {Key? key, required this.imagesUrls, required this.updateImageIndex})
      : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  void didChangeDependencies() {
    widget.imagesUrls.map((url)=> precacheImage(NetworkImage(url), context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: widget.imagesUrls.map((url) {
        precacheImage(NetworkImage(url), context);
        return Hero(
          tag: url,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: widget.updateImageIndex,
      ),
    );
  }
}

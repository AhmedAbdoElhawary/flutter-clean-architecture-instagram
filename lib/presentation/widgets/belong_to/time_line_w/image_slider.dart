import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final List<dynamic> imagesUrls;
  final Function(int, CarouselPageChangedReason) updateImageIndex;
  const ImageSlider(
      {Key? key, required this.imagesUrls, required this.updateImageIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imagesUrls.map((url) {
        return Hero(
          tag: url,
          child: Image.network(
            url,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: updateImageIndex,
      ),
    );
  }
}

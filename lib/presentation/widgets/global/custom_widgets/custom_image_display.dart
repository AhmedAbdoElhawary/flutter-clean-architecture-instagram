import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';

class ImageDisplay extends StatelessWidget {
  final String imageUrl;
  final BoxFit boxFit;
  final bool circularLoading;
  final double aspectRatio;
  final double bodyHeight;

  const ImageDisplay(
      {Key? key,
      required this.imageUrl,
      this.bodyHeight = 0,
      this.aspectRatio = 0,
      this.circularLoading = true,
      this.boxFit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return aspectRatio <= 0.2
        ? buildImage()
        : AspectRatio(
            aspectRatio: aspectRatio < .5
                ? aspectRatio / aspectRatio / aspectRatio
                : aspectRatio,
            child: buildImage(),
          );
  }

  Widget buildImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
        child: circularLoading
            ? loadingWidget(aspectRatio)
            : const CircleAvatar(
                radius: 15, backgroundColor: ColorManager.lowOpacityGrey),
      ),
      errorWidget: (context, url, error) => SizedBox(
        width: double.infinity,
        height: aspectRatio,
        child: Icon(Icons.warning_amber_rounded,
            size: 50, color: Theme.of(context).focusColor),
      ),
    );
  }

  Widget loadingWidget(double aspectRatio) {
    return aspectRatio == 0
        ? buildSizedBox()
        : AspectRatio(
            aspectRatio: aspectRatio,
            child: buildSizedBox(),
          );
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      color: ColorManager.black26,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';

class ImageDisplay extends StatefulWidget {
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
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  @override
  Widget build(BuildContext context) {
    return widget.aspectRatio <= 0.2
        ? buildImage()
        : (widget.aspectRatio == 360
            ? buildImageThree()
            : AspectRatio(
                aspectRatio: widget.aspectRatio < .5
                    ? widget.aspectRatio /
                        widget.aspectRatio /
                        widget.aspectRatio
                    : widget.aspectRatio,
                child: buildImage(),
              ));
  }

  Image buildImageThree() {
    Image image = Image.network(
      widget.imageUrl,
      fit: widget.boxFit,
      height: 360,
      width: double.infinity,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: widget.circularLoading
              ? loadingWidget(widget.aspectRatio)
              : const CircleAvatar(
                  radius: 15, backgroundColor: ColorManager.lowOpacityGrey),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return SizedBox(
          width: double.infinity,
          height: 360,
          child: Icon(Icons.warning_amber_rounded,
              size: 50, color: Theme.of(context).focusColor),
        );
      },
    );
    return image;
  }

  Image buildImage() {
    Image image = Image.network(
      widget.imageUrl,
      fit: widget.boxFit,
      width: double.infinity,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: widget.circularLoading
              ? loadingWidget(widget.aspectRatio)
              : const CircleAvatar(
                  radius: 15, backgroundColor: ColorManager.lowOpacityGrey),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return SizedBox(
          width: double.infinity,
          height: widget.aspectRatio,
          child: Icon(Icons.warning_amber_rounded,
              size: 50, color: Theme.of(context).focusColor),
        );
      },
    );
    return image;
  }

  Widget loadingWidget(double aspectRatio) {
    return aspectRatio == 0
        ? buildSizedBox()
        : aspectRatio == 360
            ? buildSizedBoxThree()
            : AspectRatio(
                aspectRatio: aspectRatio,
                child: buildSizedBox(),
              );
  }

  Widget buildSizedBoxThree() {
    return Container(
      width: double.infinity,
      color: ColorManager.black26,
      height: 360,
    );
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      color: ColorManager.black26,
    );
  }
}

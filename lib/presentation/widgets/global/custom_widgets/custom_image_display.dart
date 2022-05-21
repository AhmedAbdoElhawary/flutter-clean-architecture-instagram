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
      this.boxFit = BoxFit.fitWidth})
      : super(key: key);

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  @override
  Widget build(BuildContext context) {
    return buildImage();
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
    return buildSizedBox();
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      height: 300,
      color: ColorManager.black26,
    );
  }
}

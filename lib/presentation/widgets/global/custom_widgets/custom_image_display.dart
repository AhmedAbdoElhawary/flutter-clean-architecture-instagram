import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';

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
        : AspectRatio(
            aspectRatio: widget.aspectRatio < .5
                ? widget.aspectRatio / widget.aspectRatio / widget.aspectRatio
                : widget.aspectRatio,
            child: buildImage(),
          );
  }

  Widget buildImage() {
    return Image.network(
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
              ? buildCircularProgress(widget.aspectRatio)
              : const CircleAvatar(
                  radius: 15, backgroundColor: ColorManager.lowOpacityGrey),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return SizedBox(
          width: double.infinity,
          height: widget.aspectRatio,
          child: Icon(Icons.warning_amber_rounded, size: 50,color: Theme.of(context).focusColor),
        );
      },
    );
  }

  Widget buildCircularProgress(double aspectRatio) {
    return aspectRatio == 0
        ? buildSizedBox()
        : AspectRatio(
            aspectRatio: aspectRatio,
            child: buildSizedBox(),
          );
  }

  SizedBox buildSizedBox() {
    return const SizedBox(
      width: double.infinity,
      child: ThineCircularProgress(),
    );
  }
}

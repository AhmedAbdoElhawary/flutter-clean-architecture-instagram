import 'dart:async';

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
  int a=0;
  @override
  Widget build(BuildContext context) {
    return
        widget.aspectRatio <= 0.2
          ?
        buildImage()
        : AspectRatio(
            aspectRatio: widget.aspectRatio < .5
                ? widget.aspectRatio / widget.aspectRatio / widget.aspectRatio
                : widget.aspectRatio,
            child: buildImage(),
          )
        ;
  }

  Image buildImage() {
    Image image= Image.network(
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
    final c = Completer<ImageInfo>();
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo i, bool _) {
      c.complete(i);
      print("====================================================================================> ${i.image.height}");
    }));
    return image;
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

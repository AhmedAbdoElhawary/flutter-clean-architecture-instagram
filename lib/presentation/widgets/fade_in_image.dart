import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/utility/constant.dart';

class CustomFadeInImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit boxFit;
  final bool circularLoading;
  final double aspectRatio;
  final double bodyHeight;
  const CustomFadeInImage(
      {Key? key,
      required this.imageUrl,
      this.bodyHeight = 0,
      this.aspectRatio = 0,
      this.circularLoading = true,
      this.boxFit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return aspectRatio == 0
        ? buildImage()
        : AspectRatio(
            aspectRatio: aspectRatio < .5
                ? aspectRatio / aspectRatio / aspectRatio
                : aspectRatio,
            child: buildImage(),
          );
  }

  Image buildImage() {
    return Image.network(
      imageUrl,
      fit: boxFit,
      width: double.infinity,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          timelinesImages[imageUrl] = true;
          return child;
        }
        return Center(
          child: circularLoading
              ? buildCircularProgress(aspectRatio)
              : const CircleAvatar(
                  radius: 15, backgroundColor: ColorManager.lowOpacityGrey),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return SizedBox(
          width: double.infinity,
          height: aspectRatio,
          child: SvgPicture.asset(IconsAssets.warningIcon, height: 25),
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
      child: Center(
          child: CircularProgressIndicator(
        color: Colors.black54,
        strokeWidth: 2,
      )),
    );
  }
}

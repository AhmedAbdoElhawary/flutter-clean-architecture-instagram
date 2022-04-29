import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';

class CustomFadeInImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit boxFit;
  final bool circularLoading;

  const CustomFadeInImage(
      {Key? key, required this.imageUrl,this.circularLoading=true, this.boxFit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: boxFit,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: circularLoading?buildCircularProgress():const CircleAvatar(radius: 15,backgroundColor: ColorManager.lowOpacityGrey),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return SizedBox(
          width: double.infinity,
          height: 400.0,
          child: SvgPicture.asset(IconsAssets.warningIcon, height: 25),
        );
      },
    );
  }

  SizedBox buildCircularProgress() => const SizedBox(
        height: 300,
        width: double.infinity,
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.black54,
          strokeWidth: 2,
        )),
      );
}

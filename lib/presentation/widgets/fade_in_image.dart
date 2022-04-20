import 'package:flutter/material.dart';
import 'package:instegram/core/resources/assets_manager.dart';


class CustomFadeInImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit boxFit;
  const CustomFadeInImage(
      {Key? key, required this.imageUrl, this.boxFit = BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    FadeInImage(
      fit:boxFit ,
      placeholder:  const AssetImage(IconsAssets.addLikeLoadingIcon),
      imageErrorBuilder: (_, __, ___) {
        return SizedBox(
          width: double.infinity,
          height: 400.0,
          child: Image.asset(IconsAssets.heartIcon),
        );
      },
      image: NetworkImage(imageUrl));
    //   Container(
    //   color: ColorManager.lightGrey,
    //   child: Image.network(
    //     imageUrl,
    //     fit: boxFit,
    //     width: double.infinity,
    //     // loadingBuilder: (_, __, ___) {
    //     //
    //     //   return Container(color: ColorManager.grey,width: double.infinity,);
    //     // },
    //     errorBuilder: (_, __, ___) {
    //       return SizedBox(
    //         width: double.infinity,
    //         height: 400.0,
    //         child: Image.asset(IconsAssets.warningIcon),
    //       );
    //     },
    //   ),
    // );

  }
}

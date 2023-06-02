import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';

class AllCatchUpIcon extends StatelessWidget {
  const AllCatchUpIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double size = 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          child: SizedBox(
            width: size * 1.2,
            height: size * 1.2,
            child: SvgPicture.asset(
              IconsAssets.noMoreData,
              height: size,
              colorFilter: const ColorFilter.mode(
                  ColorManager.white , BlendMode.srcIn),
            ),
          ),
          shaderCallback: (Rect bounds) {
            Rect rect = const Rect.fromLTRB(0, 0, size, size);
            return const LinearGradient(
              colors: <Color>[
                ColorManager.blackRed,
                ColorManager.redAccent,
                ColorManager.yellow,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ).createShader(rect);
          },
        ),
        const SizedBox(height: 5),
        Text(StringsManager.allCaughtUp.tr,
            style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 15),
        Text(StringsManager.noMorePostToday.tr,
            style: Theme.of(context).textTheme.displayLarge),
      ],
    );
  }
}

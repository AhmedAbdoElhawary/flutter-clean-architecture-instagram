import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/pages/story/stroy_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'circle_avatar_name.dart';

class CircleAvatarOfProfileImage extends StatefulWidget {
  final double bodyHeight;
  final bool thisForStoriesLine;
  final UserPersonalInfo userInfo;
  final String nameOfCircle;
  final String hashTag;
  final bool moveTextMore;

  const CircleAvatarOfProfileImage({
    required this.userInfo,
    required this.bodyHeight,
    this.moveTextMore = false,
    this.hashTag = "",
    this.nameOfCircle = "",
    this.thisForStoriesLine = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CircleAvatarOfProfileImage> createState() =>
      _CircleAvatarOfProfileImageState();
}

class _CircleAvatarOfProfileImageState extends State<CircleAvatarOfProfileImage>
    with SingleTickerProviderStateMixin {
  final SharedPreferences _sharePrefs = injector<SharedPreferences>();

  late Animation gap;
  late Animation base;
  late Animation reverse;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    base = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    reverse =
        Tween<double>(begin: 0.0, end: -1.0).animate(base as Animation<double>);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base as Animation<double>)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Color> colorList = [
    ColorManager.red,
    ColorManager.redAccent,
    ColorManager.yellow
  ];
  int index = 0;
  Color bottomColor = ColorManager.red;
  Color topColor = ColorManager.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;
  @override
  Widget build(BuildContext context) {
    String profileImage = widget.userInfo.profileImageUrl;
    if (controller.isCompleted) {
      Future.delayed(const Duration(milliseconds: 5), () {
        setState(() {
          topColor = ColorManager.red;
        });
      });
    }

    return SizedBox(
      height: widget.bodyHeight * 0.14,
      child: widget.thisForStoriesLine
          ? buildColumn(profileImage, context)
          : buildStack(profileImage, context),
    );
  }

  Widget buildColumn(String profileImage, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildStack(profileImage, context),
          if (widget.thisForStoriesLine) ...[
            SizedBox(height: widget.bodyHeight * 0.004),
            if (widget.moveTextMore)
              SizedBox(height: widget.bodyHeight * 0.015),
            NameOfCircleAvatar(
                widget.nameOfCircle.isEmpty
                    ? widget.userInfo.name
                    : widget.nameOfCircle,
                widget.thisForStoriesLine),
          ]
        ],
      ),
    );
  }

  onPressedImage(BuildContext context) async {
    if (widget.userInfo.stories.isNotEmpty) {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        maintainState: false,
        builder: (context) {
          return BlocBuilder<StoryCubit, StoryState>(
            bloc: StoryCubit.get(context)
              ..getSpecificStoriesInfo(userInfo: widget.userInfo),
            buildWhen: (previous, current) {
              if (previous != current && current is SpecificStoriesInfoLoaded) {
                return true;
              }
              if (previous != current && current is CubitStoryFailed) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is SpecificStoriesInfoLoaded) {
                return StoryPage(
                    hashTag: widget.hashTag,
                    user: state.userInfo,
                    storiesOwnersInfo: [state.userInfo]);
              } else {
                return Scaffold(
                    body: Center(
                  child: CustomCircularProgress(Theme.of(context).focusColor),
                ));
              }
            },
          );
        },
      ));
    }
  }

  Widget buildStack(String profileImage, BuildContext context) {
    return widget.thisForStoriesLine
        ? stackOfImage(profileImage)
        : GestureDetector(
            onTap: () => onPressedImage(context),
            child: stackOfImage(profileImage),
          );
  }

  Stack stackOfImage(String profileImage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.userInfo.stories.isNotEmpty) ...[
          if (_sharePrefs.getBool(widget.userInfo.userId) != null) ...[
            CircleAvatar(
              radius: widget.bodyHeight < 900
                  ? widget.bodyHeight * .052
                  : widget.bodyHeight * .0505,
              backgroundColor: ColorManager.lowOpacityGrey,
            ),
          ] else ...[
            if (!controller.isCompleted && widget.thisForStoriesLine) ...[
              rotationContainer(),
            ] else ...[
              colorfulContainer(),
            ],
          ],
          CircleAvatar(
            radius: widget.bodyHeight < 900
                ? widget.bodyHeight * .05
                : widget.bodyHeight * .0485,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        CircleAvatar(
          backgroundColor: ColorManager.lowOpacityGrey,
          backgroundImage:
              profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
          child: profileImage.isEmpty
              ? Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: widget.bodyHeight * 0.07,
                )
              : null,
          radius: widget.bodyHeight * .046,
        ),
      ],
    );
  }

  AnimatedContainer colorfulContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 550),
      onEnd: () {
        setState(() {
          index = index + 1;
          bottomColor = colorList[index % colorList.length];
          topColor = colorList[(index + 1) % colorList.length];
        });
      },
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: begin, end: end, colors: [bottomColor, topColor])),
      child: CircleAvatar(
        radius: widget.bodyHeight < 900
            ? widget.bodyHeight * .0525
            : widget.bodyHeight * .0505,
        backgroundColor: ColorManager.transparent,
      ),
    );
  }

  Container rotationContainer() {
    return Container(
      alignment: Alignment.center,
      child: RotationTransition(
        turns: base as Animation<double>,
        child: DashedCircle(
          gapSize: gap.value,
          dashes: 40,
          color: ColorManager.red,
          child: RotationTransition(
            turns: reverse as Animation<double>,
            child: CircleAvatar(
              radius: widget.bodyHeight * .0510,
              backgroundColor: ColorManager.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

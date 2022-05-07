import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/utility/injector.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instegram/presentation/widgets/custom_circular_progress.dart';
import 'package:instegram/presentation/widgets/stroy_page.dart';
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

class _CircleAvatarOfProfileImageState
    extends State<CircleAvatarOfProfileImage> {
  final SharedPreferences _sharePrefs = injector<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    String profileImage = widget.userInfo.profileImageUrl;

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
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorManager.blackRed,
                    ColorManager.redAccent,
                    ColorManager.yellow,
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: widget.bodyHeight < 900
                    ? widget.bodyHeight * .0525
                    : widget.bodyHeight * .0505,
                backgroundColor: ColorManager.transparent,
              ),
            ),
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
}

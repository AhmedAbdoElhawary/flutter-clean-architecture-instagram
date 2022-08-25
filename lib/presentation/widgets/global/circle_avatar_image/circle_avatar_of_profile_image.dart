import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/pages/story/story_for_web.dart';
import 'package:instagram/presentation/pages/story/story_page_for_mobile.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'circle_avatar_name.dart';

class CircleAvatarOfProfileImage extends StatefulWidget {
  final double bodyHeight;
  final bool thisForStoriesLine;
  final UserPersonalInfo userInfo;
  final String nameOfCircle;
  final String hashTag;
  final bool moveTextMore;
  final bool showColorfulCircle;

  const CircleAvatarOfProfileImage({
    this.hashTag = "",
    this.nameOfCircle = "",
    required this.userInfo,
    required this.bodyHeight,
    this.moveTextMore = false,
    this.thisForStoriesLine = false,
    this.showColorfulCircle = true,
    Key? key,
  }) : super(key: key);

  @override
  State<CircleAvatarOfProfileImage> createState() =>
      _CircleAvatarOfProfileImageState();
}

class _CircleAvatarOfProfileImageState extends State<CircleAvatarOfProfileImage>
    with SingleTickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    if (widget.userInfo.profileImageUrl.isNotEmpty) {
      precacheImage(NetworkImage(widget.userInfo.profileImageUrl), context);
    }

    super.didChangeDependencies();
  }

  final SharedPreferences _sharePrefs = injector<SharedPreferences>();
  Color topColor = ColorManager.purple;
  Color middleColor = ColorManager.red;

  Color bottomColor = ColorManager.lightYellow;

  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    String profileImage = widget.userInfo.profileImageUrl;
    return SizedBox(
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
    if (!widget.showColorfulCircle) {
      await pushToPage(context,
          page: WhichProfilePage(userId: widget.userInfo.userId));
    } else {
      if (widget.userInfo.stories.isNotEmpty) {
        Widget page = BlocBuilder<StoryCubit, StoryState>(
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
              if (isThatMobile) {
                return StoryPageForMobile(
                    user: state.userInfo,
                    hashTag: "${widget.hashTag} for mobile",
                    storiesOwnersInfo: [state.userInfo]);
              } else {
                return StoryPageForWeb(
                    user: state.userInfo,
                    hashTag: "${widget.hashTag} for web",
                    storiesOwnersInfo: [state.userInfo]);
              }
            } else {
              return Scaffold(
                  body: Center(
                child: CustomCircularProgress(Theme.of(context).focusColor),
              ));
            }
          },
        );
        pushToPage(context, page: page);
        setState(() {});
      }
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
    bool isStorySeen = _sharePrefs.getBool(widget.userInfo.userId) == true;
    bool hasStory = widget.userInfo.stories.isNotEmpty;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.showColorfulCircle && hasStory) ...[
          isStorySeen ? unColorfulContainer() : colorfulContainer(),
          customSpacer()
        ],
        imageOfUser(profileImage)
      ],
    );
  }

  CircleAvatar unColorfulContainer() {
    return CircleAvatar(
      radius: widget.bodyHeight < 900
          ? widget.bodyHeight * .052
          : widget.bodyHeight * .0505,
      backgroundColor: ColorManager.lowOpacityGrey,
    );
  }

  CircleAvatar customSpacer() {
    return CircleAvatar(
      radius: widget.bodyHeight < 900
          ? widget.bodyHeight * .05
          : widget.bodyHeight * .0485,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget imageOfUser(String profileImage) {
    return CircleAvatar(
      backgroundColor: ColorManager.customGrey,
      backgroundImage: profileImage.isNotEmpty
          ? CachedNetworkImageProvider(profileImage,
              maxWidth: 165, maxHeight: 165)
          : null,
      radius: widget.bodyHeight * .046,
      child: profileImage.isEmpty
          ? Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
              size: widget.bodyHeight * 0.07,
            )
          : null,
    );
  }

  Container colorfulContainer() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [bottomColor, middleColor, topColor])),
      child: CircleAvatar(
        radius: widget.bodyHeight < 900
            ? widget.bodyHeight * .0525
            : widget.bodyHeight * .0505,
        backgroundColor: ColorManager.transparent,
      ),
    );
  }
}

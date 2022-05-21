import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/video/play_this_video.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/image_slider.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/points_scroll_bar.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_name.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_image_display.dart';

class UpdatePostInfo extends StatefulWidget {
  final Post oldPostInfo;
  const UpdatePostInfo({
    required this.oldPostInfo,
    Key? key,
  }) : super(key: key);

  @override
  State<UpdatePostInfo> createState() => _UpdatePostInfoState();
}

class _UpdatePostInfoState extends State<UpdatePostInfo> {
  TextEditingController controller = TextEditingController();
  bool moveAway = false;
  int initPosition = 0;

  @override
  void initState() {
    controller = TextEditingController(text: widget.oldPostInfo.caption);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).focusColor),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: SvgPicture.asset(
                IconsAssets.cancelIcon,
                color: Theme.of(context).focusColor,
                height: 27,
              )),
          title: Text(
            StringsManager.editInfo.tr(),
            style: getMediumStyle(
                color: Theme.of(context).focusColor, fontSize: 20),
          ),
          actions: [actionsWidgets()],
        ),
        body: buildSizedBox(bodyHeight, context));
  }

  Widget actionsWidgets() {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      if (state is CubitUpdatePostLoaded && moveAway) {
        moveAway = false;
        Navigator.maybePop(context);
      }
      return state is CubitUpdatePostLoading
          ? Transform.scale(
              scaleY: 1,
              scaleX: 1.2,
              child: const CustomCircularProgress(ColorManager.blue))
          : IconButton(
              onPressed: () async {
                Post updatedPostInfo = widget.oldPostInfo;
                updatedPostInfo.caption = controller.text;
                await PostCubit.get(context)
                    .updatePostInfo(postInfo: updatedPostInfo);
                setState(() {
                  moveAway = true;
                });
              },
              icon: const Icon(
                Icons.check_rounded,
                size: 30,
                color: ColorManager.blue,
              ));
    });
  }

  SizedBox buildSizedBox(double bodyHeight, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatarOfProfileImage(
                      bodyHeight: bodyHeight * .5,
                      userInfo: widget.oldPostInfo.publisherInfo!,
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                        onTap: () => pushToProfilePage(widget.oldPostInfo),
                        child: NameOfCircleAvatar(
                            widget.oldPostInfo.publisherInfo!.name, false)),
                  ],
                ),
              ),
              imageOfPost(widget.oldPostInfo, bodyHeight),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12),
                child: TextFormField(
                  controller: controller,
                  cursorColor: ColorManager.teal,
                  style: getNormalStyle(
                      color: Theme.of(context).focusColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: StringsManager.writeACaption.tr(),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorManager.blue),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorManager.blue),
                    ),
                    hintStyle: TextStyle(
                        color: Theme.of(context).bottomAppBarColor),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  pushToProfilePage(Post postInfo) =>
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => WhichProfilePage(userId: postInfo.publisherId),
      ));

  void _updateImageIndex(int index, _) {
    setState(() => initPosition = index);
  }

  Widget imageOfPost(Post postInfo, double bodyHeight) {
    String postUrl =
        postInfo.postUrl.isNotEmpty ? postInfo.postUrl : postInfo.imagesUrls[0];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 8.0),
            child: postInfo.isThatImage
                ? (postInfo.imagesUrls.length > 1
                    ? ImageSlider(
                        imagesUrls: postInfo.imagesUrls,
                        updateImageIndex: _updateImageIndex,
                      )
                    : Hero(
                        tag: postUrl,
                        child: ImageDisplay(
                          aspectRatio: 0,
                          bodyHeight: bodyHeight,
                          imageUrl: postUrl,
                        ),
                      ))
                : PlayThisVideo(videoUrl: postInfo.postUrl, play: false),
          ),
        ),
        PointsScrollBar(
          photoCount: postInfo.imagesUrls.length,
          activePhotoIndex: initPosition,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/profile/widgets/which_profile_page.dart';
import 'package:instagram/presentation/pages/time_line/widgets/image_slider.dart';
import 'package:instagram/presentation/pages/time_line/widgets/points_scroll_bar.dart';
import 'package:instagram/presentation/widgets/global/others/play_this_video.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_name.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';

class UpdatePostInfo extends StatefulWidget {
  final Post oldPostInfo;

  const UpdatePostInfo({required this.oldPostInfo, Key? key}) : super(key: key);

  @override
  State<UpdatePostInfo> createState() => _UpdatePostInfoState();
}

class _UpdatePostInfoState extends State<UpdatePostInfo> {
  TextEditingController controller = TextEditingController();
  ValueNotifier<int> initPosition = ValueNotifier(0);

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
        appBar: isThatMobile ? buildAppBar(context) : null,
        body: buildSizedBox(bodyHeight, context));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: SvgPicture.asset(
            IconsAssets.cancelIcon,
            colorFilter: ColorFilter.mode(
                Theme.of(context).focusColor, BlendMode.srcIn),
            height: 27,
          )),
      title: Text(
        StringsManager.editInfo.tr,
        style:
            getMediumStyle(color: Theme.of(context).focusColor, fontSize: 20),
      ),
      actions: [actionsWidgets()],
    );
  }

  Widget actionsWidgets() {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
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
                    .updatePostInfo(postInfo: updatedPostInfo)
                    .then((value) {
                  Navigator.maybePop(context);
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
              ...imageOfPost(widget.oldPostInfo, bodyHeight),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12),
                child: TextFormField(
                  controller: controller,
                  cursorColor: ColorManager.teal,
                  style: getNormalStyle(
                      color: Theme.of(context).focusColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: StringsManager.writeACaption.tr,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorManager.blue),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorManager.blue),
                    ),
                    hintStyle:
                        TextStyle(color: Theme.of(context).bottomAppBarTheme.color!),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  pushToProfilePage(Post postInfo) => Go(context).push(
      page: WhichProfilePage(userId: postInfo.publisherId), withoutRoot: false);

  void _updateImageIndex(int index, _) {
    initPosition.value = index;
  }

  List<Widget> imageOfPost(Post postInfo, double bodyHeight) {
    String postUrl =
        postInfo.postUrl.isNotEmpty ? postInfo.postUrl : postInfo.imagesUrls[0];
    bool isThatImage = postInfo.isThatImage;
    return [
      GestureDetector(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 8.0),
          child: postInfo.imagesUrls.length > 1
              ? ImagesSlider(
                  aspectRatio: postInfo.aspectRatio,
                  blurHash: postInfo.blurHash,
                  imagesUrls: postInfo.imagesUrls,
                  updateImageIndex: _updateImageIndex,
                )
              : (isThatImage
                  ? Hero(
                      tag: postUrl,
                      child: NetworkDisplay(
                        blurHash: postInfo.blurHash,
                        isThatImage: isThatImage,
                        url: postUrl,
                      ),
                    )
                  : PlayThisVideo(
                      videoUrl: postInfo.postUrl,
                      blurHash: postInfo.blurHash,
                      play: true,
                    )),
        ),
      ),
      if (postInfo.imagesUrls.length > 1)
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: initPosition,
                builder: (BuildContext context, int value, Widget? child) =>
                    PointsScrollBar(
                  photoCount: postInfo.imagesUrls.length,
                  activePhotoIndex: value,
                ),
              ),
            ],
          ),
        ),
    ];
  }
}

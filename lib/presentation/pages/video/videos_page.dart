import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/image_picker.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/cubit/follow/follow_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/comments/comments_for_mobile.dart';
import 'package:instagram/presentation/pages/profile/users_who_likes_for_mobile.dart';
import 'package:instagram/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:instagram/presentation/widgets/belong_to/videos_w/reel_video_play.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utility/constant.dart';

class VideosPage extends StatefulWidget {
  final ValueNotifier<bool> stopVideo;

  const VideosPage({Key? key, required this.stopVideo}) : super(key: key);

  @override
  VideosPageState createState() => VideosPageState();
}

class VideosPageState extends State<VideosPage> {
  ValueNotifier<Uint8List?> videoFile = ValueNotifier(null);
  ValueNotifier<bool> rebuildUserInfo = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: ValueListenableBuilder(
          valueListenable: rebuildUserInfo,
          builder: (context, bool rebuildValue, child) =>
              BlocBuilder<PostCubit, PostState>(
                bloc: BlocProvider.of<PostCubit>(context)..getAllPostInfo(),
                buildWhen: (previous, current) {
                  if (previous != current && current is CubitAllPostsLoaded) {
                    return true;
                  }
                  if (rebuildValue && current is CubitAllPostsLoaded) {
                    rebuildUserInfo.value = false;
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is CubitAllPostsLoaded) {
                    return Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: isThatMobile ? appBar() : null,
                      body: buildBody(state.allPostInfo),
                    );
                  } else if (state is CubitPostFailed) {
                    ToastShow.toastStateError(state);
                    return Center(
                        child: Text(
                      StringsManager.noVideos.tr(),
                      style: TextStyle(
                          color: Theme.of(context).focusColor, fontSize: 20),
                    ));
                  } else {
                    return loadingWidget();
                  }
                },
              )),
    );
  }

  AppBar appBar() =>
      AppBar(backgroundColor: ColorManager.transparent, actions: [
        IconButton(
          onPressed: () async {
            Uint8List? pickVideo = await videoCameraPicker();
            if (pickVideo == null) {
              ToastShow.toast(StringsManager.noImageSelected.tr());
            }
          },
          icon:
              const Icon(Icons.camera_alt, size: 30, color: ColorManager.white),
        )
      ]);
  Widget loadingWidget() {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[500]!,
          highlightColor: ColorManager.shimmerDarkGrey,
          child: Container(
            width: double.infinity,
            height: double.maxFinite,
            color: ColorManager.lightDarkGray,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: ColorManager.shimmerDarkGrey,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                end: 25.0, bottom: 20, start: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorManager.darkGray,
                ),
                const SizedBox(height: 5),
                Container(height: 15, width: 150, color: ColorManager.darkGray),
                const SizedBox(height: 5),
                Container(height: 15, width: 200, color: ColorManager.darkGray),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody(List<Post> postsInfo) {
    List<Post> videosPostsInfo =
        postsInfo.where((element) => element.isThatImage == false).toList();
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videosPostsInfo.length,
      itemBuilder: (context, index) {
        ValueNotifier<Post> videoInfo = ValueNotifier(videosPostsInfo[index]);
        return Stack(children: [
          SizedBox(
              height: double.infinity,
              child: ValueListenableBuilder(
                valueListenable: widget.stopVideo,
                builder: (context, bool stopVideoValue, child) => ReelVideoPlay(
                  videoInfo: videoInfo,
                  stopVideo: stopVideoValue,
                ),
              )),
          _HorizontalButtons(videoInfo: videoInfo, stopVideo: widget.stopVideo),
          _VerticalButtons(videoInfo: videoInfo, stopVideo: widget.stopVideo),
        ]);
      },
    );
  }
}

class _VerticalButtons extends StatefulWidget {
  final ValueNotifier<Post> videoInfo;
  final ValueNotifier<bool> stopVideo;

  const _VerticalButtons(
      {Key? key, required this.videoInfo, required this.stopVideo})
      : super(key: key);

  @override
  State<_VerticalButtons> createState() => _VerticalButtonsState();
}

class _VerticalButtonsState extends State<_VerticalButtons> {
  ValueNotifier<bool?> isFollowed = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return verticalWidgets();
  }

  Widget verticalWidgets() {
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(end: 25.0, bottom: 20, start: 15),
      child: ValueListenableBuilder(
        valueListenable: widget.videoInfo,
        builder: (context, Post videoInfoValue, child) {
          UserPersonalInfo? personalInfo = videoInfoValue.publisherInfo;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => goToUserProfile(personalInfo!),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: ColorManager.white,
                          backgroundImage:
                              NetworkImage(personalInfo!.profileImageUrl),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () => goToUserProfile(personalInfo),
                          child: Text(
                            personalInfo.name,
                            style: const TextStyle(color: ColorManager.white),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      if (videoInfoValue.publisherId != myPersonalId)
                        followButton(personalInfo),
                    ],
                  )),
              const SizedBox(height: 10),
              Text(videoInfoValue.caption,
                  style: getNormalStyle(
                    color: ColorManager.white,
                  )),
            ],
          );
        },
      ),
    );
  }

  goToUserProfile(UserPersonalInfo personalInfo) async {
    await pushToPage(context, page: WhichProfilePage(
        userId: personalInfo.userId, userName: personalInfo.userName),withoutRoot: false);
    widget.stopVideo.value = false;
  }

  Widget followButton(UserPersonalInfo personalInfo) {
    return ValueListenableBuilder(
      valueListenable: isFollowed,
      builder: (context, bool? isFollowedValue, child) => GestureDetector(
          onTap: () {
            if (personalInfo.followerPeople.contains(myPersonalId) ||
                isFollowedValue == null ||
                isFollowedValue == true) {
              BlocProvider.of<FollowCubit>(context).unFollowThisUser(
                  followingUserId: personalInfo.userId,
                  myPersonalId: myPersonalId);
              isFollowed.value = false;
            } else {
              BlocProvider.of<FollowCubit>(context).followThisUser(
                  followingUserId: personalInfo.userId,
                  myPersonalId: myPersonalId);
              isFollowed.value = true;
            }
          },
          child: followText(personalInfo)),
    );
  }

  Container followText(UserPersonalInfo personalInfo) {
    return Container(
        padding: const EdgeInsetsDirectional.only(
            start: 5, end: 5, bottom: 2, top: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: ColorManager.white, width: 1)),
        child: ValueListenableBuilder(
          valueListenable: isFollowed,
          builder: (context, bool? isFollowedValue, child) => Text(
            (isFollowedValue == null &&
                        personalInfo.followerPeople.contains(myPersonalId)) ||
                    (isFollowedValue != null && isFollowedValue)
                ? StringsManager.following.tr()
                : StringsManager.follow.tr(),
            style: const TextStyle(color: ColorManager.white),
          ),
        ));
  }
}

class _HorizontalButtons extends StatefulWidget {
  final ValueNotifier<Post> videoInfo;
  final ValueNotifier<bool> stopVideo;

  const _HorizontalButtons(
      {Key? key, required this.videoInfo, required this.stopVideo})
      : super(key: key);

  @override
  State<_HorizontalButtons> createState() => _HorizontalButtonsState();
}

class _HorizontalButtonsState extends State<_HorizontalButtons> {
  @override
  Widget build(BuildContext context) {
    return horizontalWidgets();
  }

  Padding horizontalWidgets() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 15.0, bottom: 8),
      child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: ValueListenableBuilder(
            valueListenable: widget.videoInfo,
            builder: (context, Post videoInfoValue, child) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                loveButton(videoInfoValue),
                buildSizedBox(),
                numberOfLikes(videoInfoValue),
                commentButton(videoInfoValue),
                buildSizedBox(),
                numberOfComment(videoInfoValue),
                GestureDetector(
                  child: SvgPicture.asset(
                    IconsAssets.send1Icon,
                    color: ColorManager.white,
                    height: 25,
                  ),
                ),
                sizedBox(),
                GestureDetector(
                  child: SvgPicture.asset(
                    IconsAssets.menuHorizontalIcon,
                    color: ColorManager.white,
                    height: 25,
                  ),
                ),
                sizedBox(),
              ],
            ),
          )),
    );
  }

  Widget numberOfComment(Post videoInfoValue) {
    return InkWell(
      onTap: () async => goToCommentPage(videoInfoValue),
      child: SizedBox(
        width: 30,
        height: 40,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "${videoInfoValue.comments.length}",
            style: const TextStyle(color: ColorManager.white),
          ),
        ),
      ),
    );
  }

  goToCommentPage(Post videoInfo) async {
    await pushToPage(context, page:  CommentsPageForMobile(postInfo: videoInfo));
    widget.stopVideo.value = false;
  }

  GestureDetector commentButton(Post videoInfo) {
    return GestureDetector(
      onTap: () async => goToCommentPage(videoInfo),
      child: SvgPicture.asset(
        IconsAssets.commentIcon,
        color: ColorManager.white,
        height: 35,
      ),
    );
  }

  Widget numberOfLikes(Post videoInfo) {
    return InkWell(
      onTap: () async {
        await pushToPage(context, page: UsersWhoLikesForMobile(
          showSearchBar: true,
          usersIds: videoInfo.likes,
          isThatMyPersonalId: videoInfo.publisherId == myPersonalId,
        ),withoutRoot: false);

        widget.stopVideo.value = false;
      },
      child: SizedBox(
        width: 30,
        height: 40,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "${videoInfo.likes.length}",
            style: const TextStyle(color: ColorManager.white),
          ),
        ),
      ),
    );
  }

  Widget loveButton(Post videoInfo) {
    bool isLiked = videoInfo.likes.contains(myPersonalId);
    return Builder(builder: (context) {
      PostLikesCubit likeCubit = BlocProvider.of<PostLikesCubit>(context);
      return GestureDetector(
        child: !isLiked
            ? const Icon(
                Icons.favorite_border,
                color: ColorManager.white,
                size: 32,
              )
            : const Icon(
                Icons.favorite,
                color: ColorManager.red,
                size: 32,
              ),
        onTap: () {
          setState(() {
            if (isLiked) {
              likeCubit.removeTheLikeOnThisPost(
                  postId: videoInfo.postUid, userId: myPersonalId);
              videoInfo.likes.remove(myPersonalId);
            } else {
              likeCubit.putLikeOnThisPost(
                  postId: videoInfo.postUid, userId: myPersonalId);
              videoInfo.likes.add(myPersonalId);
            }
          });
        },
      );
    });
  }

  SizedBox buildSizedBox() {
    return const SizedBox(
      height: 5,
    );
  }

  SizedBox sizedBox() {
    return const SizedBox(
      height: 25,
    );
  }
}

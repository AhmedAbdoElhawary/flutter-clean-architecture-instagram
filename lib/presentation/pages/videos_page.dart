import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/followCubit/follow_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/pages/comments_page.dart';
import 'package:instegram/presentation/pages/show_me_who_are_like.dart';
import 'package:instegram/presentation/pages/which_profile_page.dart';
import 'package:instegram/presentation/widgets/fade_in_image.dart';
import 'package:instegram/presentation/widgets/reel_video_play.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

import '../../core/utility/constant.dart';

class VideosPage extends StatefulWidget {
  final ValueNotifier<bool> stopVideo;

  const VideosPage({Key? key, required this.stopVideo}) : super(key: key);

  @override
  VideosPageState createState() => VideosPageState();
}

class VideosPageState extends State<VideosPage> {
  File? videoFile;
  bool rebuildUserInfo = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      bloc: BlocProvider.of<PostCubit>(context)..getAllPostInfo(),
      buildWhen: (previous, current) {
        if (previous != current && current is CubitAllPostsLoaded) {
          return true;
        }
        if (rebuildUserInfo && current is CubitAllPostsLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CubitAllPostsLoaded) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: appBar(),
            body: buildBody(state.allPostInfo),
          );
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return Center(
              child: Text(
            StringsManager.noPosts.tr(),
            style: const TextStyle(color: ColorManager.black, fontSize: 20),
          ));
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: ColorManager.black54),
          );
        }
      },
    );
  }

  Widget buildBody(List<Post> postsInfo) {
    List<Post> videosPostsInfo =
        postsInfo.where((element) => element.isThatImage == false).toList();
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videosPostsInfo.length,
      itemBuilder: (context, index) {
        ValueNotifier<Post> videoInfo=ValueNotifier(videosPostsInfo[index]);
        return Stack(children: [
          SizedBox(
              height: double.infinity,
              child: ReelVideoPlay(
                videoInfo: videoInfo,
                stopVideo: widget.stopVideo,
              )),
          horizontalWidgets(videoInfo),
          verticalWidgets(videoInfo.value),
        ]);
      },
    );
  }

  AppBar appBar() => AppBar(backgroundColor: Colors.transparent, actions: [
        IconButton(
          onPressed: () async {
            final ImagePicker _picker = ImagePicker();
            final XFile? pickedFile =
                await _picker.pickVideo(source: ImageSource.camera);
            if (pickedFile != null) {
              setState(() {
                videoFile = File(pickedFile.path);
              });
            } else {
              ToastShow.toast(StringsManager.noImageSelected.tr());
            }
          },
          icon: const Icon(Icons.camera_alt, size: 30, color: Colors.white),
        )
      ]);

  Widget verticalWidgets(Post postInfo) {
    UserPersonalInfo? personalInfo = postInfo.publisherInfo;
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(end: 25.0, bottom: 20, start: 15),
      child: Column(
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
                      backgroundColor: Colors.white,
                      child: ClipOval(
                          child: CustomFadeInImage(
                              imageUrl: personalInfo!.profileImageUrl)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () => goToUserProfile(personalInfo),
                      child: Text(
                        personalInfo.name,
                        style: const TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  if (postInfo.publisherId != myPersonalId)
                    followButton(personalInfo),
                ],
              )),
          const SizedBox(height: 10),
          Text(postInfo.caption,
              style: getNormalStyle(
                color: ColorManager.white,
              )),
        ],
      ),
    );
  }

  goToUserProfile(UserPersonalInfo personalInfo) => Navigator.of(
        context,
      ).push(CupertinoPageRoute(
        builder: (context) => WhichProfilePage(
            userId: personalInfo.userId, userName: personalInfo.userName),
      ));

  GestureDetector followButton(UserPersonalInfo personalInfo) {
    return GestureDetector(
        onTap: () {
          setState(() {
            rebuildUserInfo = false;
          });
          if (personalInfo.followerPeople.contains(myPersonalId)) {
            BlocProvider.of<FollowCubit>(context).removeThisFollower(
                followingUserId: personalInfo.userId,
                myPersonalId: myPersonalId);
          } else {
            BlocProvider.of<FollowCubit>(context).followThisUser(
                followingUserId: personalInfo.userId,
                myPersonalId: myPersonalId);
          }

          setState(() {
            rebuildUserInfo = true;
          });
        },
        child: followText(personalInfo));
  }

  Container followText(UserPersonalInfo personalInfo) {
    return Container(
        padding: const EdgeInsetsDirectional.only(
            start: 5, end: 5, bottom: 2, top: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white, width: 1)),
        child: Text(
          personalInfo.followedPeople.contains(myPersonalId)
              ? StringsManager.following.tr()
              : StringsManager.follow.tr(),
          style: const TextStyle(color: Colors.white),
        ));
  }

  Padding horizontalWidgets(ValueNotifier<Post> postInfo) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 15.0, bottom: 8),
      child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              loveButton(postInfo),
              buildSizedBox(),
              numberOfLikes(postInfo),
              sizedBox(),
              commentButton(postInfo.value),
              buildSizedBox(),
              Text(
                "${postInfo.value.comments.length}",
                style: const TextStyle(color: Colors.white),
              ),
              sizedBox(),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  IconsAssets.send1Icon,
                  color: Colors.white,
                  height: 25,
                ),
              ),
              sizedBox(),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  IconsAssets.menuHorizontalIcon,
                  color: Colors.white,
                  height: 25,
                ),
              ),
              sizedBox(),
            ],
          )),
    );
  }

  GestureDetector commentButton(Post postInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(
          builder: (context) => CommentsPage(postId: postInfo.postUid),
        ));
      },
      child: SvgPicture.asset(
        IconsAssets.commentIcon,
        color: Colors.white,
        height: 35,
      ),
    );
  }

  Widget numberOfLikes(ValueNotifier<Post> postInfo) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => UsersWhoLikesOnPostPage(
                  showSearchBar: true,
                  usersIds: postInfo.value.likes,
                )));
      },
      child: Text(
        "${postInfo.value.likes.length}",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget loveButton(ValueNotifier<Post> postInfo) {
    bool isLiked = postInfo.value.likes.contains(myPersonalId);
    return Builder(
      builder: (context) {
        PostLikesCubit likeCubit=BlocProvider.of<PostLikesCubit>(context);
        return GestureDetector(
          child: !isLiked
              ? const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 32,
                )
              : const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 32,
                ),
          onTap: () {
            setState(() {
              if (isLiked) {
                likeCubit.removeTheLikeOnThisPost(
                    postId: postInfo.value.postUid, userId: myPersonalId);
                postInfo.value.likes.remove(myPersonalId);
              } else {
                likeCubit.putLikeOnThisPost(
                    postId: postInfo.value.postUid, userId: myPersonalId);
                postInfo.value.likes.add(myPersonalId);
              }
            });
          },
        );
      }
    );
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

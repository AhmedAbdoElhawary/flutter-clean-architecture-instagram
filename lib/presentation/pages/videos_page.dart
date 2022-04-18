import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/pages/comments_page.dart';
import 'package:instegram/presentation/pages/show_me_who_are_like.dart';
import 'package:instegram/presentation/widgets/reel_video_play.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

import '../../core/constant.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);



  @override
  VideosPageState createState() => VideosPageState();
}

class VideosPageState extends State<VideosPage> {
  File? videoFile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      bloc: BlocProvider.of<PostCubit>(context)..getAllPostInfo(),
      buildWhen: (previous, current) {
        if (previous != current && current is CubitAllPostsLoaded) {
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
          return const Center(
              child: Text(
            "There's no posts...",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ));
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: Colors.black54),
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
        return Stack(children: [
          SizedBox(
              height: double.infinity,
              child: ReelVideoPlay(videoUrl: videosPostsInfo[index].postUrl)),
          horizontalWidgets(videosPostsInfo[index]),
          verticalWidgets(videosPostsInfo[index]),
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
              ToastShow.toast('No image selected.');
            }
          },
          icon: const Icon(Icons.camera_alt, size: 30, color: Colors.white),
        )
      ]);

  Padding verticalWidgets(Post postInfo) {
    UserPersonalInfo? personalInfo = postInfo.publisherInfo;
    return Padding(
      padding: const EdgeInsets.only(right: 25.0, bottom: 25, left: 15),
      child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: ClipOval(child: Image.network(personalInfo!.profileImageUrl)),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {},
                  child: Text(
                    personalInfo.name,
                    style: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Text(
                        personalInfo.followedPeople.contains(myPersonalId)
                            ? "Following"
                            : "Follow",
                        style: const TextStyle(color: Colors.white),
                      ))),
            ],
          )),
    );
  }

  Padding horizontalWidgets(Post postInfo) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, bottom: 8),
      child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              loveButton(postInfo),
              buildSizedBox(),
              numberOfLikes(postInfo),
              sizedBox(),
              commentButton(postInfo),
              buildSizedBox(),
              Text(
                "${postInfo.comments.length}",
                style: const TextStyle(color: Colors.white),
              ),
              sizedBox(),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  "assets/icons/send.svg",
                  color: Colors.white,
                  height: 25,
                ),
              ),
              sizedBox(),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  "assets/icons/menu_horizontal.svg",
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
        "assets/icons/comment.svg",
        color: Colors.white,
        height: 35,
      ),
    );
  }

  Widget numberOfLikes(Post postInfo) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UsersWhoLikesOnPostPage(
                  showSearchBar: true,
                  usersIds: postInfo.likes,
                )));
      },
      child: Text(
        "${postInfo.likes.length}",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget loveButton(Post postInfo) {
    bool isLiked = postInfo.likes.contains(myPersonalId);
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
            ),
      onTap: () {
        setState(() {
          if (isLiked) {
            BlocProvider.of<PostLikesCubit>(context).removeTheLikeOnThisPost(
                postId: postInfo.postUid, userId: myPersonalId);
            postInfo.likes.remove(myPersonalId);
          } else {
            BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                postId: postInfo.postUid, userId: myPersonalId);
            postInfo.likes.add(myPersonalId);
          }
        });
      },
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

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/image_picker.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:instagram/presentation/pages/story_config.dart';
import 'package:instagram/presentation/widgets/add_comment.dart';
import 'package:instagram/presentation/widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/custom_circular_progress.dart';
import 'package:instagram/presentation/widgets/gradient_icon.dart';
import 'package:instagram/presentation/widgets/post_list_view.dart';
import 'package:instagram/presentation/widgets/smart_refresher.dart';
import 'package:instagram/presentation/widgets/stroy_page.dart';
import 'package:instagram/presentation/widgets/toast_show.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../widgets/circle_avatar_of_profile_image.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final ValueNotifier<FocusNode> _showCommentBox = ValueNotifier(FocusNode());
  final TextEditingController _textController = TextEditingController();
  ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  ScrollController scrollController = ScrollController();

  UserPersonalInfo? personalInfo;
  bool loadingPosts = true;
  ValueNotifier<bool> reLoadData = ValueNotifier(false);
  Post? selectedPostInfo;
  int? centerItemIndex;
  bool rebuild = true;
  List postsIds = [];
  ValueNotifier<List<Post>> postsInfo = ValueNotifier([]);

  Future<void> getData(int index) async {
    reLoadData.value = false;
    FirestoreUserInfoCubit userCubit =
        BlocProvider.of<FirestoreUserInfoCubit>(context, listen: false);
    await userCubit.getUserInfo(widget.userId);
    personalInfo = userCubit.myPersonalInfo;

    List usersIds = personalInfo!.followedPeople + personalInfo!.followerPeople;

    SpecificUsersPostsCubit usersPostsCubit =
        BlocProvider.of<SpecificUsersPostsCubit>(context, listen: false);

    await usersPostsCubit.getSpecificUsersPostsInfo(usersIds: usersIds);

    List usersPostsIds = usersPostsCubit.usersPostsInfo;

    postsIds = usersPostsIds + personalInfo!.posts;

    // if (index == 0) postsIds.shuffle();

    PostCubit postCubit = PostCubit.get(context);
    await postCubit
        .getPostsInfo(
            postsIds: postsIds,
            isThatForMyPosts: true,
            lengthOfCurrentList: index)
        .then((value) {
      Future.delayed(Duration.zero, () {
        setState(() {});
      });
      reLoadData.value = true;
    });
  }
  //
  // @override
  // void dispose() {
  //   _showCommentBox.value.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    centerItemIndex ??= ((bodyHeight / 2) / bodyHeight).floor();
    if (rebuild) {
      getData(0);
      rebuild = false;
    }
    return Scaffold(
      appBar: CustomAppBar.basicAppBar(context),
      body: SmarterRefresh(
        onRefreshData: getData,
        postsIds: postsIds,
        isThatEndOfList: isThatEndOfList,
        child: blocBuilder(bodyHeight),
      ),
      bottomSheet: addComment(),
    );
  }

  Widget? addComment() {
    return selectedPostInfo != null
        ? AddComment(
            // showCommentBox: _showCommentBox,
            postsInfo: selectedPostInfo!,
            textController: _textController,
          )
        : null;
  }

  BlocBuilder<PostCubit, PostState> blocBuilder(double bodyHeight) {
    return BlocBuilder<PostCubit, PostState>(
      buildWhen: (previous, current) {
        if (reLoadData.value && current is CubitMyPersonalPostsLoaded) {
          reLoadData.value = false;
          return true;
        }
        if (reLoadData.value) {
          reLoadData.value = false;
          return true;
        }

        if (previous != current && current is CubitMyPersonalPostsLoaded) {
          return true;
        }
        if (previous != current && current is CubitPostFailed) {
          return true;
        }
        return false;
      },
      builder: (BuildContext context, PostState state) {
        if (state is CubitMyPersonalPostsLoaded) {
          postsInfo.value = state.postsInfo;
          return postsInfo.value.isNotEmpty
              ? inView(bodyHeight)
              : emptyMassage();
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return Center(
              child: Text(
            StringsManager.noPosts.tr(),
            style: getNormalStyle(color: Theme.of(context).focusColor),
          ));
        } else {
          return circularProgress();
        }
      },
    );
  }

  Widget inView(double bodyHeight) {
    return SingleChildScrollView(
      child: NotificationListener(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          controller: scrollController,
          itemCount: postsInfo.value.length,
          itemBuilder: (ctx, index) {
            return columnOfWidgets(bodyHeight, index, index == centerItemIndex);
          },
        ),
        onNotification: (_) {
          int calculatedIndex =
              ((scrollController.position.pixels + bodyHeight / 2) / bodyHeight)
                  .floor();
          if (calculatedIndex != centerItemIndex) {
            setState(() {
              centerItemIndex = calculatedIndex;
            });
          }
          return true;
        },
      ),
    );
  }

  Widget columnOfWidgets(double bodyHeight, int index, bool playTheVideo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (index == 0) ...[
          storiesLines(bodyHeight),
          customDivider(),
        ] else ...[
          Divider(
              color: Theme.of(context).toggleableActiveColor, thickness: .15),
        ],
        posts(index, bodyHeight, playTheVideo),
        if (isThatEndOfList.value && index == postsIds.length - 1) ...[
          Divider(
              color: Theme.of(context).toggleableActiveColor, thickness: .15),
          const GradientIcon(),
        ]
      ],
    );
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: ColorManager.grey,
      width: double.infinity,
      height: 0.3);

  // selectPost(Post selectedPost) {
  //   setState(() {
  //     // _showCommentBox.value.requestFocus();
  //     selectedPostInfo = selectedPost;
  //   });
  // }

  Widget posts(int index, double bodyHeight, bool playTheVideo) {
    return ImageList(
      postInfo: postsInfo.value[index],
      postsInfo: postsInfo,
      bodyHeight: bodyHeight,
      playTheVideo: playTheVideo,
      reLoadData: reloadTheData,
    );
  }

  reloadTheData() {
    setState(() {
      reLoadData.value = true;
    });
  }

  Widget circularProgress() {
    return const ThineCircularProgress();
  }

  Widget emptyMassage() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          StringsManager.noPosts,
          style: getNormalStyle(color: Theme.of(context).focusColor),
        ),
        Text(
          StringsManager.tryAddPost,
          style: getNormalStyle(color: Theme.of(context).focusColor),
        ),
      ],
    ));
  }

  createNewStory({bool isThatFromCamera = true}) async {
    File? pickImage = isThatFromCamera
        ? await imageCameraPicker()
        : await imageGalleryPicker();
    if (pickImage != null) {
      await Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => NewStoryPage(storyImage: pickImage),
          maintainState: false));
      setState(() {
        reLoadData.value = true;
      });
    }
  }

  Widget storiesLines(double bodyHeight) {
    List<dynamic> usersStoriesIds =
        personalInfo!.followedPeople + personalInfo!.followerPeople;
    return BlocBuilder<StoryCubit, StoryState>(
      bloc: StoryCubit.get(context)
        ..getStoriesInfo(
            usersIds: usersStoriesIds, myPersonalInfo: personalInfo!),
      buildWhen: (previous, current) {
        if (reLoadData.value && current is CubitStoriesInfoLoaded) {
          reLoadData.value = false;
          return true;
        }

        if (previous != current && current is CubitStoriesInfoLoaded) {
          return true;
        }
        if (previous != current && current is CubitStoryFailed) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CubitStoriesInfoLoaded) {
          List<UserPersonalInfo> storiesOwnersInfo = state.storiesOwnersInfo;
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 10),
            child: SizedBox(
              width: double.infinity,
              height: bodyHeight * 0.155,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (personalInfo!.stories.isEmpty) ...[
                      myOwnStory(context, storiesOwnersInfo, bodyHeight),
                      const SizedBox(width: 12),
                    ],
                    ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: storiesOwnersInfo.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (BuildContext context, int index) {
                        UserPersonalInfo publisherInfo =
                            storiesOwnersInfo[index];
                        return Hero(
                          tag: "${publisherInfo.userId.hashCode}",
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                maintainState: false,
                                builder: (context) => StoryPage(
                                    user: publisherInfo,
                                    hashTag: "${publisherInfo.userId.hashCode}",
                                    storiesOwnersInfo: storiesOwnersInfo),
                              ));
                            },
                            child: CircleAvatarOfProfileImage(
                              userInfo: publisherInfo,
                              bodyHeight: bodyHeight * 1.1,
                              thisForStoriesLine: true,
                              nameOfCircle: index == 0 &&
                                      publisherInfo.userId ==
                                          personalInfo!.userId
                                  ? StringsManager.yourStory.tr()
                                  : "",
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is CubitStoryFailed) {
          ToastShow.toastStateError(state);
          return Center(
              child: Text(
            StringsManager.somethingWrong.tr(),
            style: getNormalStyle(color: Theme.of(context).focusColor),
          ));
        } else {
          return Container();
        }
      },
    );
  }

  moveToStoryPage(
          List<UserPersonalInfo> storiesOwnersInfo, UserPersonalInfo user) =>
      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
        maintainState: false,
        builder: (context) =>
            StoryPage(user: user, storiesOwnersInfo: storiesOwnersInfo),
      ));

  Widget myOwnStory(BuildContext context,
      List<UserPersonalInfo> storiesOwnersInfo, double bodyHeight) {
    return GestureDetector(
      onTap: () async {
        showAnimatedDialog(
            context: context,
            curve: Curves.easeIn,
            builder: (context) => AlertDialog(
                  scrollable: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 5,
                  content: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await createNewStory();
                            await getData(0);
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              setState(() {});
                            });
                          },
                          child: Text(StringsManager.fromCamera.tr()),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () async {
                            await createNewStory(isThatFromCamera: false);
                            await getData(0);
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              setState(() {});
                            });
                          },
                          child: Text(StringsManager.fromGallery.tr()),
                        ),
                      ]),
                ));
      },
      child: Stack(
        children: [
          CircleAvatarOfProfileImage(
            userInfo: personalInfo!,
            bodyHeight: bodyHeight,
            moveTextMore: true,
            thisForStoriesLine: true,
            nameOfCircle: StringsManager.yourStory.tr(),
          ),
          Positioned(
              top: 40,
              left: 40,
              right: 5,
              child: CircleAvatar(
                  radius: 9.5,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: ColorManager.blue,
                      child: Icon(
                        Icons.add,
                        size: 15,
                      )))),
        ],
      ),
    );
  }
}

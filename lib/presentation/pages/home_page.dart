import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/cubit/StoryCubit/story_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:instegram/presentation/pages/story_config.dart';
import 'package:instegram/presentation/widgets/add_comment.dart';
import 'package:instegram/presentation/widgets/custom_app_bar.dart';
import 'package:instegram/presentation/widgets/custom_circular_progress.dart';
import 'package:instegram/presentation/widgets/post_list_view.dart';
import 'package:instegram/presentation/widgets/smart_refresher.dart';
import 'package:instegram/presentation/widgets/stroy_page.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
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
  bool rebuild = true;
  bool loadingPosts = true;
  bool reLoadData = false;
  UserPersonalInfo? personalInfo;
  final TextEditingController _textController = TextEditingController();
  Post? selectedPostInfo;
  bool isItMoved = false;
  ScrollController scrollController = ScrollController();
  int? centerItemIndex;
  final ValueNotifier<FocusNode> _showCommentBox = ValueNotifier(FocusNode());

  Future<void> getData() async {
    reLoadData = false;
    FirestoreUserInfoCubit userCubit =
        BlocProvider.of<FirestoreUserInfoCubit>(context, listen: false);
    await userCubit.getUserInfo(widget.userId, true);
    personalInfo = userCubit.myPersonalInfo;

    List usersIds = personalInfo!.followedPeople + personalInfo!.followerPeople;

    SpecificUsersPostsCubit usersPostsCubit =
        BlocProvider.of<SpecificUsersPostsCubit>(context, listen: false);

    await usersPostsCubit.getSpecificUsersPostsInfo(usersIds: usersIds);

    List usersPostsIds = usersPostsCubit.usersPostsInfo;

    List postsIds = usersPostsIds + personalInfo!.posts;

    PostCubit postCubit = PostCubit.get(context);
    await postCubit
        .getPostsInfo(postsIds: postsIds, isThatForMyPosts: true)
        .then((value) {
      Future.delayed(Duration.zero, () {
        setState(() {});
      });
      reLoadData = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _showCommentBox.value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    if (centerItemIndex == null) {
      centerItemIndex =
          ((bodyHeight / 2) / bodyHeight).floor();
      print('center item = $centerItemIndex');
    }
    if (rebuild) {
      getData();
      rebuild = false;
    }
    return Scaffold(
      appBar: customAppBar(context),
      body: SmarterRefresh(
        onRefreshData: getData,
        child: blocBuilder(bodyHeight),
      ),
      bottomSheet: addComment(),
    );
  }

  Widget? addComment() {
    return selectedPostInfo != null
        ? AddComment(
            showCommentBox: _showCommentBox,
            postsInfo: selectedPostInfo!,
            textController: _textController,
          )
        : null;
  }

  BlocBuilder<PostCubit, PostState> blocBuilder(double bodyHeight) {
    return BlocBuilder<PostCubit, PostState>(
      buildWhen: (previous, current) {
        if (reLoadData && current is CubitMyPersonalPostsLoaded) {
          reLoadData = false;
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
          return state.postsInfo.isNotEmpty
              ? inView(state, bodyHeight)
              : emptyMassage();
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return Center(child: Text(StringsManager.noPosts.tr(),style: getNormalStyle(color: Theme.of(context).focusColor),));
        } else {
          return circularProgress();
        }
      },
    );
  }
  //
  // Widget inViewNotifier(CubitMyPersonalPostsLoaded state, double bodyHeight) {
  //   ValueNotifier<bool> inView = ValueNotifier(false);
  //   return InViewNotifierList(
  //     initialInViewIds: const ['0'],
  //     // shrinkWrap: true,
  //     // primary: false,
  //     // physics: const NeverScrollableScrollPhysics(),
  //     isInViewPortCondition:
  //         (double deltaTop, double deltaBottom, double vpHeight) {
  //       return deltaTop < (0.5 * vpHeight) && deltaBottom > (0.5 * vpHeight);
  //     },
  //     itemCount: state.postsInfo.length,
  //     builder: (BuildContext context, int index) {
  //       return Container(
  //         width: double.infinity,
  //         margin: const EdgeInsetsDirectional.only(bottom: .5, top: .5),
  //         child: LayoutBuilder(
  //           builder: (BuildContext context, BoxConstraints constraints) {
  //             return InViewNotifierWidget(
  //               id: '$index',
  //               builder: (_, bool isInView, __) {
  //                 if (isInView) {}
  //                 Post postInfo = state.postsInfo[index];
  //                 return columnOfWidgets(bodyHeight, postInfo,index,isInView);
  //               },
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget inView(CubitMyPersonalPostsLoaded state, double bodyHeight) {
    return SingleChildScrollView(
      child: NotificationListener(
        child: ListView.builder(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: state.postsInfo.length,
          itemBuilder: (ctx, index) {
            return columnOfWidgets(bodyHeight, state.postsInfo[index], index,
                index == centerItemIndex);
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

  Widget columnOfWidgets(
      double bodyHeight, Post postInfo, int index, bool playTheVideo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (index == 0) ...[
          storiesLines(bodyHeight),
          customDivider(),
        ] else ...[
          const Divider(),
        ],
        posts(postInfo, bodyHeight, playTheVideo),
      ],
    );
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: ColorManager.grey,
      width: double.infinity,
      height: 0.3);

  selectPost(Post selectedPost) {
    setState(() {
      _showCommentBox.value.requestFocus();
      selectedPostInfo = selectedPost;
    });
  }

  Widget posts(Post postInfo, double bodyHeight, bool playTheVideo) {
    return ImageList(
      postInfo: postInfo,
      selectedPostInfo: selectPost,
      bodyHeight: bodyHeight,
      textController: _textController,
      playTheVideo: playTheVideo,
    );
  }

  Widget circularProgress() {
    return const ThineCircularProgress();
  }

  Widget emptyMassage() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(StringsManager.noPosts,style: getNormalStyle(color: Theme.of(context).focusColor),),
        Text(StringsManager.tryAddPost,style: getNormalStyle(color: Theme.of(context).focusColor),),
      ],
    ));
  }

  createNewStory() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File photo = File(image.path);
      await Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => NewStoryPage(storyImage: photo),
          maintainState: false));
      setState(() {
        reLoadData = true;
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
        if (reLoadData && current is CubitStoriesInfoLoaded) {
          reLoadData = false;
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
                    if (personalInfo!.stories.isEmpty)
                      myOwnStory(context, storiesOwnersInfo, bodyHeight),
                    ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: storiesOwnersInfo.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(width: 8),
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
                              nameOfCircle: index == 0
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
          return Center(child: Text(StringsManager.somethingWrong.tr(),style: getNormalStyle(color: Theme.of(context).focusColor),));
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

  Stack myOwnStory(BuildContext context,
      List<UserPersonalInfo> storiesOwnersInfo, double bodyHeight) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            await createNewStory();
            await getData();
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              setState(() {});
            });
          },
          child: CircleAvatarOfProfileImage(
            userInfo: personalInfo!,
            bodyHeight: bodyHeight,
            thisForStoriesLine: true,
            nameOfCircle: StringsManager.yourStory.tr(),
          ),
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
    );
  }
}

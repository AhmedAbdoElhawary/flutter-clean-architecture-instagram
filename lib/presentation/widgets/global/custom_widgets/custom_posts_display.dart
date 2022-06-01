import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_list.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/post_list_view.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/all_catch_up_icon.dart';

class CustomPostsDisplay extends StatefulWidget {
  final List<Post> postsInfo;
  final bool isThatProfile;
  const CustomPostsDisplay(
      {Key? key, required this.postsInfo, required this.isThatProfile})
      : super(key: key);

  @override
  State<CustomPostsDisplay> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CustomPostsDisplay> {
  ScrollController scrollController = ScrollController();
  int? centerItemIndex;
  ValueNotifier<List<Post>> postsInfo = ValueNotifier([]);
  ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  @override
  void initState() {
    if (widget.postsInfo.length > 5) {
      postsInfo.value = widget.postsInfo.sublist(0, 5);
    } else {
      postsInfo.value = widget.postsInfo;
      isThatEndOfList.value = true;
    }
    super.initState();
  }

  Future<void> getData(int index) async {
    if (widget.postsInfo.length > index + 5) {
      postsInfo.value += widget.postsInfo.sublist(index, index + 5);
    } else {
      postsInfo.value = widget.postsInfo;
      isThatEndOfList.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;

    centerItemIndex ??= ((bodyHeight / 2) / bodyHeight).floor();
    return Scaffold(
      appBar: CustomAppBar.oneTitleAppBar(
          context,
          widget.isThatProfile
              ? StringsManager.posts.tr()
              : StringsManager.explore.tr()),
      body: valueListener(bodyHeight),
    );
  }

  Widget valueListener(double bodyHeight) {
    return ValueListenableBuilder(
      valueListenable: postsInfo,
      builder: (context, List<Post> postsValue, child) {
        return inViewNotifierList(postsValue, bodyHeight);
      },
    );
  }

  InViewNotifierList inViewNotifierList(
      List<Post> postsValue, double bodyHeight) {
    return InViewNotifierList(
      onRefreshData: getData,
      postsIds: postsValue,
      isThatEndOfList: isThatEndOfList,
      onListEndReached: () {},
      initialInViewIds: const ['0'],
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double vpHeight) {
        return deltaTop < (0.5 * vpHeight) && deltaBottom > (0.5 * vpHeight);
      },
      itemCount: postsValue.length,
      builder: (BuildContext context, int index) {
        return postInfo(index, bodyHeight, postsValue);
      },
    );
  }

  Container postInfo(int index, double bodyHeight, List<Post> postsValue) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.only(bottom: .5, top: .5),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return InViewNotifierWidget(
            id: '$index',
            builder: (_, bool isInView, __) {
              return columnOfWidgets(
                  bodyHeight, postsValue[index], index, isInView);
            },
          );
        },
      ),
    );
  }

  buildInView() {}

  Widget columnOfWidgets(
      double bodyHeight, Post postInfo, int index, bool playTheVideo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        posts(index, postInfo, bodyHeight, playTheVideo),
        const Divider(color: ColorManager.lightGrey, thickness: .15),
        if (isThatEndOfList.value && index == postsInfo.value.length - 1) ...[
          const AllCatchUpIcon(),
        ]
      ],
    );
  }

  Widget posts(int index, Post postInfo, double bodyHeight, bool playTheVideo) {
    return PostImage(
      postInfo: postInfo,
      bodyHeight: bodyHeight,
      indexOfPost: index,
      playTheVideo: playTheVideo,
      postsInfo: postsInfo,
      reLoadData: () {},
    );
  }
}

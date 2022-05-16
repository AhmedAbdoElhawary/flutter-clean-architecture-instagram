import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_list.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/post_list_view.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/all_catch_up_icon.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/smart_refresher.dart';

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
  List<Post> postsInfo = [];
  ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  @override
  void initState() {
    if (widget.postsInfo.length > 5) {
      postsInfo = widget.postsInfo.sublist(0, 5);
    } else {
      postsInfo = widget.postsInfo;
      isThatEndOfList.value = true;
    }
    super.initState();
  }

  Future<void> getData(int index) async {
    await Future.delayed(const Duration(seconds: 1));
    if (widget.postsInfo.length > index + 5) {
      postsInfo += widget.postsInfo.sublist(index, index + 5);
    } else {
      postsInfo = widget.postsInfo;
      isThatEndOfList.value = true;
    }
    setState(() {});
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
      body: inViewNotifier(bodyHeight),
    );
  }

  Widget inViewNotifier(double bodyHeight) {
    return InViewNotifierList(
      onRefreshData: getData,
      postsIds: postsInfo,
      isThatEndOfList: isThatEndOfList,
      onListEndReached: () {},
      initialInViewIds: const ['0'],
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double vpHeight) {
        return deltaTop < (0.5 * vpHeight) && deltaBottom > (0.5 * vpHeight);
      },
      itemCount: postsInfo.length,
      builder: (BuildContext context, int index) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsetsDirectional.only(bottom: .5, top: .5),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return InViewNotifierWidget(
                id: '$index',
                builder: (_, bool isInView, __) {
                  return columnOfWidgets(
                      bodyHeight, postsInfo[index], index, isInView);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget columnOfWidgets(
      double bodyHeight, Post postInfo, int index, bool playTheVideo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        posts(postInfo, bodyHeight, playTheVideo),
        Divider(color: Theme.of(context).toggleableActiveColor, thickness: .15),
        if (isThatEndOfList.value && index == postsInfo.length - 1) ...[
          const AllCatchUpIcon(),
        ]
      ],
    );
  }

  Widget posts(Post postInfo, double bodyHeight, bool playTheVideo) {
    return PostImage(
      postInfo: postInfo,
      bodyHeight: bodyHeight,
      playTheVideo: playTheVideo,
      postsInfo: ValueNotifier(postsInfo),
      reLoadData: () {},
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/gradient_icon.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line/post_list_view.dart';
import 'package:instagram/presentation/widgets/smart_refresher.dart';

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

    if (centerItemIndex == null) {
      centerItemIndex = ((bodyHeight / 2) / bodyHeight).floor();
      print('center item = $centerItemIndex');
    }
    return Scaffold(
      appBar: CustomAppBar.oneTitleAppBar(
          context,
          widget.isThatProfile
              ? StringsManager.posts.tr()
              : StringsManager.explore.tr()),
      body: SmarterRefresh(
        onRefreshData: getData,
        postsIds: postsInfo,
        isThatEndOfList: isThatEndOfList,
        child: inView(bodyHeight),
      ),
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
          itemCount: postsInfo.length,
          itemBuilder: (ctx, index) {
            return columnOfWidgets(
                bodyHeight, postsInfo[index], index, index == centerItemIndex);
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
        posts(postInfo, bodyHeight, playTheVideo),
        Divider(color: Theme.of(context).toggleableActiveColor, thickness: .15),
        if (isThatEndOfList.value && index == postsInfo.length - 1) ...[
          const GradientIcon(),
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

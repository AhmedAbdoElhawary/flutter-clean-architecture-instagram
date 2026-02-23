import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_custom.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_grid_view_display.dart';

// ignore: must_be_immutable
class AllTimeLineGridView extends StatefulWidget {
  List<Post> postsImagesInfo;
  List<Post> postsVideosInfo;
  List<Post> allPostsInfo;
  final ValueNotifier<bool> isThatEndOfList;
  final AsyncValueSetter<int> onRefreshData;
  final ValueNotifier<bool> reloadData;

  AllTimeLineGridView({
    required this.postsImagesInfo,
    required this.postsVideosInfo,
    required this.isThatEndOfList,
    required this.allPostsInfo,
    required this.onRefreshData,
    required this.reloadData,
    super.key,
  });

  @override
  State<AllTimeLineGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<AllTimeLineGridView> {
  int indexOfPostsVideo = 0;
  int indexOfPostsImage = 0;
  late Post postInfo;
  late int lengthOfGrid;

  @override
  void initState() {
    lengthOfGrid =
        widget.postsImagesInfo.length + widget.postsVideosInfo.length;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AllTimeLineGridView oldWidget) {
    if (oldWidget.reloadData.value) {
      indexOfPostsVideo = 0;
      indexOfPostsImage = 0;
      oldWidget.reloadData.value = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (isThatMobile) {
      return InViewNotifierCustomScrollView(
        slivers: [
          SliverMasonryGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            childCount: lengthOfGrid,
            itemBuilder: (context, index) {
              _structurePostDisplay(index);
              return inViewWidget(index, postInfo);
            },
          ),
        ],
        onRefreshData: widget.onRefreshData,
        postsIds: widget.allPostsInfo,
        isThatEndOfList: widget.isThatEndOfList,
        initialInViewIds: const ['0'],
        isInViewPortCondition:
            (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.6 * viewPortDimension) &&
              deltaBottom > (0.1 * viewPortDimension);
        },
      );
    } else {
      return SingleChildScrollView(
        child: Center(child: SizedBox(width: 910, child: _gridView())),
      );
    }
  }

  /// Desktop / Web Masonry Grid
  MasonryGridView _gridView() {
    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 30,
      crossAxisSpacing: 30,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lengthOfGrid,
      itemBuilder: (context, index) {
        _structurePostDisplay(index);
        return CustomGridViewDisplay(
          postClickedInfo: postInfo,
          postsInfo: widget.allPostsInfo,
          index: index,
          isThatProfile: false,
        );
      },
    );
  }

  /// Determines whether to show image or video at a given index
  void _structurePostDisplay(int index) {
    if (indexOfPostsVideo >= widget.postsVideosInfo.length &&
        indexOfPostsImage < widget.postsImagesInfo.length) {
      postInfo = widget.postsImagesInfo[indexOfPostsImage];
      indexOfPostsImage++;
    } else if (indexOfPostsVideo < widget.postsVideosInfo.length &&
        indexOfPostsImage >= widget.postsImagesInfo.length) {
      postInfo = widget.postsVideosInfo[indexOfPostsVideo];
      indexOfPostsVideo++;
    } else {
      if (indexOfPostsVideo >= widget.postsVideosInfo.length &&
          indexOfPostsImage >= widget.postsImagesInfo.length) {
        indexOfPostsVideo = 0;
        indexOfPostsImage = 0;
      }

      if ((index == (isThatMobile ? 2 : 1) ||
              (index % 11 == 0 && index != 0)) &&
          indexOfPostsVideo < widget.postsVideosInfo.length) {
        postInfo = widget.postsVideosInfo[indexOfPostsVideo];
        indexOfPostsVideo++;
      } else {
        postInfo = widget.postsImagesInfo[indexOfPostsImage];
        indexOfPostsImage++;
      }
    }

    if (index == widget.allPostsInfo.length - 1) {
      widget.isThatEndOfList.value = true;
    }
  }

  /// Wraps post in an InViewNotifier to handle autoplay for videos
  Container inViewWidget(int index, Post postInfo) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.only(bottom: .5, top: .5),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return InViewNotifierWidget(
            id: '$index',
            builder: (_, bool isInView, __) {
              return CustomGridViewDisplay(
                postClickedInfo: postInfo,
                postsInfo: widget.allPostsInfo,
                index: index,
                playThisVideo: isInView,
                isThatProfile: false,
              );
            },
          );
        },
      ),
    );
  }

  Center noData() {
    return Center(
      child: Text(
        StringsManager.noPosts.tr,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

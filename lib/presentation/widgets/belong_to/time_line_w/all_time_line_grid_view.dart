import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_custom.dart';
import 'package:instagram/presentation/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_grid_view_display.dart';

// ignore: must_be_immutable
class AllTimeLineGridView extends StatefulWidget {
  List<Post> postsImagesInfo;
  List<Post> postsVideosInfo;
  List<Post> allPostsInfo;
  final bool isThatProfile;
  final ValueNotifier<bool> isThatEndOfList;
  final AsyncValueSetter<int> onRefreshData;
  final ValueNotifier<bool> reloadData;

  AllTimeLineGridView(
      {required this.postsImagesInfo,
      required this.postsVideosInfo,
      required this.isThatEndOfList,
      required this.allPostsInfo,
      required this.onRefreshData,
      this.isThatProfile = true,
      required this.reloadData,
      Key? key})
      : super(key: key);

  @override
  State<AllTimeLineGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<AllTimeLineGridView> {
  int indexOfPostsVideo = 0;
  int indexOfPostsImage = 0;
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
    return InViewNotifierCustomScrollView(
      slivers: [
        SliverStaggeredGrid.countBuilder(
          crossAxisSpacing: 1.5,
          mainAxisSpacing: 1.5,
          crossAxisCount: 3,
          itemCount:
              widget.postsImagesInfo.length + widget.postsVideosInfo.length,
          itemBuilder: (context, index) {
            Post postInfo;
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
              if ((index == 2 || (index % 11 == 0 && index != 0)) &&
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
            return inViewWidget(index, postInfo);
          },
          staggeredTileBuilder: (index) {
            double num =
                (index == 2 || (index % 11 == 0 && index != 0)) ? 2 : 1;
            return StaggeredTile.count(1, num);
          },
        ),
      ],
      onRefreshData: widget.onRefreshData,
      postsIds: widget.allPostsInfo,
      isThatEndOfList: widget.isThatEndOfList,
      initialInViewIds: const ['0'],
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double viewPortDimension) {
        return deltaTop < (0.5 * viewPortDimension) &&
            deltaBottom > (0.7 * viewPortDimension);
      },
    );
  }

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
                isThatProfile: widget.isThatProfile,
              );
              // return columnOfWidgets(bodyHeight, index, isInView);
            },
          );
        },
      ),
    );
  }

  Center noData() {
    return Center(
      child: Text(
        StringsManager.noPosts.tr(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_grid_view_display.dart';

// ignore: must_be_immutable
class ProfileGridView extends StatefulWidget {
  List<Post> postsInfo;
  final String userId;

  ProfileGridView({required this.userId, required this.postsInfo, Key? key})
      : super(key: key);

  @override
  State<ProfileGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<ProfileGridView> {
  @override
  Widget build(BuildContext context) {
    bool isWidthAboveMinimum = MediaQuery.of(context).size.width > 800;

    return widget.postsInfo.isNotEmpty
        ? StaggeredGridView.countBuilder(
            padding: const EdgeInsetsDirectional.only(bottom: 1.5, top: 1.5),
            crossAxisSpacing: isWidthAboveMinimum ? 30 : 1.5,
            mainAxisSpacing: isWidthAboveMinimum ? 30 : 1.5,
            crossAxisCount: 3,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.postsInfo.length,
            itemBuilder: (context, index) {
              return CustomGridViewDisplay(
                postClickedInfo: widget.postsInfo[index],
                postsInfo: widget.postsInfo,
                index: index,
              );
            },
            staggeredTileBuilder: (index) {
              double num = widget.postsInfo[index].isThatImage ? 1 : 2;
              return StaggeredTile.count(1, num);
            },
          )
        : Center(
            child: Text(
            StringsManager.noPosts.tr,
            style: Theme.of(context).textTheme.bodyText1,
          ));
  }

  void removeThisPost(int index) {
    setState(() => widget.postsInfo.removeAt(index));
  }
}

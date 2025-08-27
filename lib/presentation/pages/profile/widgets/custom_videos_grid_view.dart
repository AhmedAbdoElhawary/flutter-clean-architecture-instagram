import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_grid_view_display.dart';

class CustomVideosGridView extends StatefulWidget {
  final List<Post> postsInfo;
  final String userId;

  const CustomVideosGridView({
    required this.userId,
    required this.postsInfo,
    super.key,
  });

  @override
  State<CustomVideosGridView> createState() => _CustomVideosGridViewState();
}

class _CustomVideosGridViewState extends State<CustomVideosGridView> {
  @override
  Widget build(BuildContext context) {
    bool isWidthAboveMinimum = MediaQuery.of(context).size.width > 800;

    return widget.postsInfo.isNotEmpty
        ? MasonryGridView.count(
            padding: const EdgeInsetsDirectional.only(bottom: 1.5, top: 1.5),
            crossAxisSpacing: isWidthAboveMinimum ? 30 : 1.5,
            mainAxisSpacing: isWidthAboveMinimum ? 30 : 1.5,
            crossAxisCount: 3,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.postsInfo.length,
            itemBuilder: (context, index) {
              final post = widget.postsInfo[index];
              final bool condition = post.isThatMix || post.isThatImage;

              // In the new MasonryGridView, the item height is defined by its content.
              // To replicate the "taller tile" effect, we can wrap the child with SizedBox.
              return SizedBox(
                height: condition ? 200 : 400, // adjust to match your old layout
                child: CustomGridViewDisplay(
                  postClickedInfo: post,
                  postsInfo: widget.postsInfo,
                  index: index,
                  playThisVideo: true,
                  showVideoCover: true,
                ),
              );
            },
          )
        : Center(
            child: Text(
              StringsManager.noPosts.tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
  }
}

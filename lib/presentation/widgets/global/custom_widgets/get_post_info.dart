import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_posts_display.dart';

class GetsPostInfoAndDisplay extends StatelessWidget {
  final String postId;
  const GetsPostInfoAndDisplay({Key? key,required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit,PostState>(bloc:PostCubit.get(context)..getPostsInfo(
        postsIds: [postId],
        isThatMyPosts: false),
      buildWhen:  (previous, current) {
        if (previous != current && current is CubitPostFailed) {
          return true;
        }
        return previous != current &&
            current is CubitPostsInfoLoaded ;
      },builder: (context, state) {
        if (state is CubitPostsInfoLoaded) {
          return CustomPostsDisplay(
            postsInfo: state.postsInfo,
            isThatProfile: false,
            showCatchUp: false,
          );
        } else {
          return CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Theme.of(context).iconTheme.color,
            backgroundColor: Theme.of(context).dividerColor,
          );
        }
    },);
  }
}

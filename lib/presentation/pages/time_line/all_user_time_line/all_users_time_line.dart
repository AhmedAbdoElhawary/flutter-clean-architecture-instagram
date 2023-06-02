import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/child_classes/post/post.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/time_line/all_user_time_line/search_about_user.dart';
import 'package:instagram/presentation/pages/time_line/widgets/all_time_line_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class AllUsersTimeLinePage extends StatelessWidget {
  final ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);
  final ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  final ValueNotifier<bool> reloadData = ValueNotifier(true);

  AllUsersTimeLinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    rebuildUsersInfo.value = false;
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: isThatMobile ? searchAppBar(context) : null,
        body: blocBuilder(),
      ),
    );
  }

  AppBar searchAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: TextField(
            onTap: () {
              Go(context).push(page: const SearchAboutUserPage());
            },
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: const EdgeInsetsDirectional.all(2.0),
                prefixIcon: Icon(Icons.search_rounded,
                    color: Theme.of(context).focusColor),
                hintText: StringsManager.search.tr,
                hintStyle: Theme.of(context).textTheme.displayLarge,
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  Future<void> getData(BuildContext context, int index) async {
    await BlocProvider.of<PostCubit>(context).getAllPostInfo();
    rebuildUsersInfo.value = true;
    reloadData.value = true;
  }

  ValueListenableBuilder<bool> blocBuilder() {
    return ValueListenableBuilder(
      valueListenable: rebuildUsersInfo,
      builder: (context, bool value, child) =>
          BlocBuilder<PostCubit, PostState>(
        bloc: BlocProvider.of<PostCubit>(context)..getAllPostInfo(),
        buildWhen: (previous, current) {
          if (previous != current &&
              (current is CubitAllPostsLoaded || current is CubitPostFailed)) {
            return true;
          }

          if (value && current is CubitAllPostsLoaded) {
            rebuildUsersInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (BuildContext context, state) {
          if (state is CubitAllPostsLoaded) {
            List<Post> imagePosts = [];
            List<Post> videoPosts = [];

            for (Post element in state.allPostInfo) {
              bool isThatImage = element.isThatMix || element.isThatImage;
              isThatImage ? imagePosts.add(element) : videoPosts.add(element);
            }

            return AllTimeLineGridView(
              onRefreshData: (int index) => getData(context, index),
              postsImagesInfo: imagePosts,
              postsVideosInfo: videoPosts,
              isThatEndOfList: isThatEndOfList,
              reloadData: reloadData,
              allPostsInfo: state.allPostInfo,
            );
          } else if (state is CubitPostFailed) {
            ToastShow.toastStateError(state);
            return Center(
                child: Text(
              StringsManager.somethingWrong.tr,
              style: getNormalStyle(
                  color: Theme.of(context).focusColor, fontSize: 18),
            ));
          } else {
            return loadingWidget(context);
          }
        },
      ),
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isThatMobile ? null : 910,
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).textTheme.headlineSmall!.color!,
          highlightColor: Theme.of(context).textTheme.titleLarge!.color!,
          child: StaggeredGridView.countBuilder(
            crossAxisSpacing: isThatMobile ? 1.5 : 30,
            mainAxisSpacing: isThatMobile ? 1.5 : 30,
            crossAxisCount: 3,
            itemCount: 16,
            itemBuilder: (_, __) {
              return Container(
                  color: ColorManager.lightDarkGray, width: double.infinity);
            },
            staggeredTileBuilder: (index) {
              double num = (index == (isThatMobile ? 2 : 1) ||
                      (index % 11 == 0 && index != 0))
                  ? 2
                  : 1;
              return StaggeredTile.count(isThatMobile ? 1 : num.toInt(), num);
            },
          ),
        ),
      ),
    );
  }
}

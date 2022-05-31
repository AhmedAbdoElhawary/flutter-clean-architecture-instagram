import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/pages/time_line/all_user_time_line/search_about_user.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/all_time_line_grid_view.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:shimmer/shimmer.dart';

class AllUsersTimeLinePage extends StatefulWidget {
  final String userId;
  const AllUsersTimeLinePage({required this.userId, Key? key})
      : super(key: key);

  @override
  State<AllUsersTimeLinePage> createState() => _AllUsersTimeLinePageState();
}

class _AllUsersTimeLinePageState extends State<AllUsersTimeLinePage> {
  bool rebuildUsersInfo = false;
  ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  final ValueNotifier<bool> reloadData = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    rebuildUsersInfo = false;
    return Scaffold(
      body: blocBuilder(),
      appBar: searchAppBar(context),
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
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const SearchAboutUserPage()));
            },
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: const EdgeInsetsDirectional.all(2.0),
                prefixIcon: Icon(Icons.search_rounded,
                    color: Theme.of(context).focusColor),
                hintText: StringsManager.search.tr(),
                hintStyle: Theme.of(context).textTheme.headline1,
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1.0),
    );
  }

  Future<void> getData(int index) async {
    await BlocProvider.of<PostCubit>(context).getAllPostInfo();
    setState(() {
      rebuildUsersInfo = true;
      reloadData.value = true;
    });
  }

  BlocBuilder<PostCubit, PostState> blocBuilder() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: BlocProvider.of<PostCubit>(context)..getAllPostInfo(),
      buildWhen: (previous, current) {
        if (previous != current && current is CubitAllPostsLoaded) {
          return true;
        }
        if (rebuildUsersInfo && current is CubitAllPostsLoaded) {
          rebuildUsersInfo = false;
          return true;
        }
        return false;
      },
      builder: (BuildContext context, state) {
        if (state is CubitAllPostsLoaded) {
          List<Post> imagePosts = [];
          List<Post> videoPosts = [];

          for (Post element in state.allPostInfo) {
            element.isThatImage == true
                ? imagePosts.add(element)
                : videoPosts.add(element);
          }

          return AllTimeLineGridView(
            onRefreshData: getData,
            postsImagesInfo: imagePosts,
            postsVideosInfo: videoPosts,
            isThatEndOfList: isThatEndOfList,
            reloadData: reloadData,
            isThatProfile: false,
            allPostsInfo: state.allPostInfo,
          );
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return Center(
              child: Text(
            StringsManager.noPosts.tr(),
            style: getNormalStyle(
                color: Theme.of(context).focusColor, fontSize: 20),
          ));
        } else {
          return loadingWidget(context);
        }
      },
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).textTheme.headline5!.color!,
      highlightColor: Theme.of(context).textTheme.headline6!.color!,
      child: StaggeredGridView.countBuilder(
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
        crossAxisCount: 3,
        itemCount: 16,
        itemBuilder: (_, __) {
          return Container(
              color: ColorManager.lightDarkGray, width: double.infinity);
        },
        staggeredTileBuilder: (index) {
          double num = (index == 2 || (index % 11 == 0 && index != 0)) ? 2 : 1;
          return StaggeredTile.count(1, num);
        },
      ),
    );
  }
}

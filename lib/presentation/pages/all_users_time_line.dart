import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/widgets/custom_grid_view.dart';
import 'package:instegram/presentation/widgets/smart_refresher.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

class SearchAboutUserPage extends StatefulWidget {
  final String userId;
  const SearchAboutUserPage({required this.userId, Key? key}) : super(key: key);

  @override
  State<SearchAboutUserPage> createState() => _SearchAboutUserPageState();
}

class _SearchAboutUserPageState extends State<SearchAboutUserPage> {
  bool rebuildUsersInfo = false;
  @override
  Widget build(BuildContext context) {
    rebuildUsersInfo = false;
    return Scaffold(
      body: blocBuilder(),
      appBar: AppBar(
        toolbarHeight: 50,
        title: Container(
          width: double.infinity,
          height: 35,
          decoration: BoxDecoration(
              color: ColorManager.veryLowOpacityGrey,
              borderRadius: BorderRadius.circular(10)),
          child: const Center(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.search_rounded, color: ColorManager.black),
                  hintText: 'Search',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: Colors.black12, width: 1.0),
    );
  }

  Future<void> getData() async {
    await BlocProvider.of<PostCubit>(context).getAllPostInfo();
    setState(() {
      rebuildUsersInfo = true;
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
      builder: (context, state) {
        if (state is CubitAllPostsLoaded) {
          return SmarterRefresh(
            onRefreshData: getData,
            smartRefresherChild: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: CustomGridView(
                  postsInfo: state.allPostInfo, userId: widget.userId),
            ),
          );
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return Center(
              child: Text(
            StringsManager.noPosts.tr(),
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ));
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: Colors.black54),
          );
        }
      },
    );
  }
}

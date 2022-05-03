import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/pages/search_about_user.dart';
import 'package:instegram/presentation/widgets/custom_grid_view.dart';
import 'package:instegram/presentation/widgets/smart_refresher.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

class AllUsersTimeLinePage extends StatefulWidget {
  final String userId;
  const AllUsersTimeLinePage({required this.userId, Key? key}) : super(key: key);

  @override
  State<AllUsersTimeLinePage> createState() => _AllUsersTimeLinePageState();
}

class _AllUsersTimeLinePageState extends State<AllUsersTimeLinePage> {
  bool rebuildUsersInfo = false;
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
      title: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            color: ColorManager.veryLowOpacityGrey,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: TextField(
            onTap: (){
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => SearchAboutUserPage()));
            },
            readOnly: true,
            decoration: InputDecoration(
                contentPadding:const EdgeInsetsDirectional.all(7.0) ,
                prefixIcon:
                    const Icon(Icons.search_rounded, color: ColorManager.black),
                hintText: StringsManager.search.tr(),
                border: InputBorder.none),
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

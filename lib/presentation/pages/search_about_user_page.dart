import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _SearchAboutUserPageState extends State<SearchAboutUserPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // bool rebuild = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // getData();
    return SafeArea(child: blocBuilder());
  }

  Future<void> getData() async {
     BlocProvider.of<PostCubit>(context).getAllPostInfo();

  }

  BlocBuilder<PostCubit, PostState> blocBuilder() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: BlocProvider.of<PostCubit>(context)..getAllPostInfo(),
      buildWhen: (previous, current) =>
          previous != current && current is CubitAllPostsLoaded,
      builder: (context, state) {
        print("========================================= ${state}");
        if (state is CubitAllPostsLoaded) {
          return SmarterRefresh(
            onRefreshData: getData(),
            smartRefresherChild: CustomGridView(
                postsInfo: state.allPostInfo, userId: widget.userId),
          );
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return const Center(child: Text("There's no posts..."));
        } else {
          return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: Colors.black54),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}

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

  bool rebuildUsersInfo = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    rebuildUsersInfo = false;
    return SafeArea(child: Scaffold(body: blocBuilder()));
  }

  Future<void> getData() async {
     await BlocProvider.of<PostCubit>(context).getAllPostInfo();
     setState(() {
       rebuildUsersInfo=true;
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
          rebuildUsersInfo=false;
          return true;
        }
        return false;
      },      builder: (context, state) {
        if (state is CubitAllPostsLoaded) {
          return SmarterRefresh(
            onRefreshData: getData,
            smartRefresherChild: SingleChildScrollView(
              child: CustomGridView(
                  postsInfo: state.allPostInfo, userId: widget.userId),
            ),
          );
        } else if (state is CubitPostFailed) {
          ToastShow.toastStateError(state);
          return const Center(child: Text("There's no posts...",style: TextStyle(color:Colors.black,fontSize: 20),));
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

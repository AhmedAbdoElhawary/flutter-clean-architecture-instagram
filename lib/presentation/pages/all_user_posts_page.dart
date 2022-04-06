import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/pages/home_page.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

class AllUserPostPage extends StatefulWidget {
  final String userId;
  const AllUserPostPage({required this.userId, Key? key}) : super(key: key);

  @override
  State<AllUserPostPage> createState() => _AllUserPostPageState();
}

class _AllUserPostPageState extends State<AllUserPostPage>
    with AutomaticKeepAliveClientMixin {
  bool loading = true;
  bool rebuild=true;

  getData() async {
    await BlocProvider.of<PostCubit>(context).getAllPostInfo();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if(rebuild) {
          getData();
          rebuild=false;
          }

        if (state is CubitAllPostsLoaded) {
            return Scaffold(
              body: GridView.count(
                  padding: const EdgeInsets.symmetric(vertical: 1.5),
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5,
                  crossAxisCount: 3,
                  children: state.allPostInfo.map((postsInfo) {
                    return postsInfo.postImageUrl.isNotEmpty
                        ? Container(
                            color: Colors.black12,
                            child: InkWell(
                                onLongPress: () {
                                  Navigator.of(context, rootNavigator: false)
                                      .push(MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                                userId: widget.userId,
                                                postsInfoIds:
                                                    state.allPostInfo,
                                            isThatUserPosts: false,
                                              ),
                                          maintainState: false));
                                },
                                child: Image.network(
                                  postsInfo.postImageUrl,
                                  fit: BoxFit.cover,
                                )),
                            height: 150.0)
                        : Container();
                  }).toList()),
            );
          } else if (state is CubitPostFailed) {
            ToastShow.toastStateError(state);
            return const Center(child: Text("There's no posts..."));
          } else {
            return const Center(
              child:  CircularProgressIndicator(
                  strokeWidth: 1.5, color: Colors.black54),
            );
          }
        },
      );
  }

  @override
  bool get wantKeepAlive => true;
}

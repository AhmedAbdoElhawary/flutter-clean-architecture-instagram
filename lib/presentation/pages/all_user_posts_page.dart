import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

class AllUserPostPage extends StatefulWidget {
  const AllUserPostPage({Key? key}) : super(key: key);

  @override
  State<AllUserPostPage> createState() => _AllUserPostPageState();
}

class _AllUserPostPageState extends State<AllUserPostPage> {
  bool loading = true;

  getData() async {
    await BlocProvider.of<PostCubit>(context).getAllPostInfo();
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      getData();
      return const Center(
        child:  CircularProgressIndicator(
            strokeWidth: 1.5, color: Colors.black54),
      );
    }else{
      return BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is CubitAllPostsLoaded) {
            return SafeArea(
              child: GridView.count(
                  padding: const EdgeInsets.symmetric(vertical: 1.5),
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5,
                  crossAxisCount: 3,
                  children: state.allPostInfo.map((postsInfo) {
                    return postsInfo.postImageUrl.isNotEmpty?
                     Container(
                        color: Colors.black12,
                        child: InkWell(
                            onLongPress: () {},
                            child: Image.network(
                              postsInfo.postImageUrl,
                              fit: BoxFit.cover,
                            )),
                        height: 150.0):Container();
                  }).toList()),
            );
          } else if (state is CubitPostFailed) {
            ToastShow.toastStateError(state);
            return const Center(child: Text("There's no posts..."));
          } else {
            return const CircularProgressIndicator(
                strokeWidth: 1.5, color: Colors.black54);
          }
        },
      );
    }
  }
}

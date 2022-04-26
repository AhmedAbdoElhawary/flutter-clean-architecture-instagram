import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/injector.dart';
import 'package:instegram/presentation/cubit/bloc/get_comments_bloc.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/repliesInfo/reply_info_cubit.dart';
import 'package:instegram/presentation/widgets/add_comment.dart';
import 'package:instegram/presentation/widgets/commentator.dart';

class CommentsPage extends StatefulWidget {
  final String postId;

  const CommentsPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _textController = TextEditingController();
  Comment? selectedCommentInfo;
  bool addReply = false;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UserPersonalInfo? myPersonalInfo =
          FirestoreUserInfoCubit.get(context).myPersonalInfo;

      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorManager.white,
          title: const Text('Comments'),
        ),
        body: BlocBuilder<GetCommentsBloc, GetCommentsState>(
            bloc: BlocProvider.of<GetCommentsBloc>(context)
              ..add(LoadComments(postId: widget.postId)),
            // ..getSpecificComments(postId: widget.postId),
            buildWhen: (previous, current) {
              if (previous != current && (current is GetCommentsLoaded)) {
                return true;
              }

              return false;
            },
            builder: (context, state) {
              if (state is GetCommentsLoaded) {
                return buildListView(state, myPersonalInfo!);
              }
              // else if (state is GetComments) {
              //   ToastShow.toastStateError(state);
              //   return const Text("Something Wrong");
              // }
              else {
                return const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 1, color: ColorManager.black54),
                );
              }
            }),
        bottomSheet: addCommentBottomSheet(myPersonalInfo!),
      );
    });
  }

  selectedComment(Comment commentInfo) {
    setState(() {
      selectedCommentInfo = commentInfo;
    });
  }

  Widget buildListView(
      GetCommentsLoaded state, UserPersonalInfo myPersonalInfo) {
    Map<int, bool> showMeReplies = {};
    return state.comments.isNotEmpty
        ? SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ListView.separated(

                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                primary: false,
                itemBuilder: (context, index) {
                  showMeReplies[index] = false;

                  return BlocProvider<ReplyInfoCubit>(
                    create: (_) => injector<ReplyInfoCubit>(),
                    child: CommentInfo(
                      commentInfo: state.comments[index],
                      index: index,
                      showMeReplies: showMeReplies,
                      textController: _textController,
                      selectedCommentInfo: selectedComment,
                      myPersonalInfo: myPersonalInfo,
                      addReply: addReply,
                    ),
                  );
                },
                itemCount: state.comments.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      height: 20,
                    )),
          )
        : const Center(
            child: Text("There is no comments!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic)),
          );
  }

  SingleChildScrollView addCommentBottomSheet(
      UserPersonalInfo userPersonalInfo) {
    return SingleChildScrollView(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        color: ColorManager.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (selectedCommentInfo != null)
              Container(
                width: double.infinity,
                height: 45,
                color: ColorManager.lightGrey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 17),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                                "Replying to ${selectedCommentInfo!.whoCommentInfo!.userName}",
                                style: const TextStyle(
                                    color: ColorManager.black54)),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCommentInfo = null;
                                _textController.text = '';
                              });
                            },
                            child: const Icon(Icons.close, size: 15)),
                      ],
                    ),
                  ),
                ),
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                textOfEmoji('❤'),
                textOfEmoji('🙌'),
                textOfEmoji('🔥'),
                textOfEmoji('👏🏻'),
                textOfEmoji('😢'),
                textOfEmoji('😍'),
                textOfEmoji('😮'),
                textOfEmoji('😂'),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: AddComment(
                postId: widget.postId,
                selectedCommentInfo: selectedCommentInfo,
                textController: _textController,
                userPersonalInfo: userPersonalInfo,
                makeSelectedCommentNullable: (){
                  setState(() {
                    selectedCommentInfo = null;
                    _textController.text = '';
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


  Widget textOfEmoji(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _textController.text = _textController.text + emoji;
          _textController.selection = TextSelection.fromPosition(
              TextPosition(offset: _textController.text.length));
        });
      },
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

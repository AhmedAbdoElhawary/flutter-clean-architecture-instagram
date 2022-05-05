import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/core/utility/injector.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:instegram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:instegram/presentation/widgets/comment_box.dart';
import 'package:instegram/presentation/widgets/commentator.dart';
import 'package:instegram/presentation/widgets/smart_refresher.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

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
  bool rebuild = false;

Future<void>loadData()async{
  setState(() {
    rebuild=true;
  });
}

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UserPersonalInfo? myPersonalInfo =
          FirestoreUserInfoCubit.get(context).myPersonalInfo;

      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorManager.white,
          title: Text(StringsManager.comments.tr()),
        ),
        body: Column(
          children: [
            Expanded(
              child: SmarterRefresh(
                onRefreshData: loadData,
                child: BlocBuilder<CommentsInfoCubit, CommentsInfoState>(
                    bloc: BlocProvider.of<CommentsInfoCubit>(context)
                      ..getSpecificComments(postId: widget.postId),
                    buildWhen: (previous, current) {
                      if (previous != current &&
                          (current is CubitCommentsInfoLoaded)) {
                        return true;
                      }
                      if(rebuild){
                        rebuild=false;
                        return true;
                      }

                      return false;
                    },
                    builder: (context, state) {
                      if (state is CubitCommentsInfoLoaded) {
                        // List<Comment> a=state.commentsOfThePost.map((e) => ).toList();
                        state.commentsOfThePost.sort(
                            (a, b) => b.datePublished.compareTo(a.datePublished));
                        return buildListView(
                            state.commentsOfThePost, myPersonalInfo!);
                      } else if (state is CubitCommentsInfoFailed) {
                        ToastShow.toastStateError(state);
                        return Text(StringsManager.somethingWrong.tr());
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 1, color: ColorManager.black54),
                        );
                      }
                    }),
              ),
            ),
            commentBox(myPersonalInfo!),
          ],
        ),
      );
    });
  }

  selectedComment(Comment commentInfo) {
    setState(() {
      selectedCommentInfo = commentInfo;
    });
  }

  Widget buildListView(
      List<Comment> commentsOfThePost, UserPersonalInfo myPersonalInfo) {
    Map<int, bool> showMeReplies = {};
    return commentsOfThePost.isNotEmpty
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
                      commentInfo: commentsOfThePost[index],
                      index: index,
                      showMeReplies: showMeReplies,
                      textController: _textController,
                      selectedCommentInfo: selectedComment,
                      myPersonalInfo: myPersonalInfo,
                      addReply: addReply,
                    ),
                  );
                },
                itemCount: commentsOfThePost.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      height: 20,
                    )),
          )
        : Center(
            child: Text(StringsManager.noComments.tr(),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic)),
          );
  }

  Widget commentBox(UserPersonalInfo userPersonalInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (selectedCommentInfo != null) ...[
          Container(
            width: double.infinity,
            height: 45,
            color: const Color.fromARGB(18, 59, 59, 59),
            child: Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 10.0, end: 17),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          "${StringsManager.replyingTo.tr()} ${selectedCommentInfo!.whoCommentInfo!.userName}",
                          style:
                              const TextStyle(color: ColorManager.black54)),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCommentInfo = null;
                            _textController.text = '';
                          });
                        },
                        child: const Icon(Icons.close, size: 18)),
                  ],
                ),
              ),
            ),
          ),
        ],
        customDivider(),
        CommentBox(

          postId: widget.postId,
          selectedCommentInfo: selectedCommentInfo,
          textController: _textController,
          userPersonalInfo: userPersonalInfo,
          makeSelectedCommentNullable: () {
            setState(() {
              selectedCommentInfo = null;
              _textController.text = '';
            });
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: Colors.grey,
      width: double.infinity,
      height: 0.2);
}

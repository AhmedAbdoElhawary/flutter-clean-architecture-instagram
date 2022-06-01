import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/comment.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:instagram/presentation/widgets/belong_to/comments_w/comment_box.dart';
import 'package:instagram/presentation/widgets/belong_to/comments_w/commentator.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/core/functions/toast_show.dart';

class CommentsPage extends StatelessWidget {
  final String postId;

  CommentsPage({Key? key, required this.postId}) : super(key: key);

  final ValueNotifier<TextEditingController> _textController =
      ValueNotifier(TextEditingController());
  final ValueNotifier<Comment?> selectedCommentInfo = ValueNotifier(null);
  final bool addReply = false;
  final ValueNotifier<bool> rebuild = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UserPersonalInfo? myPersonalInfo =
          FirestoreUserInfoCubit.get(context).myPersonalInfo;

      return Scaffold(
        appBar: appBar(context),
        body: scaffoldBody(context, myPersonalInfo),
      );
    });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(StringsManager.comments.tr(),
          style: getNormalStyle(color: Theme.of(context).focusColor)),
    );
  }

  Column scaffoldBody(BuildContext context, UserPersonalInfo? myPersonalInfo) {
    return Column(
      children: [
        commentsList(context, myPersonalInfo),
        commentBox(myPersonalInfo!),
      ],
    );
  }

  Expanded commentsList(
      BuildContext context, UserPersonalInfo? myPersonalInfo) {
    return Expanded(
      child: blocBuilder(context, myPersonalInfo),
    );
  }

  Widget blocBuilder(BuildContext context, UserPersonalInfo? myPersonalInfo) {
    return BlocBuilder<CommentsInfoCubit, CommentsInfoState>(
      bloc: blocAction(context),
      buildWhen: buildBlocWhen,
      builder: (context, state) => buildBloc(context, state, myPersonalInfo),
    );
  }

  CommentsInfoCubit blocAction(BuildContext context) =>
      BlocProvider.of<CommentsInfoCubit>(context)
        ..getSpecificComments(postId: postId);

  bool buildBlocWhen(CommentsInfoState previous, CommentsInfoState current) =>
      previous != current && current is CubitCommentsInfoLoaded;

  Widget buildBloc(context, state, UserPersonalInfo? myPersonalInfo) {
    if (state is CubitCommentsInfoLoaded) {
      return blocLoaded(context, state, myPersonalInfo);
    } else if (state is CubitCommentsInfoFailed) {
      return whenBuildFailed(context, state);
    } else {
      return const ThineCircularProgress();
    }
  }

  Widget blocLoaded(BuildContext context, CubitCommentsInfoLoaded state,
      UserPersonalInfo? myPersonalInfo) {
    state.commentsOfThePost
        .sort((a, b) => b.datePublished.compareTo(a.datePublished));
    return buildListView(state.commentsOfThePost, myPersonalInfo!, context);
  }

  Widget whenBuildFailed(BuildContext context, state) {
    ToastShow.toastStateError(state);
    return Text(StringsManager.somethingWrong.tr(),
        style: getNormalStyle(color: Theme.of(context).focusColor));
  }

  selectedComment(Comment commentInfo) {
    selectedCommentInfo.value = commentInfo;
  }

  Widget buildListView(List<Comment> commentsOfThePost,
      UserPersonalInfo myPersonalInfo, BuildContext context) {
    Map<int, bool> showMeReplies = {};
    return commentsOfThePost.isNotEmpty
        ? commentsListView(showMeReplies, commentsOfThePost, myPersonalInfo)
        : noCommentText(context);
  }

  ListView commentsListView(Map<int, bool> showMeReplies,
      List<Comment> commentsOfThePost, UserPersonalInfo myPersonalInfo) {
    return ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          showMeReplies[index] = false;
          return BlocProvider<ReplyInfoCubit>(
            create: (_) => injector<ReplyInfoCubit>(),
            child: ValueListenableBuilder(
              builder: (context, TextEditingController value, child) {
                return CommentInfo(
                  commentInfo: commentsOfThePost[index],
                  index: index,
                  showMeReplies: showMeReplies,
                  textController: value,
                  selectedCommentInfo: selectedComment,
                  myPersonalInfo: myPersonalInfo,
                  addReply: addReply,
                  rebuildComments: rebuild,
                );
              },
              valueListenable: _textController,
            ),
          );
        },
        itemCount: commentsOfThePost.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 20,
            ));
  }

  Center noCommentText(BuildContext context) {
    return Center(
      child: Text(StringsManager.noComments.tr(),
          style: getBoldStyle(
              fontSize: 20,
              color: Theme.of(context).focusColor,
              fontStyle: FontStyle.italic)),
    );
  }

  Widget commentBox(UserPersonalInfo userPersonalInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        replyingMention(),
        customDivider(),
        commentTextField(userPersonalInfo),
        const SizedBox(height: 10),
      ],
    );
  }

  ValueListenableBuilder<Comment?> replyingMention() {
    return ValueListenableBuilder(
      valueListenable: selectedCommentInfo,
      builder: (context, Comment? value, child) {
        if (value != null) {
          return Container(
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
                          "${StringsManager.replyingTo.tr()} ${value.whoCommentInfo!.userName}",
                          style: getNormalStyle(
                              color: Theme.of(context).disabledColor)),
                    ),
                    GestureDetector(
                        onTap: () {
                          selectedCommentInfo.value = null;
                          _textController.value.text = '';
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Theme.of(context).focusColor,
                        )),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  ValueListenableBuilder<Comment?> commentTextField(
      UserPersonalInfo userPersonalInfo) {
    return ValueListenableBuilder(
      valueListenable: selectedCommentInfo,
      builder: (context, Comment? commentValue, child) {
        return ValueListenableBuilder(
          builder: (context, TextEditingController textValue, child) {
            return CommentBox(
              postId: postId,
              selectedCommentInfo: commentValue,
              textController: textValue,
              userPersonalInfo: userPersonalInfo,
              makeSelectedCommentNullable: makeSelectedCommentNullable,
            );
          },
          valueListenable: _textController,
        );
      },
    );
  }

  makeSelectedCommentNullable(bool isThatComment) {
    selectedCommentInfo.value = null;
    _textController.value.text = '';
    if (!isThatComment) rebuild.value = true;
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: ColorManager.grey,
      width: double.infinity,
      height: 0.2);
}

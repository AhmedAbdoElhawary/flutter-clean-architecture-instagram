import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/functions/date_of_now.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/data/models/comment.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:instagram/presentation/widgets/belong_to/comments_w/comment_box.dart';
import 'package:instagram/presentation/widgets/belong_to/comments_w/commentator.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circular_progress.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_post_display.dart';

class BuildComments extends StatefulWidget {
  final Post postInfo;
  final bool showImage;
  const BuildComments({
    Key? key,
    required this.postInfo,
    this.showImage = false,
  }) : super(key: key);

  @override
  State<BuildComments> createState() => _BuildCommentsState();
}

class _BuildCommentsState extends State<BuildComments> {
  final TextEditingController _textController = TextEditingController();
  Map<int, bool> showMeReplies = {};
  List<Comment> allComments = [];
  Comment? selectedCommentInfo;
  bool addReply = false;
  bool rebuild = false;
  late UserPersonalInfo myPersonalInfo;
  @override
  initState() {
    myPersonalInfo = FirestoreUserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        commentsList(context),
        commentBox(),
      ],
    );
  }

  Expanded commentsList(BuildContext context) {
    return Expanded(
      child: blocBuilder(context),
    );
  }

  Widget blocBuilder(BuildContext context) {
    return BlocBuilder<CommentsInfoCubit, CommentsInfoState>(
      bloc: blocAction(context),
      buildWhen: buildBlocWhen,
      builder: (context, state) => buildBloc(context, state),
    );
  }

  CommentsInfoCubit blocAction(BuildContext context) =>
      BlocProvider.of<CommentsInfoCubit>(context)
        ..getSpecificComments(postId: widget.postInfo.postUid);

  bool buildBlocWhen(CommentsInfoState previous, CommentsInfoState current) =>
      previous != current && current is CubitCommentsInfoLoaded;

  Widget buildBloc(context, state) {
    if (state is CubitCommentsInfoLoaded) {
      return blocLoaded(context, state);
    } else if (state is CubitCommentsInfoFailed) {
      return whenBuildFailed(context, state);
    } else {
      return const ThineCircularProgress();
    }
  }

  Widget blocLoaded(BuildContext context, CubitCommentsInfoLoaded state) {
    state.commentsOfThePost
        .sort((a, b) => b.datePublished.compareTo(a.datePublished));
    allComments = state.commentsOfThePost;
    return commentsListView(allComments);
  }

  Widget whenBuildFailed(BuildContext context, state) {
    ToastShow.toastStateError(state);
    return Text(StringsManager.somethingWrong.tr(),
        style: getNormalStyle(color: Theme.of(context).focusColor));
  }

  selectedComment(Comment commentInfo) {
    setState(() {
      selectedCommentInfo = commentInfo;
    });
  }

  Widget commentsListView(List<Comment> commentsOfThePost) {
    return allComments.isEmpty && !widget.showImage
        ? noCommentText(context)
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showImage) ...[
                  CustomPostDisplay(
                    playTheVideo: true,
                    indexOfPost: 0,
                    postsInfo: ValueNotifier([widget.postInfo]),
                    postInfo: ValueNotifier(widget.postInfo),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 11.5, top: 5.0),
                    child: Text(
                      DateOfNow.chattingDateOfNow(widget.postInfo.datePublished,
                          widget.postInfo.datePublished),
                      style: getNormalStyle(
                          color: Theme.of(context).bottomAppBarColor),
                    ),
                  ),
                  const Divider(color: ColorManager.black26),
                ],
                allComments.isNotEmpty
                    ? buildComments(commentsOfThePost)
                    : const SizedBox(),
              ],
            ),
          );
  }

  ListView buildComments(List<Comment> commentsOfThePost) {
    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (!showMeReplies.containsKey(index)) {
          showMeReplies[index] = false;
        }

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
            customRebuildCallback: isScreenRebuild,
            rebuildComment: rebuild,
            postInfo: widget.postInfo,
          ),
        );
      },
      itemCount: commentsOfThePost.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
    );
  }

  void isScreenRebuild({bool isRebuild = false}) {
    setState(() {
      rebuild = isRebuild;
    });
  }

  Widget noCommentText(BuildContext context) {
    return Center(
      child: Text(
        StringsManager.noComments.tr(),
        style: getBoldStyle(
            fontSize: 20,
            color: Theme.of(context).focusColor,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget commentBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        replyingMention(),
        customDivider(),
        commentTextField(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget replyingMention() {
    if (selectedCommentInfo != null) {
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
                      "${StringsManager.replyingTo.tr()} ${selectedCommentInfo!.whoCommentInfo!.userName}",
                      style: getNormalStyle(
                          color: Theme.of(context).disabledColor)),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCommentInfo = null;
                        _textController.text = '';
                      });
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
  }

  Widget commentTextField() {
    return CommentBox(
      postInfo: widget.postInfo,
      selectedCommentInfo: selectedCommentInfo,
      textController: _textController,
      userPersonalInfo: myPersonalInfo,
      makeSelectedCommentNullable: makeSelectedCommentNullable,
    );
  }

  makeSelectedCommentNullable(bool isThatComment) {
    setState(() {
      selectedCommentInfo = null;
      _textController.text = '';
      if (!isThatComment) isScreenRebuild(isRebuild: true);
    });
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: ColorManager.grey,
      width: double.infinity,
      height: 0.2);
}

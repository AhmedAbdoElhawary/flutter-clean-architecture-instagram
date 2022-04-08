import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/presentation/widgets/animated_dialog.dart';
import 'package:instegram/presentation/widgets/circle_avatar_of_profile_image.dart';
import 'package:instegram/presentation/widgets/custom_posts_display.dart';

class CustomGridView extends StatelessWidget{
   List<Post> postsInfo;
  final String userId;
  bool shrinkWrap;

  CustomGridView( {this.shrinkWrap=true,required this.userId,required this.postsInfo,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return postsInfo.isNotEmpty
        ? GridView.count(
        padding: const EdgeInsets.symmetric(vertical: 1.5),
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        primary: !shrinkWrap,
        shrinkWrap: shrinkWrap,
        children: postsInfo.map((postInfo) {
          return createGridTileWidget(postInfo);
        }).toList())
        : const Center(child: Text("There's no posts..."));
  }


  OverlayEntry? _popupDialog;

  Widget createGridTileWidget(Post postInfo) => Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) =>CustomPostsDisplay(postsInfo),));
      },
      onLongPress: () {
        _popupDialog = _createPopupDialog(postInfo);
        Overlay.of(context)!.insert(_popupDialog!);
      },
      onLongPressEnd: (details) => _popupDialog?.remove(),
      child: Image.network(postInfo.postImageUrl, fit: BoxFit.cover),
    ),
  );
  OverlayEntry _createPopupDialog(Post postInfo) {
    return OverlayEntry(
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 20),
        child: AnimatedDialog(
          child: _createPopupContent(postInfo),
        ),
      ),
    );
  }

  Widget _createPopupContent(Post postInfo) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createPhotoTitle(postInfo),
          Container(
              color: Colors.white,
              width: double.infinity,
              child: Image.network(postInfo.postImageUrl,
                  fit: BoxFit.fitWidth)),
          _createActionBar(),
        ],
      ),
    ),
  );
  Widget _createPhotoTitle(Post postInfo) => Container(
    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    height: 55,
    width: double.infinity,
    color: Colors.white,
    child: Row(
      children: [
        CircleAvatarOfProfileImage(
          imageUrl: postInfo.publisherInfo!.profileImageUrl,
          thisForStoriesLine: false,
          bodyHeight: 370,
          circleAvatarName: '',
        ),
        const SizedBox(width: 7),
        Text(postInfo.publisherInfo!.name,
            style: const TextStyle(
              color: Colors.black,
            )),
      ],
    ),
  );

  Widget _createActionBar() => Container(
    height: 50,
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Icon(
          Icons.favorite_border,
          color: Colors.black,
        ),
        Icon(
          Icons.chat_bubble_outline,
          color: Colors.black,
        ),
        Icon(
          Icons.send,
          color: Colors.black,
        ),
      ],
    ),
  );

}

class CustomGridViewp extends StatelessWidget{
  List<Post> postsInfo;
  final String userId;
  bool shrinkWrap;

  CustomGridViewp( {this.shrinkWrap=true,required this.userId,required this.postsInfo,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("|||||||||||||||||||||||||||||||||||||||||| ${postsInfo.length}");
    return postsInfo.isNotEmpty
        ? GridView.count(
        padding: const EdgeInsets.symmetric(vertical: 1.5),
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        primary: !shrinkWrap,
        shrinkWrap: shrinkWrap,
        children: postsInfo.map((postInfo) {
          return createGridTileWidget(postInfo);
        }).toList())
        : const Center(child: Text("There's no posts..."));
  }


  OverlayEntry? _popupDialog;

  Widget createGridTileWidget(Post postInfo) => Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) =>CustomPostsDisplay(postsInfo),));
      },
      onLongPress: () {
        _popupDialog = _createPopupDialog(postInfo);
        Overlay.of(context)!.insert(_popupDialog!);
      },
      onLongPressEnd: (details) => _popupDialog?.remove(),
      child: Image.network(postInfo.postImageUrl, fit: BoxFit.cover),
    ),
  );
  OverlayEntry _createPopupDialog(Post postInfo) {
    return OverlayEntry(
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 20),
        child: AnimatedDialog(
          child: _createPopupContent(postInfo),
        ),
      ),
    );
  }

  Widget _createPopupContent(Post postInfo) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createPhotoTitle(postInfo),
          Container(
              color: Colors.white,
              width: double.infinity,
              child: Image.network(postInfo.postImageUrl,
                  fit: BoxFit.fitWidth)),
          _createActionBar(),
        ],
      ),
    ),
  );
  Widget _createPhotoTitle(Post postInfo) => Container(
    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    height: 55,
    width: double.infinity,
    color: Colors.white,
    child: Row(
      children: [
        CircleAvatarOfProfileImage(
          imageUrl: postInfo.publisherInfo!.profileImageUrl,
          thisForStoriesLine: false,
          bodyHeight: 370,
          circleAvatarName: '',
        ),
        const SizedBox(width: 7),
        Text(postInfo.publisherInfo!.name,
            style: const TextStyle(
              color: Colors.black,
            )),
      ],
    ),
  );

  Widget _createActionBar() => Container(
    height: 50,
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Icon(
          Icons.favorite_border,
          color: Colors.black,
        ),
        Icon(
          Icons.chat_bubble_outline,
          color: Colors.black,
        ),
        Icon(
          Icons.send,
          color: Colors.black,
        ),
      ],
    ),
  );

}
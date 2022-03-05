import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/presentation/widgets/read_more_text.dart';

import '../widgets/circle_avatar_name.dart';
import '../widgets/circle_avatar_of_profile_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLiked = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: bodyHeight * 0.14,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  String circleAvatarName = "Ahmed";
                  return CircleAvatarOfProfileImage(
                      circleAvatarName, bodyHeight, true);
                },
              ),
            ),
            const Divider(thickness: 0.5),
            ListView.separated(
              itemCount: 1,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return thePostsOfHomePage("Ahmed", bodyHeight);
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.3,
      centerTitle: false,
      title: SvgPicture.asset(
        "assets/icons/ic_instagram.svg",
        height: 32,
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/heart.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/send.svg",
            color: Colors.black,
            height: 22.5,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget thePostsOfHomePage(String circleAvatarName, double bodyHeight) {
    return SizedBox(
      width: double.infinity,
      // height: 200,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatarOfProfileImage(circleAvatarName, bodyHeight / 2, false),
            const SizedBox(width: 5),
            Expanded(child: NameOfCircleAvatar(circleAvatarName, false)),
            menuButton()
          ],
        ),
        imageOfPost(),
        Row(children: [
          Expanded(
              child: Row(
            children: [
              IconButton(
                icon: isLiked
                    ? const Icon(
                        Icons.favorite_border,
                      )
                    : const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                onPressed: () {
                  setState(() {
                    isLiked = isLiked ? false : true;
                  });
                },
              ),
              IconButton(
                icon: iconsOfImagePost("assets/icons/comment.svg"),
                onPressed: () {},
              ),
              IconButton(
                icon: iconsOfImagePost("assets/icons/send.svg"),
                onPressed: () {},
              ),
            ],
          )),
          IconButton(
            icon: isSaved
                ? const Icon(
                    Icons.bookmark_border,
                  )
                : const Icon(
                    Icons.bookmark,
                  ),
            onPressed: () {
              setState(() {
                isSaved = isSaved ? false : true;
              });
            },
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(left: 11.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              numbersOfLikes(),
              const SizedBox(height: 5),
              ReadMore(
                "$circleAvatarName Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.",
              2),
              const SizedBox(height: 5),
              const Text("View all 171 comment...",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              addCommentRow()
            ],
          ),
        )
      ]),
    );
  }

  Row addCommentRow() {
    return Row(
      children: const [
        CircleAvatar(
            radius: 14,
            backgroundColor: Colors.black12,
            // ignore: todo
            //TODO : here put the personal picture of the user
            child: Icon(Icons.person, color: Colors.white)),
        SizedBox(width: 10),
        Text(
          "Add a comment...",
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget numbersOfLikes() {
    return const Text("20,435 likes",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold));
  }

  SvgPicture iconsOfImagePost(String path) {
    return SvgPicture.asset(
      path,
      color: Colors.black,
      height: 28,
    );
  }

  Widget imageOfPost() {
    return InkWell(
      onDoubleTap: () {
        setState(() {
          isLiked = isLiked ? false : true;
        });
      },
      child: const Image(
        width: double.infinity,
        fit: BoxFit.fitWidth,
        image: AssetImage(
            "assets/3d_caractars/pictures_for_posts/photo-1587387119725-9d6bac0f22fb.jpg"),
      ),
    );
  }

  IconButton menuButton() {
    return IconButton(
      icon: SvgPicture.asset(
        "assets/icons/menu_horizontal.svg",
        color: Colors.black,
        height: 23,
      ),
      color: Colors.black,
      onPressed: () {},
    );
  }
}

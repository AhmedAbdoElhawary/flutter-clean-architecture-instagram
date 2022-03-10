import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/circle_avatar_of_profile_image.dart';
import '../widgets/read_more_text.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          // allows you to build a list of elements that would be scrolled away till the body reached the top
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(listOfWidgetsAboveTapBars()),
              ),
            ];
          },
          // You tab view goes here
          body: tapBar(),
        ),
      ),
    );
  }

  Column tapBar() {
    return Column(
      children: [
        tabBarIcons(),
        tapBarView(),
      ],
    );
  }

  Expanded tapBarView() {
    return Expanded(
      child: TabBarView(
        children: [
          normalVideoView(),
          verticalVideosView(),
          normalVideoView(),
        ],
      ),
    );
  }

  GridView normalVideoView() {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      children: Colors.primaries.map((color) {
        return Container(color: color, height: 150.0);
      }).toList(),
    );
  }

  GridView verticalVideosView() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisExtent: 215,
      ),
      padding: EdgeInsets.zero,
      children: Colors.primaries.map((color) {
        return Container(color: color, height: 150.0);
      }).toList(),
    );
  }

  TabBar tabBarIcons() {
    return TabBar(
      tabs: [
        const Tab(icon: Icon(Icons.grid_on_sharp)),
        Tab(
            icon: SvgPicture.asset(
          "assets/icons/video.svg",
          color: Colors.black,
          height: 22.5,
        )),
        const Tab(
            icon: Icon(
          Icons.play_arrow_outlined,
          size: 38,
        )),
      ],
    );
  }

  List<Widget> listOfWidgetsAboveTapBars() {
    return [
      personalPhotoAndNumberInfo(),
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadMore(
                "Ahmed Abdo\nGoogle’s mobile UI open source framework to build high-qualityGoogle’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.",
                4),
            const Text(
              "this is links",
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                editProfile(),
                const SizedBox(width: 5),
                recommendationPeople(),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  InkWell recommendationPeople() {
    return InkWell(
      onTap: () {},
      child: Container(
        //width: 100.0,
        height: 35.0,
        width: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 1.0),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: const Center(
          child: Icon(Icons.person_add_outlined),
        ),
      ),
    );
  }

  Expanded editProfile() {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 35.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12, width: 1.0),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Center(
            child: Text(
              'Edit profile',
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Row personalPhotoAndNumberInfo() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CircleAvatarOfProfileImage("Ahmed Abdo", 900, false),
      personalNumbersInfo(11, "Posts"),
      personalNumbersInfo(234, "Followers"),
      personalNumbersInfo(1, "Following"),
    ]);
  }

  Expanded personalNumbersInfo(int number, String text) {
    return Expanded(
      child: Column(
        children: [
          Text("$number", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(text)
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text("ahmedabdo1111"),
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
            "assets/icons/menu.svg",
            color: Colors.black,
            height: 30,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}

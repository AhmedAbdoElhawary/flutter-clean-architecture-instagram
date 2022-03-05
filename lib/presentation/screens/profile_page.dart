import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/circle_avatar_of_profile_image.dart';
import '../widgets/read_more_text.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CircleAvatarOfProfileImage("Ahmed Abdo", 900, false),
            personalNumbersInfo(11, "Posts"),
            personalNumbersInfo(234, "Followers"),
            personalNumbersInfo(1, "Following"),
          ]),
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
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          //width: 100.0,
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
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
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
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(

                  tabs: [
                    Tab(icon: Icon(Icons.directions_car)),
                    Tab(icon: Icon(Icons.directions_transit)),
                    Tab(icon: Icon(Icons.directions_bike)),
                  ],
                ),
                 SizedBox(
                  height: 600,
                  child: TabBarView(
                    children: [
                      Container(color: Colors.blueGrey,),
                      Container(color: Colors.indigoAccent,),
                      Container(color: Colors.teal,),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
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

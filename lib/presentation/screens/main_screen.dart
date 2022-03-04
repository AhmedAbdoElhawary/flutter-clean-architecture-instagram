import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<AppBar> _appBarOptions = [
    AppBar(
      backgroundColor: Colors.white,
      elevation: 0.3,
      centerTitle: false,
      title: SvgPicture.asset(
        "assets/icons/ic_instagram.svg",
        color: Colors.black,
        height: 32,
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add.svg",
            color: Colors.black,
            height: 22.5,
          ),
          color: Colors.black,
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/heart.svg",
            color: Colors.black,
            height: 25,
          ),
          color: Colors.black,
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/send.svg",
            color: Colors.black,
            height: 23,
          ),
          color: Colors.black,
          onPressed: () {},
        )
      ],
    ),
    AppBar(backgroundColor: Colors.blue),
    AppBar(backgroundColor: Colors.deepOrangeAccent),
    AppBar(backgroundColor: Colors.amber),
    AppBar(backgroundColor: Colors.blue),
  ];
  static final List<Widget> _screenOptions = [
    const HomeScreen(),
    const Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    const Text(
      'Index 2: School',
      style: optionStyle,
    ),
    const Text(
      'Index 3: School',
      style: optionStyle,
    ),
    const Text(
      'Index 4: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions[_selectedIndex],
      body: Center(child: Container(child: _screenOptions[_selectedIndex])),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        items: [
          navigationBarItem("house_white.svg"),
          navigationBarItem("search.svg"),
          navigationBarItem("video.svg"),
          navigationBarItem("shop_white.svg"),
          const BottomNavigationBarItem(
            icon: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.black12,
                // ignore: todo
                //TODO : here put the personal picture of the user
                child: Icon(Icons.person, color: Colors.white)),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  BottomNavigationBarItem navigationBarItem(String fileName) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        "assets/icons/$fileName",
        height: 25,
      ),
      label: '',
    );
  }
}

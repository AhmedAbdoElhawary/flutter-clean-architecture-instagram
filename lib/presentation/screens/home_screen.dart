import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  static final List<Widget> _widgetOptions = [
    const Text(
      'Index 0: Home',
      style: optionStyle,
    ),
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
      body: Center(child: Container(child: _widgetOptions[_selectedIndex])),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/house_white.svg",
              height: 25,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/search.svg",
              height: 25,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/video.svg",
              height: 25,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/shop_white.svg",
              height: 25,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: CircleAvatar(radius: 13, backgroundColor: Colors.black12),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

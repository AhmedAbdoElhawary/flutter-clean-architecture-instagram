// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:instegram/core/resources/color_manager.dart';
//
// class SearchAppBar extends StatefulWidget {
//   const SearchAppBar({Key? key}) : super(key: key);
//
//   @override
//   State<SearchAppBar> createState() => _SearchAboutUserPageState();
// }
//
// class _SearchAboutUserPageState extends State<SearchAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       toolbarHeight: 50,
//       title: Container(
//         width: double.infinity,
//         height: 35,
//         decoration: BoxDecoration(
//             color: ColorManager.veryLowOpacityGrey,
//             borderRadius: BorderRadius.circular(10)),
//         child: Center(
//           child: TextField(
//             onTap: (){
//               Navigator.of(context).push(CupertinoPageRoute(
//                   builder: (context) => const SearchAboutUserPage()));
//             },
//             readOnly: true,
//             decoration: const InputDecoration(
//                 prefixIcon:
//                 Icon(Icons.search_rounded, color: ColorManager.black),
//                 hintText: 'Search',
//                 border: InputBorder.none),
//           ),
//         ),
//       ),
//     );;
//   }
// }

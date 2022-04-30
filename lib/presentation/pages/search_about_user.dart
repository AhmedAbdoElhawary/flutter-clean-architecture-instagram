import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';

class SearchAboutUserPage extends StatefulWidget {
  const SearchAboutUserPage({Key? key}) : super(key: key);

  @override
  State<SearchAboutUserPage> createState() => _SearchAboutUserPageState();
}

class _SearchAboutUserPageState extends State<SearchAboutUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Container(
          width: double.infinity,
          height: 35,
          decoration: BoxDecoration(
              color: ColorManager.veryLowOpacityGrey,
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            decoration: const InputDecoration(
                hintText: 'Search', border: InputBorder.none),
          ),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: const Text(StringsManager.theName),
              leading: const CircleAvatar(
                  child:
                      Icon(Icons.person, color: ColorManager.white, size: 50),
                  radius: 30),
              onTap: () {},
            );
          },
          itemCount: 5,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10,)),
    );
  }
}

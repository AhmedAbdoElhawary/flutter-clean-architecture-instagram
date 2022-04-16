import 'package:flutter/material.dart';

class MassagesPage extends StatelessWidget {
  const MassagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: ,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
              ))
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: const Text("The Name"),
              leading: const CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white, size: 50),
                  radius: 30),
              onTap: () {
          
              },
            );
          },
          itemCount: 5,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider()),
    );
  }
}

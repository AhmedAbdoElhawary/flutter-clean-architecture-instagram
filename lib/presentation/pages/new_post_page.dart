import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostPage extends StatefulWidget {
  XFile selectedImage;

  NewPostPage(this.selectedImage, {Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  bool isSwitched = false;

  TextEditingController captionController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            child: Row(
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.file(File(widget.selectedImage.path)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: captionController,
                    cursorColor: Colors.teal,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a caption...",
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          buildText("Tag People"),
          const Divider(),
          buildText("Add location"),
          const Divider(),
          buildText("Also post to"),
          Row(
            children: [
              Expanded(child: buildText("Facebook")),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
                activeTrackColor: Colors.blue,
                activeColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildText(String text) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10, top: 7, bottom: 7),
        child: Text(text, style: const TextStyle(fontSize: 16.5)));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("New Post"),
        actions: actionsWidgets(context));
  }

  List<Widget> actionsWidgets(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.check,
            size: 30,
            color: Colors.blue,
          ))
    ];
  }
}

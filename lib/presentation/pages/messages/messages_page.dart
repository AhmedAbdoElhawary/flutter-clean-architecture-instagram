import 'package:flutter/material.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/widgets/belong_to/messages_w/list_of_messages.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isThatMobile ? buildAppBar(context) : null,
      body: const SingleChildScrollView(child: ListOfMessages()),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add,
              color: Theme.of(context).focusColor,
              size: 30,
            ))
      ],
    );
  }
}

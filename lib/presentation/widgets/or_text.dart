import 'package:flutter/material.dart';

class OrText extends StatelessWidget{
  const OrText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
            child: Divider(
              indent: 20,
              endIndent: 5,
              thickness: 1,
            )),
        Text(
          "OR",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: Divider(
              indent: 5,
              endIndent: 20,
              thickness: 1,
            )),
      ],
    );
  }

}
import 'package:flutter/material.dart';

class PictureViewer extends StatelessWidget {
  const PictureViewer({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: InteractiveViewer(
        child:  GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Hero(
              tag: imageUrl,
              child: Image.network(
                imageUrl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

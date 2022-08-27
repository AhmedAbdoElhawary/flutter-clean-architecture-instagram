import 'dart:typed_data';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:octo_image/octo_image.dart';

class MemoryImageDisplay extends StatefulWidget {
  final Uint8List imagePath;

  const MemoryImageDisplay({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<MemoryImageDisplay> createState() => _NetworkImageDisplayState();
}

class _NetworkImageDisplayState extends State<MemoryImageDisplay> {
  @override
  void didChangeDependencies() {
    if (widget.imagePath.isNotEmpty) {
      precacheImage(MemoryImage(widget.imagePath), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return buildOctoImage();
  }

  Widget buildOctoImage() {
    return OctoImage(
      image: MemoryImage(widget.imagePath),
      errorBuilder: (context, url, error) => buildError(),
      fit: BoxFit.cover,
      width: double.infinity,
      placeholderBuilder: (context) => Center(child: buildSizedBox()),
    );
  }

  SizedBox buildError() {
    return SizedBox(
      child: Icon(Icons.warning_amber_rounded,
          size: 30, color: Theme.of(context).focusColor),
    );
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).textTheme.bodyMedium!.color,
      child: Center(
          child: CircleAvatar(
        radius: 57,
        backgroundColor: Theme.of(context).textTheme.bodySmall!.color,
        child: Center(
            child: CircleAvatar(
          radius: 56,
          backgroundColor: Theme.of(context).textTheme.bodyMedium!.color,
        )),
      )),
    );
  }
}

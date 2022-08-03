import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
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

  OctoImage buildOctoImage() {
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
      width: double.infinity,
      child: Icon(Icons.warning_amber_rounded,
          size: 50, color: Theme.of(context).focusColor),
    );
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      color: ColorManager.black26,
    );
  }
}

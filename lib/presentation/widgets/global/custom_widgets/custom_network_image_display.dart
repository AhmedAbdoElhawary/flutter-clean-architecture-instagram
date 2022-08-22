import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:octo_image/octo_image.dart';

class NetworkImageDisplay extends StatefulWidget {
  final int cachingHeight, cachingWidth;
  final String imageUrl, blurHash;
  final double aspectRatio;
  final double? height;

  const NetworkImageDisplay({
    Key? key,
    required this.imageUrl,
    this.cachingHeight = 720,
    this.cachingWidth = 720,
    this.height,
    this.blurHash = "",
    this.aspectRatio = 0,
  }) : super(key: key);

  @override
  State<NetworkImageDisplay> createState() => _NetworkImageDisplayState();
}

class _NetworkImageDisplayState extends State<NetworkImageDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.imageUrl.isNotEmpty) {
      precacheImage(NetworkImage(widget.imageUrl), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.aspectRatio == 0
        ? buildOctoImage(height: null)
        : buildImage();
  }

  Widget buildImage() {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: buildOctoImage(),
    );
  }

  Widget buildOctoImage({double? height = double.infinity}) {
    int cachingHeight = widget.cachingHeight;
    int cachingWidth = widget.cachingWidth;
    if (widget.aspectRatio != 1 && cachingHeight == 720) cachingHeight = 960;
    return OctoImage(
      image: CachedNetworkImageProvider(widget.imageUrl,
          maxWidth: cachingWidth, maxHeight: cachingHeight),
      errorBuilder: (context, url, error) => buildError(),
      fit: BoxFit.cover,
      width: double.infinity,
      height: widget.height ?? height,
      placeholderBuilder: widget.blurHash.isNotEmpty
          ? OctoPlaceholder.blurHash(widget.blurHash)
          : (context) => Center(child: loadingWidget()),
    );
  }

  SizedBox buildError() {
    return SizedBox(
      width: double.infinity,
      height: widget.aspectRatio,
      child: Icon(Icons.warning_amber_rounded,
          size: 50, color: Theme.of(context).focusColor),
    );
  }

  Widget loadingWidget() {
    double aspectRatio = widget.aspectRatio;
    return aspectRatio == 0
        ? buildSizedBox()
        : AspectRatio(
            aspectRatio: aspectRatio,
            child: buildSizedBox(),
          );
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      color: ColorManager.lowOpacityGrey,
    );
  }
}

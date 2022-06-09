import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:octo_image/octo_image.dart';

class NetworkImageDisplay extends StatefulWidget {
  final String imageUrl;
  final String blurHash;
  final BoxFit boxFit;
  final bool circularLoading;
  final double aspectRatio;
  final double bodyHeight;

  const NetworkImageDisplay(
      {Key? key,
      required this.imageUrl,
      this.blurHash = "",
      this.bodyHeight = 0,
      this.aspectRatio = 0,
      this.circularLoading = true,
      this.boxFit = BoxFit.cover})
      : super(key: key);

  @override
  State<NetworkImageDisplay> createState() => _NetworkImageDisplayState();
}

class _NetworkImageDisplayState extends State<NetworkImageDisplay> {
  @override
  void didChangeDependencies() {
    precacheImage(NetworkImage(widget.imageUrl), context);
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

  OctoImage buildOctoImage({double? height = double.infinity}) {
    return OctoImage(
      image: CachedNetworkImageProvider(widget.imageUrl),
      errorBuilder: (context, url, error) => buildError(),
      fit: BoxFit.cover,
      height: height,
      width: double.infinity,
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
      color: ColorManager.black26,
    );
  }
}

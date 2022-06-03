import 'dart:io';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_memory_image_display.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

Future<FutureBuilder<File?>> getImageGallery(
    List<AssetEntity> media, int i) async {
  FutureBuilder<File?> futureBuilder = FutureBuilder(
    future: media[i].file,
    builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        File? image = snapshot.data;
        if (image != null) {
          return Container(
            key: GlobalKey(debugLabel: "exist data"),
            color: Colors.grey,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: MemoryImageDisplay(imagePath: image),
                ),
                if (media[i].type == AssetType.video)
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5, bottom: 5),
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
      }
      return Container(
        key: GlobalKey(debugLabel: "don't exist"),
      );
    },
  );
  return futureBuilder;
}
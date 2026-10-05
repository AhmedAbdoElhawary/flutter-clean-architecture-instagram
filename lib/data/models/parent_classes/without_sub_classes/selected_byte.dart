import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker_plus/image_picker_plus.dart';

class SelectedByte {
  final bool isThatImage;

  /// the web upload takes the bytes, so they're read once when picking
  /// instead of in the widgets that display them.
  final Uint8List selectedByte;
  File selectedFile;

  SelectedByte({
    required this.isThatImage,
    required this.selectedByte,
    required this.selectedFile,
  });

  static Future<SelectedByte> fromPickedItem(PickedItem item) async {
    return SelectedByte(
      isThatImage: item.type == MediaType.image,
      selectedByte: await item.file.readAsBytes(),
      selectedFile: File(item.file.path),
    );
  }
}

class SelectedImagesDetails {
  final List<SelectedByte> selectedFiles;
  final double aspectRatio;
  final bool multiSelectionMode;

  SelectedImagesDetails({
    required this.selectedFiles,
    required this.aspectRatio,
    required this.multiSelectionMode,
  });

  static Future<SelectedImagesDetails> fromPickedItems(
      List<PickedItem> items) async {
    final files = <SelectedByte>[];
    for (final item in items) {
      files.add(await SelectedByte.fromPickedItem(item));
    }
    final first = items[0];

    /// a video picked by the system picker comes back with no size, and the
    /// AspectRatio widget throws on the NaN that 0 / 0 gives
    final hasSize = first.width > 0 && first.height > 0;
    return SelectedImagesDetails(
      selectedFiles: files,
      aspectRatio: hasSize ? first.width / first.height : 1,
      multiSelectionMode: items.length > 1,
    );
  }
}

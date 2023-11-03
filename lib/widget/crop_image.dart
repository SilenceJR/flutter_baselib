import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

typedef CropCallback = Future<Uint8List?> Function();

class CropController {
  CropCallback? _call;

  Future<Uint8List?>? getCropImage() => _call?.call();
}

///裁剪
class CropImageWidget extends StatelessWidget {
  final File? file;
  final String? url;
  final String? asset;
  final Uint8List? bytes;
  final double aspectRatio;
  final CropController? controller;

  final cropKey = GlobalKey<ExtendedImageEditorState>();

  CropImageWidget({this.file, this.url, this.asset, this.bytes, this.aspectRatio = 1.0, this.controller}) {
    controller?._call = () => _crop();
  }

  Future<Uint8List?> _crop() async {
    var state = cropKey.currentState!;
    var image = state.image;
    if (null == image) {
      return null;
    }
    var cropRect = state.getCropRect()!;
    var recorder = PictureRecorder();
    var canvas = Canvas(recorder);
    canvas.drawImage(state.image!, Offset.zero, Paint()..isAntiAlias = true);
    canvas.save();
    canvas.clipRect(cropRect);
    canvas.save();
    var cImage = await recorder.endRecording().toImage(cropRect.width.toInt(), cropRect.height.toInt());
    return (await cImage.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var config = EditorConfig(
        maxScale: 3.0,
        cropRectPadding: EdgeInsets.all(20.0),
        hitTestSize: 20.0,
        cropAspectRatio: aspectRatio,
        lineColor: themeData.primaryColor);

    if (null != file) {
      return ExtendedImage.file(file!, extendedImageEditorKey: cropKey, mode: ExtendedImageMode.editor, fit: BoxFit.contain,
          initEditorConfigHandler: (ExtendedImageState? state) {
        return config;
      });
    }
    if (null != url) {
      return ExtendedImage.network(url!, extendedImageEditorKey: cropKey, mode: ExtendedImageMode.editor, fit: BoxFit.contain,
          initEditorConfigHandler: (ExtendedImageState? state) {
        return config;
      });
    }
    if (null != asset) {
      return ExtendedImage.asset(asset!, extendedImageEditorKey: cropKey, mode: ExtendedImageMode.editor, fit: BoxFit.contain,
          initEditorConfigHandler: (ExtendedImageState? state) {
        return config;
      });
    }
    if (null != bytes) {
      return ExtendedImage.memory(bytes!, extendedImageEditorKey: cropKey, mode: ExtendedImageMode.editor, fit: BoxFit.contain,
          initEditorConfigHandler: (ExtendedImageState? state) {
        return config;
      });
    }
    throw Exception("crop widget image can not be null");
  }
}

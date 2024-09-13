import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static Future hideKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static Future showKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  ///不要放在app顶层
  static void hideKeyboardUnfocus(BuildContext context) {
    var scopeNode = FocusScope.of(context);
    if (!scopeNode.hasPrimaryFocus && null != scopeNode.focusedChild) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static Future<void> copy2Clip(String data) async {
    Clipboard.setData(ClipboardData(text: data));
  }

  static void appMarket(
      {required String applicationId, required String iOSAppId}) async {
    if (Platform.isAndroid) {
      var url = "market://details?id=$applicationId";
      launchUrlString(url);
    }
    if (Platform.isIOS) {
      var url = "itms-apps://itunes.apple.com/app/id$iOSAppId";
      launchUrlString(url);
    }
  }

  ///RepaintBoundary
  static Future<ui.Image> getBoundaryImage(
      {required GlobalKey repaintboundaryKey, double? pixelRatio}) async {
    var context = repaintboundaryKey.currentContext!;
    RenderRepaintBoundary renderObject =
        context.findRenderObject() as RenderRepaintBoundary;
    return renderObject.toImage(
        pixelRatio: pixelRatio ?? MediaQuery.of(context).devicePixelRatio);
  }

  static Future<Uint8List> getBoundaryImageBinary(
      {required ui.Image image}) async {
    var byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
    return byteData;
  }

  ///RepaintBoundary.key.context
  static saveScreenHost2Gallery(GlobalKey repaintboundaryKey,
      {Function(bool res)? done, Function()? error}) async {
    var byteData = await getBoundaryImageBinary(
        image: await getBoundaryImage(repaintboundaryKey: repaintboundaryKey));
    savePic2Gallery(byteData, done: done, error: error);
  }

  static savePic2Gallery(Uint8List byteData,
      {Function(bool res)? done, Function()? error}) async {
    var permission = await Permission.storage.request();
    if (!permission.isGranted) {
      error?.call();
      return;
    }
    var res = await ImageGallerySaver.saveImage(byteData, quality: 100);
    done?.call(res['isSuccess'] == true);
  }

  ///将本地文件存储到媒体库
  static Future saveFile2Gallery(String filePath,
      {String? name, bool isReturnPathOfIOS = false}) async {
    await ImageGallerySaver.saveFile(filePath,
        name: name, isReturnPathOfIOS: isReturnPathOfIOS);
  }
}

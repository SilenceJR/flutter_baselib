import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_save/image_save.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static void hideKeyboard([BuildContext? context]) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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

  static void appMarket({required String applicationId, required String iOSAppId}) async {
    if (Platform.isAndroid) {
      var url = "market://details?id=$applicationId";
      if (await canLaunch(url)) {
        launch(url);
      }
    }
    if (Platform.isIOS) {
      var url = "itms-apps://itunes.apple.com/app/id$iOSAppId";
      if (await canLaunch(url)) {
        launch(url);
      }
    }
  }

  static String hideMobile(String mobile) {
    if (mobile.length > 4) {
      try {
        return mobile.replaceFirst(RegExp(r'\d{4}'), '****', 3);
      } catch (e) {
        return mobile;
      }
    }
    return mobile;
  }

  ///RepaintBoundary
  static save2Gallery(BuildContext context, {Function(bool res)? done, Function()? error}) async {
    var permission = await Permission.storage.request();
    if (!permission.isGranted) {
      error?.call();
      return;
    }
    RenderRepaintBoundary renderObject = context.findRenderObject() as RenderRepaintBoundary;
    var image = await renderObject.toImage(pixelRatio: MediaQuery.of(context).devicePixelRatio);
    var byteData = (await image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
    var res = await ImageSave.saveImage(byteData, "image_${DateTime.now().second}.jpg");
    // await ImageGallerySaver.saveImage(byteData, quality: 100);
    done?.call(res==true);
  }
}

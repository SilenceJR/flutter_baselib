import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
}

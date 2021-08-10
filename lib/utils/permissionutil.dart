import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PermissionUtil {
  static Future checkPermissionFunc(FutureOr<bool> permission, {Function? grantedFunc, Function? deniedFunc, String? desc}) async {
    ((permission is Future) ? await permission : permission)
        ? grantedFunc?.call()
        : null != deniedFunc
            ? deniedFunc.call()
            : Get.dialog(CupertinoAlertDialog(
                title: Text("no_permission".tr),
                content: Text(desc ?? "permission_desc".tr),
                actions: [
                  CupertinoDialogAction(
                    child: Text("confirm".tr),
                    onPressed: () async {
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }
                      openSettings();
                    },
                    isDestructiveAction: true,
                  ),
                ],
              ));
  }

  static Future<bool> checkPermission(List<Permission> permissions, {String? desc}) async {
    Map<Permission, PermissionStatus> request = await permissions.request();
    var isGranted = true;
    request.forEach((key, value) {
      print("权限--${key.toString()}----->${value.toString()}");
      isGranted = isGranted && value.isGranted;
    });
    if (!isGranted) {
      Get.dialog(CupertinoAlertDialog(
        title: Text("no_permission".tr),
        content: Text(desc ?? "permission_desc".tr),
        actions: [
          CupertinoDialogAction(
            child: Text("confirm".tr),
            onPressed: () async {
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }
              openSettings();
            },
            isDestructiveAction: true,
          ),
        ],
      ));
    }
    return isGranted;
  }

  static void openSettings() {
    PhotoManager.openSetting();
  }
}

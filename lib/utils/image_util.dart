import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'permissionutil.dart';
import 'package:baselib/ext/ext.dart';

class GetImageUtil {
  static pickImage(ValueChanged<File> valueChanged,
      {Text? title, int maxSelect = 1, bool camera = true, int quality = 80, int targetWidth = 0, int targetHeight = 0}) {
    var actions = <CupertinoActionSheetAction>[];
    if (camera) {
      actions.add(CupertinoActionSheetAction(
          onPressed: () async {
            Get.back();
            getImageFromCamera(valueChanged, quality: quality, targetWidth: targetWidth, targetHeight: targetHeight);
          },
          child: Text("camera".tr)));
    }
    actions.add(CupertinoActionSheetAction(
        onPressed: () async {
          Get.back();
          getImageFromGallery(valueChanged, maxSelect: maxSelect, quality: quality, targetWidth: targetWidth, targetHeight: targetHeight);
        },
        child: Text("gallery".tr)));
    Get.showBottomSheet(CupertinoActionSheet(
      title: title,
      actions: actions,
      cancelButton: CupertinoActionSheetAction(
        child: Text("cancel".tr),
        isDestructiveAction: true,
        onPressed: () {
          Get.back();
        },
      ),
    ));
  }

  static getImageFromGallery(ValueChanged<File> valueChanged, {int maxSelect = 1, int quality = 80, int targetWidth = 0, int targetHeight = 0}) {
    try {
      PermissionUtil.checkPermissionFunc(PhotoManager.requestPermission(), desc: "permission_gallery_desc".tr, grantedFunc: () async {
        List<AssetEntity>? pickAssets = await AssetPicker.pickAssets(Get.context!,
            pickerTheme: AssetPicker.themeData(Get.theme.primaryColor), maxAssets: maxSelect, requestType: RequestType.image);
        if (null != pickAssets && pickAssets.isNotEmpty) {
          var assetEntity = pickAssets[0];
          var file = await assetEntity.originFile;
          if (null != file) {
            var compressFile = await compressImage(file, quality: quality, targetWidth: targetWidth, targetHeight: targetHeight);
            valueChanged.call(compressFile ?? file);
          }
        }
      });
    } catch (e) {
      print("$e");
    }
  }

  static getImageFromCamera(ValueChanged<File> valueChanged, {int quality = 80, int targetWidth = 0, int targetHeight = 0}) {
    try {
      PermissionUtil.checkPermissionFunc(PhotoManager.requestPermission(), desc: "permission_camera_desc".tr, grantedFunc: () async {
        AssetEntity? assetEntity = await CameraPicker.pickFromCamera(Get.context!, theme: CameraPicker.themeData(Get.theme.primaryColor));
        if (null != assetEntity) {
          var file = await assetEntity.file;
          if (null != file) {
            var compressFile = await compressImage(file, quality: quality, targetHeight: targetHeight, targetWidth: targetWidth);
            valueChanged.call(compressFile ?? file);
          }
        }
      });
    } catch (e) {
      print("$e");
    }
  }

  static Future<File?> compressImage(File imageFile, {int quality = 80, int targetWidth = 0, int targetHeight = 0}) async {
    File compressImage =
        await FlutterNativeImage.compressImage(imageFile.path, quality: quality, targetWidth: targetWidth, targetHeight: targetHeight);
    return compressImage;
  }

  Future<File?> cropImage(File imageFile, {int width = 800, int height = 800}) async {
    return await FlutterNativeImage.cropImage(imageFile.path, 0, 0, width, height);
  }
}

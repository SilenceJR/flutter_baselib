import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_baselib/baselib.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
// import 'package:video_compress/video_compress.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

export 'package:wechat_assets_picker/wechat_assets_picker.dart' hide NotifyManager;

class UpFile {
  File file;
  String title;

  UpFile({required this.file, this.title = ""});
}

class PickImageUtil {
  static pickImageFromGallery(ValueChanged<UpFile> valueChanged,
      {int maxSelect = 1,
      int quality = 80,
      int targetWidth = 0,
      int targetHeight = 0,
      bool compress = false,
      int? maxLength,
      RequestType type = RequestType.image,
      Function(int length)? onOverflow,
      Function(Map<Permission, PermissionStatus> p)? deniedFunc}) {
    try {
      PermissionUtil.checkPermission(PermissionUtil.galleryPermission, deniedFunc: deniedFunc, grantedFunc: () async {
        List<AssetEntity>? pickAssets = await AssetPicker.pickAssets(
          Get.context!,
          pickerConfig: AssetPickerConfig(
              pickerTheme: AssetPicker.themeData(Get.theme.primaryColor),
              sortPathDelegate: CustomSortPathDelegate(),
              maxAssets: maxSelect,
              requestType: type),
          useRootNavigator: true,
        );
        if (null != pickAssets && pickAssets.isNotEmpty) {
          var assetEntity = pickAssets[0];
          var file = await assetEntity.originFile;
          if (null != file) {
            if (null != maxLength) {
              var length = await file.length();
              if (length > maxLength) {
                onOverflow?.call(length);
                return;
              }
            }
            if (compress) {
              if (type == RequestType.image) {
                file = (await compressImage(file.path,
                        quality: quality, targetWidth: targetWidth, targetHeight: targetHeight)) ??
                    file;
              }
              // else if (type == RequestType.video) {
              //   file = (await compressVideo(file.path))?.file ?? file;
              // }
            }
            valueChanged.call(UpFile(file: file, title: await assetEntity.titleAsync));
          }
        }
      });
    } catch (e) {
      print("$e");
    }
  }

  static pickImageFromCamera(
    ValueChanged<UpFile> valueChanged, {
    int quality = 80,
    int targetWidth = 0,
    int targetHeight = 0,
    bool compress = false,
    Function(Map<Permission, PermissionStatus> p)? deniedFunc,
  }) {
    try {
      PermissionUtil.checkPermission(PermissionUtil.galleryPermission, deniedFunc: deniedFunc, grantedFunc: () async {
        AssetEntity? assetEntity = await CameraPicker.pickFromCamera(
          Get.context!,
          useRootNavigator: true,
          pickerConfig: CameraPickerConfig(theme: CameraPicker.themeData(Get.theme.primaryColor)),
        );
        if (null != assetEntity) {
          var file = await assetEntity.file;
          if (null != file) {
            if (compress) {
              file = (await compressImage(file.path,
                      quality: quality, targetHeight: targetHeight, targetWidth: targetWidth)) ??
                  file;
            }
            valueChanged.call(UpFile(file: file, title: await assetEntity.titleAsync));
          }
        }
      });
    } catch (e) {
      print("$e");
    }
  }

  // static Future<MediaInfo?> compressVideo(String filePath) async {
  //   return await VideoCompress.compressVideo(filePath, quality: VideoQuality.DefaultQuality);
  // }

  static Future<File?> compressImage(String imgPath,
      {int quality = 80, int targetWidth = 0, int targetHeight = 0}) async {
    File compressImage = await FlutterNativeImage.compressImage(imgPath,
        quality: quality, targetWidth: targetWidth, targetHeight: targetHeight);
    return compressImage;
  }

  Future<File?> cropImage(File imageFile, {int width = 800, int height = 800}) async {
    return await FlutterNativeImage.cropImage(imageFile.path, 0, 0, width, height);
  }
}

/// 构建你自己的排序
class CustomSortPathDelegate extends CommonSortPathDelegate {
  const CustomSortPathDelegate();

  @override
  void sort(List<PathWrapper<AssetPathEntity>> list) {
    // 在这里你可以对每个你认为需要的路径进行判断。
    // 我们唯一推荐更改的属性是 [name]，
    // 并且我们不对更改其他属性造成的问题负责。
   /* var iterator = list.iterator;
    while (iterator.moveNext()) {
      var entity = iterator.current;
      if (entity is AssetPathEntity && (entity as AssetPathEntity).isAll) {
        var indexOf = list.indexOf(entity);
        list.remove(entity);
        list.insert(indexOf, entity.copyWith(name: "全部"));
      }
    }*/
  }
}

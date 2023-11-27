// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_baselib/baselib.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:wechat_camera_picker/wechat_camera_picker.dart';
// import 'package:get/get.dart';
//
// export 'package:wechat_assets_picker/wechat_assets_picker.dart' hide NotifyManager;
//
// class UpFile {
//   File file;
//   String title;
//
//   UpFile({required this.file, this.title = ""});
// }
//
// class PickImageUtil {
//   static pickImageFromGallery(ValueChanged<UpFile> valueChanged,
//       {int maxSelect = 1,
//       int quality = 80,
//       int targetWidth = 0,
//       int targetHeight = 0,
//       bool compress = false,
//       int? maxLength,
//       RequestType type = RequestType.image,
//       SortPathDelegate<AssetPathEntity>? sortPathDelegate,
//       Function(int length)? onOverflow,
//       Function(Map<Permission, PermissionStatus> p)? deniedFunc}) {
//     try {
//       PermissionUtil.checkPermission(PermissionUtil.galleryPermission, deniedFunc: deniedFunc, grantedFunc: () async {
//         List<AssetEntity>? pickAssets = await AssetPicker.pickAssets(
//           Get.context!,
//           pickerConfig: AssetPickerConfig(
//               pickerTheme: AssetPicker.themeData(Get.theme.primaryColor),
//               sortPathDelegate: sortPathDelegate,
//               maxAssets: maxSelect,
//               requestType: type),
//           useRootNavigator: true,
//         );
//         if (null != pickAssets && pickAssets.isNotEmpty) {
//           var assetEntity = pickAssets[0];
//           var file = await assetEntity.originFile;
//           if (null != file) {
//             if (null != maxLength) {
//               var length = await file.length();
//               if (length > maxLength) {
//                 onOverflow?.call(length);
//                 return;
//               }
//             }
//             if (compress) {
//               if (type == RequestType.image) {
//                 file = (await compressImage(file.path,
//                         quality: quality, targetWidth: targetWidth, targetHeight: targetHeight)) ??
//                     file;
//               }
//               // else if (type == RequestType.video) {
//               //   file = (await compressVideo(file.path))?.file ?? file;
//               // }
//             }
//             valueChanged.call(UpFile(file: file, title: await assetEntity.titleAsync));
//           }
//         }
//       });
//     } catch (e) {
//       print("$e");
//     }
//   }
//
//   static pickImageFromCamera(
//     ValueChanged<UpFile> valueChanged, {
//     int quality = 80,
//     int targetWidth = 0,
//     int targetHeight = 0,
//     bool compress = false,
//     Function(Map<Permission, PermissionStatus> p)? deniedFunc,
//   }) {
//     try {
//       PermissionUtil.checkPermission(PermissionUtil.galleryPermission, deniedFunc: deniedFunc, grantedFunc: () async {
//         AssetEntity? assetEntity = await CameraPicker.pickFromCamera(
//           Get.context!,
//           useRootNavigator: true,
//           pickerConfig: CameraPickerConfig(theme: CameraPicker.themeData(Get.theme.primaryColor)),
//         );
//         if (null != assetEntity) {
//           var file = await assetEntity.file;
//           if (null != file) {
//             if (compress) {
//               file = (await compressImage(file.path,
//                       quality: quality, targetHeight: targetHeight, targetWidth: targetWidth)) ??
//                   file;
//             }
//             valueChanged.call(UpFile(file: file, title: await assetEntity.titleAsync));
//           }
//         }
//       });
//     } catch (e) {
//       print("$e");
//     }
//   }
//
//   static Future<File?> compressImage(String imgPath,
//       {int quality = 80, int targetWidth = 0, int targetHeight = 0}) async {
//     File compressImage = await FlutterNativeImage.compressImage(imgPath,
//         quality: quality, targetWidth: targetWidth, targetHeight: targetHeight);
//     return compressImage;
//   }
//
//   Future<File?> cropImage(File imageFile, {int width = 800, int height = 800}) async {
//     return await FlutterNativeImage.cropImage(imageFile.path, 0, 0, width, height);
//   }
// }

import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

export 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future checkPermission(List<Permission> permissions,
      {Function? grantedFunc, Function(Map<Permission, PermissionStatus> p)? deniedFunc}) async {
    Map<Permission, PermissionStatus> request = await permissions.request();
    request.removeWhere((key, value) => value.isGranted);
    if (request.isEmpty) {
      grantedFunc?.call();
    } else {
      deniedFunc?.call(request);
    }
  }

  static void openSettings() {
    PhotoManager.openSetting();
  }

  static List<Permission> locationPermission = [
    Permission.location,
    Permission.locationWhenInUse,
  ];

  static List<Permission> galleryPermission = [
    Permission.camera,
    Permission.photos,
  ];

  static List<Permission> audioPermission = [
    Permission.storage,
    Permission.microphone,
  ];

  static List<Permission> notifyPermission = [
    Permission.notification,
  ];
}

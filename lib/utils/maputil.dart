import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher_string.dart';


class MapUtil {
  static getMaps() {}

  static toMapNavigation(String title, latitude, longitude) async {
    var isAndroid = Platform.isAndroid;
    var isIOS = Platform.isIOS;
    // 在app上没有安装导航的时候 默认
    var htmlMapUrl =
        "https://uri.amap.com/marker?position=$longitude,$latitude";
    var childView = <Widget>[];
    if (isAndroid || isIOS) {
      //apple
      if (isIOS) {
        var appleUrl = "https://maps.apple.com/?&daddr=$latitude,$longitude";
        var appleAction = await _getMapAction("apple_map", appleUrl, appleUrl);
        if (null != appleAction) {
          childView.add(appleAction);
        }
      }
      var packageInfo = await PackageInfo.fromPlatform();
      //高德
      var aMapScheme = "${isIOS ? 'ios' : 'android'}amap://navi";
      var aMapUrl =
          "$aMapScheme?sourceApplication=${packageInfo.packageName}&lat=$latitude&lon=$longitude&dev=0&style=2";
      var amapAction = await _getMapAction("amap", aMapScheme, aMapUrl);
      if (null != amapAction) {
        childView.add(amapAction);
      }
      //腾讯
      var qqMapScheme = "qqmap://";
      var qqMapUrl =
          '${qqMapScheme}map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77';
      var qqAction = await _getMapAction("tencent_map", qqMapScheme, qqMapUrl);
      if (null != qqAction) {
        childView.add(qqAction);
      }
      //百度
      var baiduScheme = "baidumap://map";
      var baiduMapUrl =
          '$baiduScheme/direction?destination=$latitude,$longitude&coord_type=gcj02&mode=driving';
      var baiduAction =
          await _getMapAction("baidu_map", baiduScheme, baiduMapUrl);
      if (null != baiduAction) {
        childView.add(baiduAction);
      }
      //google map
      var gmapScheme = "comgooglemaps://";
      var gmapUrl = isIOS
          ? "$gmapScheme?daddr=$latitude,$longitude&directionsmode=driving"
          : "https://maps.google.com/maps?daddr=$latitude,$longitude&directionsmode=driving";
      var gAction = await _getMapAction("google_map", gmapUrl, gmapUrl);
      if (null != gAction) {
        childView.add(gAction);
      }
    }
    childView.add(CupertinoActionSheetAction(
      child: Text("web_navigation"),
      onPressed: () => launchUrlString(htmlMapUrl),
    ));
    // Get.bottomSheet(
    //   CupertinoActionSheet(
    //     title: Text(title),
    //     actions: childView,
    //     cancelButton: CupertinoActionSheetAction(
    //         isDestructiveAction: true,
    //         onPressed: () {
    //           if (Get.isDialogOpen! || Get.isBottomSheetOpen!) {
    //             Get.back();
    //           }
    //         },
    //         child: Text("cancel")),
    //   ),
    // );
  }

  static Future<CupertinoActionSheetAction?> _getMapAction(
      String title, String mapScheme, String mapUrl) async {
    if (await canLaunchUrlString(mapScheme)) {
      return CupertinoActionSheetAction(
        child: Text(title),
        onPressed: () {
          launchUrlString(mapUrl);
          // Get.back();
        },
      );
    }
    return null;
  }
}

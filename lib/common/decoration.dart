import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RStyle {
  ///输入框
  /// 底部边框
  static final BoxDecoration bottomLineDecoration = BoxDecoration(
      border: BorderDirectional(
    bottom: BorderSide(color: Get.theme.dividerColor, width: 0.5),
  ));
}

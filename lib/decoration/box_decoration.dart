import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

///输入框
/// 底部边框
BoxDecoration bottomLineDecoration = BoxDecoration(
    border: BorderDirectional(bottom: BorderSide(color: Get.theme.dividerColor, width: Get.theme.dividerTheme.thickness ?? 0.5)));

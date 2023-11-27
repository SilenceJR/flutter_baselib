import '../utils/util.dart';
import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  /// 放在 build(context) 下 rootWidget
  Widget tapUnfocus(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Utils.hideKeyboardUnfocus(context);
        },
        child: this);
  }

  Widget elevation(double elevation,
      {Color? color, Color? shadowColor, BorderRadius? borderRadius}) {
    return Material(
        elevation: elevation,
        color: color,
        shadowColor: shadowColor,
        borderRadius: borderRadius,
        child: this);
  }

  Widget gesture(GestureTapCallback onTap,
      {HitTestBehavior behavior = HitTestBehavior.opaque,
      GestureTapCallback? onDoubleTap}) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: this,
    );
  }
}

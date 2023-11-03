import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baselib/baselib.dart';

class ContainerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final Size? size;
  final Alignment? alignment;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? elevation;

  ContainerAppBar({Key? key, required this.child, this.size, this.alignment, this.padding, this.backgroundColor, this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appBarTheme = Theme.of(context).appBarTheme;
    var overlayStyle = _systemOverlayStyleForBrightness(
        null != backgroundColor ? ThemeData.estimateBrightnessForColor(backgroundColor!) : Theme.of(context).brightness);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
            color: backgroundColor ?? appBarTheme.backgroundColor,
            elevation: this.elevation ?? appBarTheme.elevation ?? 2,
            shadowColor: appBarTheme.shadowColor,
            child: SafeArea(
                child: Container(
                    alignment: alignment ?? Alignment.center,
                    padding: padding ?? EdgeInsets.symmetric(horizontal: NavigationToolbar.kMiddleSpacing, vertical: 5),
                    constraints: BoxConstraints(minHeight: kToolbarHeight),
                    child: child))));
  }

  @override
  Size get preferredSize => this.size ?? Size.fromHeight(kToolbarHeight);

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
  }
}


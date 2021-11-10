import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ContainerAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget child;
  final Size? size;
  final Alignment? alignment;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? elevation;

  ContainerAppBar({required this.child, this.size, this.alignment, this.padding, this.backgroundColor, this.elevation});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light,
        child: Material(
            color: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
            elevation: this.elevation ?? Theme.of(context).appBarTheme.elevation ?? 2,
            shadowColor: Theme.of(context).appBarTheme.shadowColor,
            child: SafeArea(
                child: Container(
                    alignment: alignment ?? Alignment.bottomCenter,
                    padding: padding ?? EdgeInsets.symmetric(horizontal: NavigationToolbar.kMiddleSpacing, vertical: 5),
                    constraints: BoxConstraints(minHeight: kToolbarHeight),
                    child: child))));
  }

  @override
  Size get preferredSize => this.size ?? Size.fromHeight(kToolbarHeight);
}

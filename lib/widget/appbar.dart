import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ContainerAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget child;
  final Size? size;
  final Alignment? alignment;
  final EdgeInsets? padding;

  ContainerAppBar({required this.child, this.size, this.alignment, this.padding});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: Material(
            elevation: Theme.of(context).appBarTheme.elevation ?? 2,
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

//
class CommAppBar extends AppBar {
  CommAppBar({
    Key? key,
    VoidCallback? leadingCallback,
    bool defalutLeading = true,
    String? titleStr,
    Widget? leading,
    bool automaticallyImplyLeading = false,
    Widget? title,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double elevation = 2,
    Color? shadowColor,
    ShapeBorder? shape,
    Color? backgroundColor,
    Brightness? brightness,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    TextTheme? textTheme,
    bool primary = true,
    bool? centerTitle,
    bool excludeHeaderSemantics = false,
    double titleSpacing = NavigationToolbar.kMiddleSpacing,
    double toolbarOpacity = 1.0,
    double bottomOpacity = 1.0,
    double? toolbarHeight,
    double? leadingWidth,
  }) : super(
            key: key,
            leading: leading ??
                (defalutLeading
                    ? BackButton(
                        onPressed: () => null == leadingCallback ? Get.back() : leadingCallback(),
                      )
                    : null),
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: DefaultTextStyle(style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500), child: title ?? Text(titleStr ?? "")),
            actions: actions,
            flexibleSpace: flexibleSpace,
            bottom: bottom,
            elevation: elevation,
            shadowColor: shadowColor,
            shape: shape,
            backgroundColor: backgroundColor,
            brightness: brightness,
            iconTheme: iconTheme,
            actionsIconTheme: actionsIconTheme,
            textTheme: textTheme,
            primary: primary,
            centerTitle: centerTitle,
            excludeHeaderSemantics: excludeHeaderSemantics,
            titleSpacing: titleSpacing,
            toolbarOpacity: toolbarOpacity,
            bottomOpacity: bottomOpacity,
            toolbarHeight: toolbarHeight,
            leadingWidth: leadingWidth);
}

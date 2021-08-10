import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyDataWidget extends StatelessWidget {
  final Widget child;
  final bool empty;
  final Widget? tip;
  final Color? bgColor;
  final Alignment? alignment;
  final bool constraints;
  final bool refreshing;
  final Widget? refreshWidget;

  EmptyDataWidget(
      {Key? key,
      required this.child,
      this.bgColor,
      this.empty = false,
      this.tip,
      this.alignment,
      this.constraints = true,
      this.refreshing = false,
      this.refreshWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return refreshing
        ? refreshWidget ?? Center(child: CupertinoActivityIndicator())
        : empty
            ? Container(
                color: bgColor,
                child: Column(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Container(
                          alignment: alignment ?? Alignment.center,
                          constraints: BoxConstraints(
                              maxWidth: constraints ? min(size.width, size.height) * 0.5 : double.infinity),
                          child: tip,
                        )),
                    Expanded(
                      child: Container(),
                      flex: 4,
                    ),
                  ],
                ),
              )
            : child;
  }
}

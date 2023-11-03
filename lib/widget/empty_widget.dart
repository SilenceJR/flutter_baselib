import 'dart:math';

import 'package:flutter/cupertino.dart';

class EmptyDataWidget extends StatelessWidget {
  final Widget child;
  final bool empty;
  final Widget? tip;
  final Alignment? alignment;
  final BoxConstraints? tipConstraints;
  final bool refreshing;
  final bool stack;
  final Widget? refreshWidget;

  EmptyDataWidget(
      {Key? key,
      required this.child,
      this.tip,
      this.alignment,
      this.stack = true,
      this.empty = false,
      this.refreshing = false,
      this.tipConstraints,
      this.refreshWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget? tipWidget = null;
    if (refreshing) {
      tipWidget = Center(child: refreshWidget ?? SizedBox(child: Center(child: CupertinoActivityIndicator()), height: 50));
    } else if (empty) {
      tipWidget = Container(
          alignment: alignment ?? Alignment.center,
          child: ConstrainedBox(constraints: tipConstraints ?? BoxConstraints(maxWidth: min(size.width, size.height) * 0.5), child: tip));
    }
    return stack
        ? Stack(children: [child, Visibility(visible: null != tipWidget, child: SizedBox(child: tipWidget))])
        : (tipWidget ?? child);
  }

/* @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return refreshing
        ? refreshWidget ?? SizedBox(child: Center(child: CupertinoActivityIndicator()), height: 50)
        : empty
        ? Container(
        color: bgColor,
        alignment: alignment ?? Alignment.center,
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints ? min(size.width, size.height) * 0.5 : double.infinity), child: tip))
        : child;
  }*/
}

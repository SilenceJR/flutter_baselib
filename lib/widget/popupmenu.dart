import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PopPosition {
  static const AUTO = 0;
  static const LEFT = 1;
  static const TOP = 2;
  static const RIGHT = 3;
  static const BOTTOM = 4;
}

class PopupWindow extends StatefulWidget {
  static Future<T?> show<T>(
      {required BuildContext context, required GlobalKey widgetKey, required int popPosition, required Widget child, Offset offset = Offset.zero}) {
    return Navigator.push(context, PopRoute<T>(widgetKey: widgetKey, popPosition: popPosition, child: child, offset: offset));
  }

  final GlobalKey widgetKey;
  final int popPosition;
  final Widget child;
  final Offset offset;

  PopupWindow({required this.widgetKey, required this.popPosition, required this.child, this.offset = Offset.zero});

  @override
  State<StatefulWidget> createState() => _PopWindowState();
}

class _PopWindowState extends State<PopupWindow> with TickerProviderStateMixin {
  final childKey = GlobalKey();
  var left = 0.0;
  var top = 0.0;
  late AnimationController animCl;
  Animation<double>? animate;

  @override
  void initState() {
    super.initState();
    animCl = AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    var size = MediaQuery.of(widget.widgetKey.currentContext!).size;
    left = -size.width;
    top = -size.height;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      RenderBox renderObj = widget.widgetKey.currentContext!.findRenderObject() as RenderBox;
      var localToGlobal = renderObj.localToGlobal(Offset.zero);
      var widgetSize = renderObj.size;
      var childBox = childKey.currentContext!.findRenderObject() as RenderBox;
      var childSize = childBox.size;
      switch (widget.popPosition) {
        case PopPosition.LEFT:
          top = localToGlobal.dy;
          left = localToGlobal.dx - childSize.width;
          break;
        case PopPosition.TOP:
          top = localToGlobal.dy - childSize.height;
          left = localToGlobal.dx;
          break;
        case PopPosition.RIGHT:
          top = localToGlobal.dy;
          left = localToGlobal.dx + childSize.width;
          break;
        case PopPosition.BOTTOM:
          top = localToGlobal.dy + widgetSize.height;
          left = localToGlobal.dx;
          break;
      }
      top += widget.offset.dy;
      left += widget.offset.dx;
      if (top < 0) {
        top = 0;
      }
      if (top > (size.height - childSize.height)) {
        top = size.height - childSize.height;
      }
      if (left < 0) {
        left = 0;
      }
      if (left > (size.width - childSize.width)) {
        left = size.width - childSize.width;
      }
      animate = Tween(begin: 0.0, end: childSize.height).animate(animCl);
      setState(() {});
      animCl.forward();
    });
  }

  @override
  void dispose() {
    animCl.stop();
    animCl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: left,
            top: top,
            child: Material(
                type: MaterialType.transparency,
                child: AnimatedBuilder(
                    animation: animCl,
                    builder: (BuildContext context, Widget? child) =>
                        Container(key: childKey, height: null != animate ? animate!.value : null, child: widget.child))))
      ],
    );
  }
}

class PopRoute<T> extends PopupRoute<T> {
  final GlobalKey widgetKey;
  final int popPosition;
  final Widget child;
  final Offset offset;

  PopRoute({required this.widgetKey, required this.popPosition, required this.child, this.offset = Offset.zero});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return PopupWindow(widgetKey: widgetKey, popPosition: popPosition, child: child, offset: offset);
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);
}

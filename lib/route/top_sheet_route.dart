import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/router_report.dart';

class TopSheetRoute<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final Color? _barrierColor;
  final bool isScrollControlled;
  final bool? ignoreSafeArea;
  final double? elevation;
  final bool? _barrierDismissible;
  final EdgeInsetsGeometry? offset;

  TopSheetRoute(
      {required this.builder,
      this.ignoreSafeArea,
      this.elevation,
      Color? barrierColor,
      bool? barrierDismissible,
      this.isScrollControlled = false,
      this.offset,
      RouteSettings? settings})
      : _barrierColor = barrierColor,
        _barrierDismissible = barrierDismissible,
        super(settings: settings) {
    RouterReportManager.reportCurrentRoute(this);
  }

  @override
  Color? get barrierColor => _barrierColor ?? Colors.black38;

  @override
  bool get barrierDismissible => _barrierDismissible ?? true;

  @override
  String? get barrierLabel => null;

  AnimationController? _animationController;

  @override
  void dispose() {
    RouterReportManager.reportRouteDispose(this);
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: ignoreSafeArea ?? false,
      child: Padding(
        padding: offset ?? EdgeInsets.zero,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Semantics(
              scopesRoute: true,
              namesRoute: true,
              label: barrierLabel,
              explicitChildNodes: true,
              child: ClipRect(
                  child: CustomSingleChildLayout(
                      delegate: _TopSheetLayoutDelegate(animation.value, this.isScrollControlled),
                      child: Material(
                          color: Colors.transparent,
                          elevation: elevation ?? 0,
                          child: Align(alignment: Alignment.topCenter, child: this.builder(context)))))),
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 250);

  @override
  AnimationController createAnimationController() {
    _animationController = BottomSheet.createAnimationController(navigator!.overlay!);
    _animationController!.duration = transitionDuration;
    _animationController!.reverseDuration = reverseTransitionDuration;
    return _animationController!;
  }
}

class _TopSheetLayoutDelegate extends SingleChildLayoutDelegate {
  double process;
  final bool isScrollControlled;

  _TopSheetLayoutDelegate(this.process, this.isScrollControlled);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: isScrollControlled ? constraints.maxHeight : constraints.maxHeight * 9.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0, size.height * process - size.height);
  }

  @override
  bool shouldRelayout(covariant _TopSheetLayoutDelegate oldDelegate) {
    return this.process != oldDelegate.process;
  }
}
